#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gf_morphosqi_lint.py

Lint MorphoSqi.gf for the *same classes of failures* we hit in this conversation:
  1) mkN### circular definitions / cycles
  2) "cannot infer table type" hazards: untyped string-pattern tables like
       table { _ + "a" => ... ; ... ; _ => ... }
  3) Likely syntax hazards:
       - unbalanced {} () in mkN blocks
       - missing ';' between top-level table arms

Usage:
  python gf_morphosqi_lint.py path\to\MorphoSqi.gf
"""

from __future__ import annotations

import argparse
import re
from collections import defaultdict
from dataclasses import dataclass
from typing import Dict, List, Set, Tuple, Iterable, Optional


MK_DEF_RE = re.compile(r"^(mkN\d+)\b[^=]*=")          # definition line (column 0)
MK_ANY_RE = re.compile(r"\bmkN\d+\b")                # any mkN reference


@dataclass(frozen=True)
class Finding:
    kind: str
    line: int
    msg: str
    preview: str = ""


def read_text(path: str) -> str:
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        return f.read()


def strip_line_comments_preserve_strings(text: str) -> str:
    """
    Remove GF line comments starting with '--' when outside strings.
    Keeps line count identical.
    """
    out_lines: List[str] = []
    for line in text.splitlines(True):
        i = 0
        in_str = False
        while i < len(line):
            ch = line[i]
            if in_str:
                if ch == "\\" and i + 1 < len(line):
                    i += 2
                    continue
                if ch == '"':
                    in_str = False
                i += 1
                continue

            if ch == '"':
                in_str = True
                i += 1
                continue

            if ch == "-" and i + 1 < len(line) and line[i + 1] == "-":
                # comment start outside string
                line = line[:i] + ("\n" if line.endswith("\n") else "")
                break
            i += 1

        out_lines.append(line)
    return "".join(out_lines)


def index_to_line(text: str, idx: int) -> int:
    # 1-based line number
    return text.count("\n", 0, idx) + 1


def extract_mk_defs(text: str) -> Tuple[Dict[str, Tuple[int, int, str]], List[str]]:
    lines = text.splitlines()
    starts: List[Tuple[str, int]] = []
    for i, ln in enumerate(lines):
        m = MK_DEF_RE.match(ln)
        if m:
            starts.append((m.group(1), i))

    defs: Dict[str, Tuple[int, int, str]] = {}
    for j, (name, start) in enumerate(starts):
        end = starts[j + 1][1] if j + 1 < len(starts) else len(lines)
        body = "\n".join(lines[start:end])
        defs[name] = (start + 1, end, body)  # store 1-based start line
    return defs, lines


def build_mk_graph(defs: Dict[str, Tuple[int, int, str]]) -> Dict[str, Set[str]]:
    g: Dict[str, Set[str]] = defaultdict(set)
    for name, (_start_line, _end, body) in defs.items():
        calls = set(MK_ANY_RE.findall(body))
        calls.discard(name)
        for c in calls:
            if c in defs:
                g[name].add(c)
    return g


def tarjan_scc(graph: Dict[str, Set[str]]) -> List[List[str]]:
    index = 0
    stack: List[str] = []
    onstack: Set[str] = set()
    idx: Dict[str, int] = {}
    low: Dict[str, int] = {}
    comps: List[List[str]] = []

    def strong(v: str) -> None:
        nonlocal index
        idx[v] = index
        low[v] = index
        index += 1
        stack.append(v)
        onstack.add(v)

        for w in graph.get(v, set()):
            if w not in idx:
                strong(w)
                low[v] = min(low[v], low[w])
            elif w in onstack:
                low[v] = min(low[v], idx[w])

        if low[v] == idx[v]:
            comp: List[str] = []
            while True:
                w = stack.pop()
                onstack.remove(w)
                comp.append(w)
                if w == v:
                    break
            comps.append(comp)

    for v in graph.keys():
        if v not in idx:
            strong(v)
    return comps


def check_balance(text: str) -> Tuple[int, int]:
    """
    Returns (brace_delta, paren_delta) ignoring strings.
    Positive means more opens than closes at EOF.
    """
    brace = 0
    paren = 0
    in_str = False
    esc = False
    for ch in text:
        if in_str:
            if esc:
                esc = False
            elif ch == "\\":
                esc = True
            elif ch == '"':
                in_str = False
            continue
        else:
            if ch == '"':
                in_str = True
                continue
            if ch == "{":
                brace += 1
            elif ch == "}":
                brace -= 1
            elif ch == "(":
                paren += 1
            elif ch == ")":
                paren -= 1
    return brace, paren


def iter_table_blocks(text: str) -> Iterable[Tuple[int, int, int]]:
    """
    Yield (table_kw_idx, brace_open_idx, brace_close_idx) for each `table { ... }`,
    ignoring strings.
    """
    i = 0
    n = len(text)
    in_str = False
    esc = False

    def is_word_char(c: str) -> bool:
        return c.isalnum() or c == "_"

    while i < n:
        ch = text[i]

        if in_str:
            if esc:
                esc = False
            elif ch == "\\":
                esc = True
            elif ch == '"':
                in_str = False
            i += 1
            continue

        if ch == '"':
            in_str = True
            i += 1
            continue

        # word boundary check for "table"
        if text.startswith("table", i):
            prev = text[i - 1] if i > 0 else " "
            nxt = text[i + 5] if i + 5 < n else " "
            if not is_word_char(prev) and not is_word_char(nxt):
                j = i + 5
                while j < n and text[j].isspace():
                    j += 1
                if j < n and text[j] == "{":
                    brace_open = j
                    depth = 0
                    k = brace_open
                    in_str2 = False
                    esc2 = False
                    while k < n:
                        c2 = text[k]
                        if in_str2:
                            if esc2:
                                esc2 = False
                            elif c2 == "\\":
                                esc2 = True
                            elif c2 == '"':
                                in_str2 = False
                            k += 1
                            continue
                        else:
                            if c2 == '"':
                                in_str2 = True
                                k += 1
                                continue
                            if c2 == "{":
                                depth += 1
                            elif c2 == "}":
                                depth -= 1
                                if depth == 0:
                                    yield (i, brace_open, k)
                                    i = k + 1
                                    break
                        k += 1
                    else:
                        # unclosed brace: stop scanning
                        return
                    continue
        i += 1


def parse_table_arms(block_inside: str) -> List[Tuple[str, bool]]:
    """
    Parse top-level arms in a `table { ... }` block.
    Returns list of (lhs_text, ended_with_semicolon) for each top-level arm.
    """
    arms: List[Tuple[str, bool]] = []
    i = 0
    n = len(block_inside)
    depth = 0
    in_str = False
    esc = False

    def skip_ws(k: int) -> int:
        while k < n and block_inside[k].isspace():
            k += 1
        return k

    # We scan for top-level '=>' and then for the next top-level ';' (arm terminator)
    while i < n:
        # find next top-level '=>'
        lhs_start = i
        found_arrow = -1
        while i < n:
            c = block_inside[i]
            if in_str:
                if esc:
                    esc = False
                elif c == "\\":
                    esc = True
                elif c == '"':
                    in_str = False
                i += 1
                continue

            if c == '"':
                in_str = True
                i += 1
                continue

            if c == "{":
                depth += 1
            elif c == "}":
                depth = max(depth - 1, 0)

            if depth == 0 and i + 1 < n and block_inside[i] == "=" and block_inside[i + 1] == ">":
                found_arrow = i
                break
            i += 1

        if found_arrow == -1:
            break

        lhs = block_inside[lhs_start:found_arrow].strip()

        # scan RHS until next top-level ';' or end
        i = found_arrow + 2
        rhs_end = -1
        ended_semicolon = False
        while i < n:
            c = block_inside[i]
            if in_str:
                if esc:
                    esc = False
                elif c == "\\":
                    esc = True
                elif c == '"':
                    in_str = False
                i += 1
                continue

            if c == '"':
                in_str = True
                i += 1
                continue

            if c == "{":
                depth += 1
            elif c == "}":
                depth = max(depth - 1, 0)

            if depth == 0 and c == ";":
                rhs_end = i
                ended_semicolon = True
                i += 1
                break
            i += 1

        arms.append((lhs, ended_semicolon))

        # next arm starts after the semicolon (or end)
        i = skip_ws(i)

    return arms


def has_explicit_type_context(text: str, table_kw_idx: int) -> bool:
    """
    Heuristic: in the current statement segment (since last ';' or '\n'),
    see if there's a ':' before '=' (typed definition), e.g. `foo : X = table { ... }`.
    """
    stmt_start = max(text.rfind(";", 0, table_kw_idx), text.rfind("\n", 0, table_kw_idx))
    stmt_start = 0 if stmt_start < 0 else stmt_start + 1
    prefix = text[stmt_start:table_kw_idx]
    if ":" in prefix and "=" in prefix:
        # ensure ':' occurs before '='
        return prefix.find(":") < prefix.find("=")
    return False


def lint(text_raw: str) -> List[Finding]:
    findings: List[Finding] = []
    text = strip_line_comments_preserve_strings(text_raw)

    # 1) mkN cycles
    defs, _lines = extract_mk_defs(text)
    graph = build_mk_graph(defs)
    sccs = tarjan_scc(graph)
    cycles = [c for c in sccs if len(c) > 1]
    for comp in sorted(cycles, key=len, reverse=True):
        # line: smallest start line in component
        min_line = min(defs[name][0] for name in comp if name in defs)
        findings.append(Finding(
            kind="mkN-cycle",
            line=min_line,
            msg=f"mkN cycle of size {len(comp)}: " + " -> ".join(comp[:6]) + (" -> ..." if len(comp) > 6 else ""),
            preview=" / ".join(sorted(comp)[:10]),
        ))

    # 2) balance check per mkN definition (helps catch missing braces/; fallout)
    for name, (start_line, _end, body) in defs.items():
        b, p = check_balance(body)
        if b != 0 or p != 0:
            findings.append(Finding(
                kind="mkN-unbalanced",
                line=start_line,
                msg=f"{name} has unbalanced delimiters: '{{}}' delta={b}, '()' delta={p}",
                preview=body.splitlines()[0].strip()[:120],
            ))

    # 3) string-pattern table hazards + missing semicolons between top-level arms
    for table_kw_idx, brace_open, brace_close in iter_table_blocks(text):
        inner = text[brace_open + 1:brace_close]
        arms = parse_table_arms(inner)
        if not arms:
            continue

        # string-pattern table: any LHS contains a string literal
        string_lhs = any('"' in lhs for lhs, _ in arms)
        if not string_lhs:
            continue  # this is the big false-positive reduction vs your current script

        line = index_to_line(text, table_kw_idx)
        typed = has_explicit_type_context(text, table_kw_idx)

        # missing semicolons between top-level arms (non-last arm without ';')
        for k, (_lhs, ended_semicolon) in enumerate(arms[:-1]):
            if not ended_semicolon:
                findings.append(Finding(
                    kind="table-missing-semicolon",
                    line=line,
                    msg="String-pattern table: a top-level arm seems to be missing ';' before the next arm",
                    preview=text[table_kw_idx: min(len(text), table_kw_idx + 160)].replace("\n", "\\n"),
                ))
                break

        if not typed:
            findings.append(Finding(
                kind="table-string-pattern-untyped",
                line=line,
                msg="String-pattern table without obvious type annotation nearby (risk: 'cannot infer table type'). "
                    "Consider rewriting as `case` or giving the table an explicit type context.",
                preview=text[table_kw_idx: min(len(text), table_kw_idx + 200)].replace("\n", "\\n"),
            ))
        else:
            findings.append(Finding(
                kind="table-string-pattern-typed",
                line=line,
                msg="String-pattern table (typed context detected). Probably OK, but still worth checking if GF complains.",
                preview=text[table_kw_idx: min(len(text), table_kw_idx + 200)].replace("\n", "\\n"),
            ))

    return sorted(findings, key=lambda f: (f.line, f.kind))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("path", help="Path to MorphoSqi.gf")
    args = ap.parse_args()

    text = read_text(args.path)
    findings = lint(text)

    print("== MorphoSqi lint ==")
    print(f"Findings: {len(findings)}\n")

    if not findings:
        print("No issues found by this heuristic lint.")
        return 0

    # group by kind
    by_kind: Dict[str, List[Finding]] = defaultdict(list)
    for f in findings:
        by_kind[f.kind].append(f)

    for kind in sorted(by_kind.keys()):
        print(f"[{kind}] ({len(by_kind[kind])})")
        for f in by_kind[kind][:80]:
            loc = f"line {f.line}"
            print(f"  - {loc}: {f.msg}")
            if f.preview:
                print(f"      {f.preview}")
        if len(by_kind[kind]) > 80:
            print(f"  ... ({len(by_kind[kind]) - 80} more)")
        print()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())