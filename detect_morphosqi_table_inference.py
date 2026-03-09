#!/usr/bin/env python3
"""
detect_morphosqi_table_inference.py

Goal: find MorphoSqi.gf locations that are likely to trigger GF 3.12 errors like:
  "cannot infer table type of table { _ + "y" => ... ; _ => ... }"

Heuristics:
  1) untyped 'table { ... }' blocks that use string-pattern rules like `_ + "x"` or `"x" + _`
  2) 'case ... of { ... }' blocks that use those string-pattern rules and are not obviously type-annotated
  3) optional: parse gf stderr to jump straight to reported file ranges like "MorphoSqi.gf:2467-2496"

This does NOT guarantee the compiler will error at every hit; it finds strong candidates.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from dataclasses import dataclass, asdict
from typing import List, Optional, Tuple


# --- comment/string-aware brace matching --------------------------------------

@dataclass
class Block:
    kind: str               # "table" or "case"
    start_line: int         # 1-based
    end_line: int           # 1-based
    header: str             # short context line
    op_context: str         # nearest operation/function name guess
    has_string_patterns: bool
    looks_typed_or_annotated: bool
    suspicion: str          # why it’s flagged
    snippet: List[str]      # lines with prefixes "L####: ..." (bounded)

STRING_PATTERN_RE = re.compile(r'(_\s*\+\s*")|("\s*\+\s*_)|(_\s*\+\s*")|(_\s*\+\s*")|(_\s*\+\s*")')
# More direct: catch _+"x" / _ + "x" / "x"+_ etc.
STRING_PATTERN_RE = re.compile(r'(_\s*\+\s*")|("\s*\+\s*_)|(_\s*\+\s*")|(_\s*\+\s*")|(_\s*\+\s*")|(_\s*\+\s*")')
STRING_PATTERN_RE = re.compile(r'(_\s*\+\s*")|("\s*\+\s*_)|(_\s*\+\s*")|(_\s*\+\s*")')
STRING_PATTERN_RE = re.compile(r'(_\s*\+\s*")|("\s*\+\s*_)|(_\s*\+\s*")|(_\s*\+\s*")')
# Final, simple + robust:
STRING_PATTERN_RE = re.compile(r'(_\s*\+\s*")|("\s*\+\s*_)\b|(_\s*\+\s*")|("\s*\+\s*_)')
STRING_PATTERN_RE = re.compile(r'(_\s*\+\s*")|("\s*\+\s*_)|(_\+\s*")|("\s*\+_)|(_\+")|("\+_)')

# detect "table {" specifically (untyped)
UNTYPED_TABLE_RE = re.compile(r'\btable\s*\{')
# typed "table Str {" or "table ResSqi.Case {"
TYPED_TABLE_RE = re.compile(r'\btable\s+([A-Za-z_][\w\.]*)\s*\{')
CASE_RE = re.compile(r'\bcase\b')

# operation/function name guess in GF:
# within oper blocks: "mkN084 : ..." or "mkN084 = ..."
OP_DECL_RE = re.compile(r'^\s*([A-Za-z_]\w*)\s*(?::|=)')

GF_RANGE_RE = re.compile(
    r'(?P<file>[^:\s]+\.gf):(?P<start>\d+)(?:-(?P<end>\d+))?:'
)

def strip_line_comment(line: str) -> str:
    # GF line comment: "--"
    idx = line.find("--")
    if idx >= 0:
        return line[:idx]
    return line

def compute_brace_spans(text: str, start_idx: int) -> Optional[int]:
    """
    Given text and an index at a '{', return index of the matching '}'.
    Comment-aware for:
      -- line comments
      {- ... -} block comments
    String-aware for "..."
    """
    if start_idx < 0 or start_idx >= len(text) or text[start_idx] != "{":
        return None

    i = start_idx
    depth = 0
    in_str = False
    in_line_comment = False
    in_block_comment = False

    while i < len(text):
        ch = text[i]
        nxt = text[i + 1] if i + 1 < len(text) else ""

        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
            i += 1
            continue

        if in_block_comment:
            # end block comment "-}"
            if ch == "-" and nxt == "}":
                in_block_comment = False
                i += 2
            else:
                i += 1
            continue

        if in_str:
            if ch == "\\" and nxt:
                i += 2
                continue
            if ch == '"':
                in_str = False
            i += 1
            continue

        # entering comments
        if ch == "-" and nxt == "-":
            in_line_comment = True
            i += 2
            continue
        if ch == "{" and nxt == "-":
            in_block_comment = True
            i += 2
            continue

        # entering strings
        if ch == '"':
            in_str = True
            i += 1
            continue

        # braces
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return i
        i += 1

    return None

def idx_to_linecol(line_starts: List[int], idx: int) -> Tuple[int, int]:
    # line_starts are indices of each line start in text
    # returns (1-based line, 1-based col)
    import bisect
    line = bisect.bisect_right(line_starts, idx)  # count of starts <= idx
    line_start = line_starts[line - 1]
    col = (idx - line_start) + 1
    return line, col

def build_line_starts(text: str) -> List[int]:
    starts = [0]
    for m in re.finditer(r"\n", text):
        starts.append(m.end())
    return starts

def nearest_op_context(lines: List[str], start_line_1based: int, lookback: int = 120) -> str:
    i = start_line_1based - 1
    lo = max(0, i - lookback)
    for j in range(i, lo - 1, -1):
        raw = strip_line_comment(lines[j]).strip()
        if not raw:
            continue
        # skip module headers etc
        if raw.startswith(("concrete ", "abstract ", "resource ", "interface ", "open ", "in ", "{", "}", "lincat", "lin", "oper")):
            # still allow "oper" block lines below; keep scanning
            pass
        m = OP_DECL_RE.match(raw)
        if m:
            name = m.group(1)
            # avoid catching "lin" etc.
            if name not in {"lin", "lincat", "oper", "param"}:
                return name
    return ""

def make_snippet(lines: List[str], start_line: int, end_line: int, max_lines: int = 20) -> List[str]:
    # bounded snippet around the block
    span = end_line - start_line + 1
    if span <= max_lines:
        rng = range(start_line, end_line + 1)
    else:
        # show head + tail
        head = max_lines // 2
        tail = max_lines - head
        rng = list(range(start_line, start_line + head)) + list(range(end_line - tail + 1, end_line + 1))
    out = []
    for ln in rng:
        out.append(f"L{ln:04d}: {lines[ln-1].rstrip()}")
    if span > max_lines:
        out.insert(head, "    ...")
    return out

def looks_annotated(expr_text: str) -> bool:
    """
    Heuristic: if expression is wrapped like < ... : Type> or has ': Type' right after the closing brace.
    """
    s = expr_text.strip()
    if s.startswith("<") and ":" in s and ">" in s:
        return True
    # common pattern: ... } : Str
    if re.search(r'\}\s*:\s*[A-Za-z_][\w\.]*', s):
        return True
    return False

def scan_blocks(gf_path: str) -> List[Block]:
    with open(gf_path, "r", encoding="utf-8") as f:
        text = f.read()

    lines = text.splitlines(True)
    line_starts = build_line_starts(text)

    blocks: List[Block] = []

    # Scan for "table" occurrences
    for m in re.finditer(r'\btable\b', text):
        # find next '{'
        after = text[m.end():]
        brace_rel = after.find("{")
        if brace_rel < 0:
            continue
        brace_idx = m.end() + brace_rel

        end_idx = compute_brace_spans(text, brace_idx)
        if end_idx is None:
            continue

        start_line, _ = idx_to_linecol(line_starts, m.start())
        end_line, _ = idx_to_linecol(line_starts, end_idx)

        # extract the expression chunk roughly from 'table' to '}' + a bit
        expr_chunk = text[m.start(): min(len(text), end_idx + 120)]
        # is this untyped table?
        head_to_brace = text[m.start(): brace_idx + 1]
        is_untyped = bool(UNTYPED_TABLE_RE.search(head_to_brace))
        is_typed = bool(TYPED_TABLE_RE.search(head_to_brace))
        has_str_pat = bool(STRING_PATTERN_RE.search(expr_chunk))
        annotated = looks_annotated(expr_chunk)

        suspicion = ""
        flag = False
        if has_str_pat and is_untyped and not annotated:
            flag = True
            suspicion = "untyped `table { ... }` contains string-pattern rules (`_+\"x\"` / `\"x\"+_`) and is not type-annotated"
        elif has_str_pat and not (is_typed or annotated):
            flag = True
            suspicion = "table contains string-pattern rules but does not look typed/annotated (heuristic)"

        if flag:
            op_ctx = nearest_op_context([l.rstrip("\n") for l in lines], start_line)
            header_line = strip_line_comment(lines[start_line - 1]).strip()
            blocks.append(Block(
                kind="table",
                start_line=start_line,
                end_line=end_line,
                header=header_line[:160],
                op_context=op_ctx,
                has_string_patterns=has_str_pat,
                looks_typed_or_annotated=(is_typed or annotated),
                suspicion=suspicion,
                snippet=make_snippet([l.rstrip("\n") for l in lines], start_line, end_line),
            ))

    # Scan for "case ... of { ... }" blocks
    for m in re.finditer(r'\bcase\b', text):
        # require "of" soon after to avoid false positives
        window = text[m.start(): m.start() + 300]
        if " of " not in window and "of" not in window:
            continue
        # find next '{'
        brace_idx = text.find("{", m.start())
        if brace_idx < 0:
            continue
        # crude: ensure "of" appears before '{'
        of_idx = text.find("of", m.start(), brace_idx)
        if of_idx < 0:
            continue

        end_idx = compute_brace_spans(text, brace_idx)
        if end_idx is None:
            continue

        start_line, _ = idx_to_linecol(line_starts, m.start())
        end_line, _ = idx_to_linecol(line_starts, end_idx)

        expr_chunk = text[m.start(): min(len(text), end_idx + 120)]
        has_str_pat = bool(STRING_PATTERN_RE.search(expr_chunk))
        annotated = looks_annotated(expr_chunk)

        # If the case uses string patterns and isn't annotated, it's a good candidate
        if has_str_pat and not annotated:
            op_ctx = nearest_op_context([l.rstrip("\n") for l in lines], start_line)
            header_line = strip_line_comment(lines[start_line - 1]).strip()
            blocks.append(Block(
                kind="case",
                start_line=start_line,
                end_line=end_line,
                header=header_line[:160],
                op_context=op_ctx,
                has_string_patterns=True,
                looks_typed_or_annotated=False,
                suspicion="`case ... of { ... }` uses string-pattern rules and does not look type-annotated; consider `<case ... : Str>`",
                snippet=make_snippet([l.rstrip("\n") for l in lines], start_line, end_line),
            ))

    # de-dup blocks (same start/end/kind)
    uniq = {}
    for b in blocks:
        key = (b.kind, b.start_line, b.end_line)
        uniq[key] = b
    return sorted(uniq.values(), key=lambda x: (x.start_line, x.end_line, x.kind))

def parse_gf_stderr_ranges(stderr_path: str, target_filename: str = "MorphoSqi.gf") -> List[Tuple[int, int, str]]:
    """
    Parse ranges like:
      lib\\src\\albanian\\MorphoSqi.gf:2467-2496:
    Returns list of (start_line, end_line, raw_line)
    """
    out = []
    with open(stderr_path, "r", encoding="utf-8", errors="replace") as f:
        for line in f:
            m = GF_RANGE_RE.search(line)
            if not m:
                continue
            fn = os.path.basename(m.group("file"))
            if fn != target_filename:
                continue
            s = int(m.group("start"))
            e = int(m.group("end") or m.group("start"))
            out.append((s, e, line.rstrip("\n")))
    return out

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("morpho_gf", help="Path to MorphoSqi.gf")
    ap.add_argument("--json-out", help="Write full results to JSON file")
    ap.add_argument("--stderr", help="Optional: path to saved gf stderr; will print snippets for ranges")
    ap.add_argument("--max-snippet-lines", type=int, default=20)
    args = ap.parse_args()

    gf_path = args.morpho_gf
    if not os.path.isfile(gf_path):
        print(f"ERROR: file not found: {gf_path}", file=sys.stderr)
        return 2

    blocks = scan_blocks(gf_path)

    # print summary
    print(f"Candidates in {os.path.basename(gf_path)}: {len(blocks)}")
    if blocks:
        print()

    # show candidates
    for b in blocks:
        ctx = f" op={b.op_context}" if b.op_context else ""
        print(f"[{b.kind}] L{b.start_line}-{b.end_line}{ctx}: {b.suspicion}")
        for s in b.snippet[:args.max_snippet_lines]:
            print("  " + s)
        print()

    # optional: show stderr ranges
    if args.stderr:
        with open(gf_path, "r", encoding="utf-8") as f:
            gf_lines = [ln.rstrip("\n") for ln in f.read().splitlines(True)]
        ranges = parse_gf_stderr_ranges(args.stderr, target_filename=os.path.basename(gf_path))
        if ranges:
            print("GF stderr ranges detected (snippets):")
            for s, e, raw in ranges:
                print(f"  {raw}")
                snip = make_snippet(gf_lines, s, e, max_lines=args.max_snippet_lines)
                for line in snip:
                    print("    " + line)
                print()

    if args.json_out:
        payload = [asdict(b) for b in blocks]
        with open(args.json_out, "w", encoding="utf-8") as f:
            json.dump(payload, f, ensure_ascii=False, indent=2)
        print(f"Wrote JSON: {args.json_out}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())