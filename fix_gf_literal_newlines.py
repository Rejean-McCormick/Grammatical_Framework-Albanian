#!/usr/bin/env python3
"""
Fix GF sources that accidentally contain the *literal* text "\n" or "\n\n"
in the middle of code (usually from a bad copy/paste or a generator).

Typical symptom (GF 3.12): "Syntax error: Unexpected token '\' ..." at a line
that contains "... ;\n\nNextDecl ...".

Default behavior:
- Replaces literal "\\n\\n" with two real newlines.
- Then replaces any remaining literal "\\n" with one real newline.
- Writes in-place and creates a .bak backup (unless --no-backup).
- Validates that no literal "\\n" remains (unless --no-validate).

Usage:
  python fix_gf_literal_newlines.py path/to/MorphoSqi.gf
  python fix_gf_literal_newlines.py path/to/dir --glob "*.gf"

PowerShell example:
  python .\fix_gf_literal_newlines.py .\lib\src\albanian\MorphoSqi.gf
"""

from __future__ import annotations

import argparse
import fnmatch
import os
from pathlib import Path
from typing import Iterable, Tuple


def iter_files(paths: list[Path], glob_pat: str | None) -> Iterable[Path]:
    for p in paths:
        if p.is_dir():
            pat = glob_pat or "*.gf"
            for root, _, files in os.walk(p):
                for name in files:
                    if fnmatch.fnmatch(name, pat):
                        yield Path(root) / name
        else:
            yield p


def replace_literal_newlines(src: str) -> Tuple[str, int, int]:
    """Return (fixed_text, count_\\n\\n_replaced, count_\\n_replaced)."""
    c_double = src.count(r"\n\n")
    dst = src.replace(r"\n\n", "\n\n")
    # After collapsing doubles, handle any remaining single "\n"
    c_single = dst.count(r"\n")
    dst2 = dst.replace(r"\n", "\n")
    return dst2, c_double, c_single


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("paths", nargs="+", help="GF file(s) or directory(ies) to fix")
    ap.add_argument("--glob", default=None, help='When a path is a directory, select files by glob (default: "*.gf")')
    ap.add_argument("--encoding", default="utf-8", help="Text encoding (default: utf-8)")
    ap.add_argument("--no-backup", action="store_true", help="Do not create .bak backup files")
    ap.add_argument("--no-validate", action="store_true", help="Skip validation (default validates that no literal \\n remains)")
    ap.add_argument("--dry-run", action="store_true", help="Report what would change without writing")
    args = ap.parse_args()

    total_changed = 0
    for f in iter_files([Path(p) for p in args.paths], args.glob):
        if not f.exists() or not f.is_file():
            print(f"[skip] {f} (not a file)")
            continue

        raw = f.read_text(encoding=args.encoding, errors="replace")
        fixed, c_double, c_single = replace_literal_newlines(raw)

        if c_double == 0 and c_single == 0:
            # No literal markers found.
            continue

        if not args.no_validate and (r"\n" in fixed):
            # If this triggers, it means we still have literal backslash-n sequences.
            # (Most likely because they were inside strings or got reintroduced.)
            # We still write (unless dry-run), but we warn loudly.
            print(f"[warn] {f}: still contains literal \\\\n after replacement (check manually).")

        if raw != fixed:
            total_changed += 1
            print(f"[fix] {f}  (replaced: \\\\n\\\\n x{c_double}, then \\\\n x{c_single})")
            if not args.dry_run:
                if not args.no_backup:
                    bak = f.with_suffix(f.suffix + ".bak")
                    bak.write_text(raw, encoding=args.encoding, newline="\n")
                f.write_text(fixed, encoding=args.encoding, newline="\n")

    if total_changed == 0:
        print("No changes needed.")
    else:
        print(f"Done. Updated {total_changed} file(s).")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
