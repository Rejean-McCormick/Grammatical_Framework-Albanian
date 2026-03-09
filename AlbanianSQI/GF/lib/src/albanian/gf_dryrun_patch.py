#!/usr/bin/env python3
from __future__ import annotations

import argparse
import re
import shutil
from dataclasses import dataclass
from pathlib import Path
from typing import List, Tuple, Dict

FIELDS_TO_FIX = {
    "pres_optative",
    "perf_optative",
    "pres_admirative",
    "imperf_admirative",
}

TOPLEVEL_DEF_RE = re.compile(r"^\s*([A-Za-z][A-Za-z0-9_']*)\s*:\s*")
COMMENT_RE = re.compile(r"--.*$")

@dataclass
class Change:
    lineno: int
    before: str
    after: str

def strip_comment(line: str) -> str:
    return COMMENT_RE.sub("", line)

def fix_record_field_arrows(lines: List[str]) -> Tuple[List[str], List[Change]]:
    field_alt = "|".join(re.escape(f) for f in sorted(FIELDS_TO_FIX, key=len, reverse=True))
    rx = re.compile(rf"^(\s*)({field_alt})\s*=>\s*(.*)$")
    out: List[str] = []
    changes: List[Change] = []
    for i, line in enumerate(lines, start=1):
        m = rx.match(line)
        if m:
            indent, field, rest = m.group(1), m.group(2), m.group(3)
            # preserve newline style
            nl = "\n" if line.endswith("\n") else ""
            new_line = f"{indent}{field} = {rest}{nl}"
            changes.append(Change(i, line, new_line))
            out.append(new_line)
        else:
            out.append(line)
    return out, changes

def find_duplicate_toplevel_defs(lines: List[str]) -> Dict[str, List[int]]:
    nesting = 0
    seen: Dict[str, List[int]] = {}
    for i, raw in enumerate(lines, start=1):
        line = strip_comment(raw)
        nesting += line.count("{")
        nesting -= line.count("}")
        if nesting != 0:
            continue
        m = TOPLEVEL_DEF_RE.match(line)
        if m:
            name = m.group(1)
            if name in {"param","oper","lin","lincat","flags","cat","fun"}:
                continue
            seen.setdefault(name, []).append(i)
    return {k: v for k, v in seen.items() if len(v) > 1}

def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--infile", required=True)
    ap.add_argument("--outfile")
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--inplace", action="store_true")
    args = ap.parse_args()

    infile = Path(args.infile)
    if not infile.exists():
        raise SystemExit(f"ERROR: not found: {infile}")

    text = infile.read_text(encoding="utf-8", errors="replace")
    lines = [ln + "\n" for ln in text.splitlines()]

    patched, changes = fix_record_field_arrows(lines)
    dups = find_duplicate_toplevel_defs(patched)

    print("=== DRY RUN REPORT ===" if not args.apply else "=== APPLY MODE ===")
    print(f"Input: {infile}")
    print(f"Record-field '=>'-typos matched: {len(changes)}")
    for ch in changes[:40]:
        print(f"- L{ch.lineno}: {ch.before.rstrip()}  ==>  {ch.after.rstrip()}")
    if len(changes) > 40:
        print(f"  ... {len(changes)-40} more not shown")

    print("\nDuplicate top-level defs (best-effort):")
    if not dups:
        print("- none detected")
    else:
        for name, locs in sorted(dups.items(), key=lambda kv: (-len(kv[1]), kv[0])):
            loc_str = ", ".join(f"L{n}" for n in locs)
            print(f"- {name}: {len(locs)} occurrences at {loc_str}")

    if not args.apply:
        print("\nDry-run only; no files written.")
        return

    if args.inplace:
        bak = infile.with_suffix(infile.suffix + ".bak")
        shutil.copy2(infile, bak)
        infile.write_text("".join(patched), encoding="utf-8")
        print(f"\nWrote INPLACE. Backup: {bak}")
    else:
        outfile = Path(args.outfile) if args.outfile else infile.with_suffix(infile.suffix + ".patched.gf")
        outfile.write_text("".join(patched), encoding="utf-8")
        print(f"\nWrote: {outfile}")

if __name__ == "__main__":
    main()
