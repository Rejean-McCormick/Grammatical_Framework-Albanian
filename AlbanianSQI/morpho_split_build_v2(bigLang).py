#!/usr/bin/env python3
"""
morpho_split_build_v2.py  (GUI + CLI)

V2 goals
- Split is SECTION-based (no line-count splitting).
- Sections are detected by a regex (default matches mkN/mkA/mkV paradigm signature lines).
- Output parts are "structured": grouped by family + numeric range buckets (e.g., Noun mkN001-100).
- Rebuild concatenates: HEADER + parts (manifest order) + FOOTER.
- Optional verify: rebuilt file must match the original byte-for-byte.

CLI:
  Split (structured naming; default):
    python morpho_split_build_v2.py split --gf path/to/MorphoXxx.gf --bucket-size 100
  Split (numbered parts naming):
    python morpho_split_build_v2.py split --gf path/to/MorphoXxx.gf --naming numbered
  Rebuild:
    python morpho_split_build_v2.py build --parts-dir path/to/MorphoXxx_parts --out path/to/MorphoXxx.gf
  Verify:
    python morpho_split_build_v2.py verify --parts-dir path/to/MorphoXxx_parts

GUI:
- Pick GF file
- Pick/derive parts folder (<same folder>/<stem>_parts)
- Naming: structured or numbered
- Bucket size (structured naming)
- Header marker regex (default: oper)
- Section start regex (default: mk[ANV]### :)
- Buttons: Split | Rebuild | Verify
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import tempfile
import traceback
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple


MANIFEST_NAME = "parts_manifest.json"
HEADER_NAME = "HEADER.gfpart"
FOOTER_NAME = "FOOTER.gfpart"

DEFAULT_HEADER_MARKER_REGEX = r"^\s*oper\s*$"

# Default: mkN001 :, mkA014 :, mkV135 :
DEFAULT_SECTION_START_REGEX = r"^\s*(mk[ANV])(\d+)\s*:"


@dataclass
class SplitPlan:
    gf_path: str
    parts_dir: str

    # parsing
    header_marker_regex: str
    section_start_regex: str
    header_end: int
    footer_start: int

    # split output
    naming: str  # "structured" or "numbered"
    bucket_size: int
    part_files: List[str]  # filenames in concatenation order

    # metadata
    section_count: int
    preamble_present: bool


@dataclass
class Section:
    lines: List[str]
    family: Optional[str]  # e.g., mkN, mkA, mkV
    num: Optional[int]
    is_preamble: bool


def read_lines(path: Path) -> List[str]:
    return path.read_text(encoding="utf-8", errors="replace").splitlines(True)  # keep newlines


def write_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def find_header_footer(lines: List[str], header_marker_regex: str) -> Tuple[int, int]:
    """
    Header ends at first line matching header_marker_regex (default: standalone 'oper'),
    including that line + following blank lines.
    Fallback: first line containing '{' + following blank lines.
    Footer starts at last standalone '}' line (stripped == '}').
    """
    marker = re.compile(header_marker_regex)

    header_end: Optional[int] = None
    for i, l in enumerate(lines):
        if marker.match(l):
            header_end = i + 1
            break

    if header_end is None:
        brace_line = None
        for i, l in enumerate(lines):
            if "{" in l:
                brace_line = i
                break
        if brace_line is None:
            raise ValueError("Cannot locate header split point: no header marker match and no '{' found.")
        header_end = brace_line + 1

    while header_end < len(lines) and lines[header_end].strip() == "":
        header_end += 1

    footer_start: Optional[int] = None
    for i in range(len(lines) - 1, -1, -1):
        if lines[i].strip() == "}":
            footer_start = i
            break

    if footer_start is None:
        raise ValueError("Cannot locate footer: no standalone closing '}' found.")
    if footer_start <= header_end:
        raise ValueError(
            f"Bad split points: header_end={header_end}, footer_start={footer_start}. "
            "Header marker may be wrong for this file."
        )

    return header_end, footer_start


def parse_sections(body_lines: List[str], section_start_regex: str) -> List[Section]:
    """
    Splits body into sections starting at lines matching section_start_regex.
    Default expects capture groups: (family)(digits), e.g. (mkN)(001)

    Keeps preamble (before first match) as its own section if present.
    """
    rx = re.compile(section_start_regex)
    starts: List[Tuple[int, Optional[str], Optional[int]]] = []

    for i, l in enumerate(body_lines):
        m = rx.match(l)
        if not m:
            continue
        family = m.group(1)
        num = int(m.group(2))
        starts.append((i, family, num))

    if not starts:
        return [Section(lines=body_lines, family=None, num=None, is_preamble=True)]

    sections: List[Section] = []
    if starts[0][0] > 0:
        sections.append(Section(lines=body_lines[: starts[0][0]], family=None, num=None, is_preamble=True))

    for idx, (s, fam, num) in enumerate(starts):
        e = starts[idx + 1][0] if idx + 1 < len(starts) else len(body_lines)
        sections.append(Section(lines=body_lines[s:e], family=fam, num=num, is_preamble=False))

    return sections


def classify_family(family: str) -> Tuple[str, int]:
    """
    Returns (category_label, sort_group)
      sort_group enforces stable ordering across languages.
    """
    if family.startswith("mkN"):
        return ("Noun", 10)
    if family.startswith("mkA"):
        return ("Adj", 20)
    if family.startswith("mkV"):
        return ("Verb", 30)
    return ("Other", 40)


def bucket_range(n: int, bucket_size: int) -> Tuple[int, int]:
    start = ((n - 1) // bucket_size) * bucket_size + 1
    end = start + bucket_size - 1
    return start, end


def safe_filename(name: str) -> str:
    # conservative filename sanitizer
    return re.sub(r"[^A-Za-z0-9._\-]+", "_", name)


def structured_part_name(
    family: str,
    first_num: int,
    last_num: int,
    bucket_size: int,
) -> str:
    category, group = classify_family(family)
    # pad width based on last_num; minimum 3
    width = max(3, len(str(max(first_num, last_num))))
    # add numeric group prefix so lexicographic sorting is stable
    prefix = f"{group:02d}"
    core = f"{category}_{family}{first_num:0{width}d}-{last_num:0{width}d}"
    return safe_filename(f"{prefix}_{core}.gfpart")


def cleanup_parts_dir(parts_dir: Path) -> None:
    for p in parts_dir.glob("*.gfpart"):
        if p.name in (HEADER_NAME, FOOTER_NAME):
            continue
        try:
            p.unlink()
        except Exception:
            pass
    m = parts_dir / MANIFEST_NAME
    if m.exists():
        try:
            m.unlink()
        except Exception:
            pass


def split_gf_file(
    gf_path: Path,
    parts_dir: Path,
    naming: str = "structured",  # "structured" or "numbered"
    bucket_size: int = 100,
    header_marker_regex: str = DEFAULT_HEADER_MARKER_REGEX,
    section_start_regex: str = DEFAULT_SECTION_START_REGEX,
    overwrite_parts: bool = True,
) -> SplitPlan:
    if not gf_path.exists():
        raise FileNotFoundError(gf_path)
    if naming not in ("structured", "numbered"):
        raise ValueError("naming must be one of: structured, numbered")
    if bucket_size < 1:
        raise ValueError("bucket_size must be >= 1")

    parts_dir.mkdir(parents=True, exist_ok=True)
    if overwrite_parts:
        cleanup_parts_dir(parts_dir)

    lines = read_lines(gf_path)
    header_end, footer_start = find_header_footer(lines, header_marker_regex=header_marker_regex)

    header = "".join(lines[:header_end])
    body = lines[header_end:footer_start]
    footer = "".join(lines[footer_start:])

    write_text(parts_dir / HEADER_NAME, header)
    write_text(parts_dir / FOOTER_NAME, footer)

    sections = parse_sections(body, section_start_regex=section_start_regex)

    # 1) preamble (if any)
    part_files: List[str] = []
    preamble_present = False
    preamble = sections[0] if sections and sections[0].is_preamble else None
    idx0 = 1 if preamble is not None else 0

    if preamble is not None and "".join(preamble.lines).strip():
        preamble_present = True
        pre_name = safe_filename("00_Preamble.gfpart")
        write_text(parts_dir / pre_name, "".join(preamble.lines))
        part_files.append(pre_name)

    # 2) remaining sections -> parts
    if naming == "numbered":
        # keep original order, bundle by bucket_size sections (bucket_size acts as sections-per-part here)
        k = 1
        i = idx0
        while i < len(sections):
            bundle: List[str] = []
            for _ in range(bucket_size):
                if i >= len(sections):
                    break
                bundle.extend(sections[i].lines)
                i += 1
            fname = f"PART_{k:04d}.gfpart"
            write_text(parts_dir / fname, "".join(bundle))
            part_files.append(fname)
            k += 1
    else:
        # structured: bucket by (family, range)
        buckets: Dict[Tuple[int, str, int, int], List[str]] = {}
        # key = (sort_group, family, range_start, range_end)

        for s in sections[idx0:]:
            if s.is_preamble:
                continue
            if s.family is None or s.num is None:
                # treat unknown as Other bucket
                family = "mkOther"
                num = 0
                category, grp = ("Other", 40)
                r0, r1 = (0, 0)
            else:
                family = s.family
                num = s.num
                category, grp = classify_family(family)
                r0, r1 = bucket_range(num, bucket_size)

            key = (grp, family, r0, r1)
            buckets.setdefault(key, []).extend(s.lines)

        # deterministic order
        for (grp, family, r0, r1) in sorted(buckets.keys()):
            fname = structured_part_name(family=family, first_num=r0, last_num=r1, bucket_size=bucket_size)
            write_text(parts_dir / fname, "".join(buckets[(grp, family, r0, r1)]))
            part_files.append(fname)

    plan = SplitPlan(
        gf_path=str(gf_path.resolve()),
        parts_dir=str(parts_dir.resolve()),
        header_marker_regex=header_marker_regex,
        section_start_regex=section_start_regex,
        header_end=header_end,
        footer_start=footer_start,
        naming=naming,
        bucket_size=bucket_size,
        part_files=part_files,
        section_count=sum(1 for s in sections if not s.is_preamble),
        preamble_present=preamble_present,
    )
    write_text(parts_dir / MANIFEST_NAME, json.dumps(asdict(plan), indent=2, ensure_ascii=False) + "\n")
    return plan


def load_manifest(parts_dir: Path) -> SplitPlan:
    mpath = parts_dir / MANIFEST_NAME
    if not mpath.exists():
        raise FileNotFoundError(f"Missing manifest: {mpath}")
    data = json.loads(mpath.read_text(encoding="utf-8", errors="replace"))
    return SplitPlan(**data)


def rebuild_to_string(parts_dir: Path) -> Tuple[str, SplitPlan]:
    parts_dir = parts_dir.resolve()
    plan = load_manifest(parts_dir)

    header_path = parts_dir / HEADER_NAME
    footer_path = parts_dir / FOOTER_NAME
    if not header_path.exists() or not footer_path.exists():
        raise FileNotFoundError(f"Missing {HEADER_NAME} or {FOOTER_NAME} in {parts_dir}")

    header = header_path.read_text(encoding="utf-8", errors="replace")
    footer = footer_path.read_text(encoding="utf-8", errors="replace")

    part_paths = [parts_dir / p for p in plan.part_files]
    missing = [p.name for p in part_paths if not p.exists()]
    if missing:
        raise FileNotFoundError(f"Missing part files in {parts_dir}: {missing}")

    body = "".join(p.read_text(encoding="utf-8", errors="replace") for p in part_paths)
    return header + body + footer, plan


def build_gf_file(parts_dir: Path, out_path: Optional[Path]) -> Path:
    parts_dir = parts_dir.resolve()
    rebuilt, plan = rebuild_to_string(parts_dir)

    if out_path is None:
        out_path = Path(plan.gf_path)

    out_path = out_path.resolve()
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(rebuilt, encoding="utf-8")
    return out_path


def verify_parts(parts_dir: Path) -> None:
    parts_dir = parts_dir.resolve()
    rebuilt, plan = rebuild_to_string(parts_dir)

    original_path = Path(plan.gf_path)
    if not original_path.exists():
        raise FileNotFoundError(f"Original file not found for verify: {original_path}")

    original_bytes = original_path.read_bytes()
    rebuilt_bytes = rebuilt.encode("utf-8")

    if original_bytes != rebuilt_bytes:
        # produce a small helpful diagnostic
        raise RuntimeError(
            "VERIFY FAILED: rebuilt content differs from original.\n"
            f"Original: {original_path}\n"
            f"Parts:    {parts_dir}\n"
            f"Hint: ensure all parts in manifest exist and were produced from the same original."
        )


# ----------------------------
# GUI
# ----------------------------

def run_gui() -> None:
    try:
        import tkinter as tk
        from tkinter import filedialog, messagebox
    except Exception as e:
        raise RuntimeError("Tkinter is not available in this Python environment.") from e

    root = tk.Tk()
    root.title("GF Morpho Split / Rebuild (V2)")

    def show_exc(title: str, exc: BaseException) -> None:
        msg = "".join(traceback.format_exception(type(exc), exc, exc.__traceback__))
        try:
            messagebox.showerror(title, msg)
        except Exception:
            print(msg, file=sys.stderr)

    def report_callback_exception(exc, val, tb):
        msg = "".join(traceback.format_exception(exc, val, tb))
        messagebox.showerror("GUI Error", msg)

    root.report_callback_exception = report_callback_exception  # type: ignore[attr-defined]

    gf_var = tk.StringVar(value="")
    parts_var = tk.StringVar(value="")
    naming_var = tk.StringVar(value="structured")
    bucket_var = tk.StringVar(value="100")
    header_marker_var = tk.StringVar(value=DEFAULT_HEADER_MARKER_REGEX)
    section_start_var = tk.StringVar(value=DEFAULT_SECTION_START_REGEX)
    status_var = tk.StringVar(value="")

    def derive_parts_dir(gf_path: str) -> str:
        p = Path(gf_path)
        return str(p.parent / f"{p.stem}_parts")

    def pick_gf() -> None:
        path = filedialog.askopenfilename(
            title="Select GF file (.gf)",
            filetypes=[("GF files", "*.gf"), ("All files", "*.*")],
        )
        if path:
            gf_var.set(path)
            if not parts_var.get().strip():
                parts_var.set(derive_parts_dir(path))

    def pick_parts() -> None:
        d = filedialog.askdirectory(title="Select or create parts folder")
        if d:
            parts_var.set(d)

    def do_split() -> None:
        try:
            gf_path = Path(gf_var.get().strip())
            if not gf_path.exists():
                raise FileNotFoundError(f"GF file not found: {gf_path}")

            parts_dir = Path(parts_var.get().strip() or derive_parts_dir(str(gf_path)))

            naming = naming_var.get().strip()
            bucket_size = int(bucket_var.get().strip() or "100")

            header_marker = header_marker_var.get().strip() or DEFAULT_HEADER_MARKER_REGEX
            section_start = section_start_var.get().strip() or DEFAULT_SECTION_START_REGEX

            plan = split_gf_file(
                gf_path=gf_path,
                parts_dir=parts_dir,
                naming=naming,
                bucket_size=bucket_size,
                header_marker_regex=header_marker,
                section_start_regex=section_start,
                overwrite_parts=True,
            )

            status_var.set(
                "Split OK\n"
                f"Parts dir: {plan.parts_dir}\n"
                f"Naming: {plan.naming}\n"
                f"Bucket size: {plan.bucket_size}\n"
                f"Parts: {len(plan.part_files)}\n"
                f"Sections: {plan.section_count}\n"
                f"Manifest: {Path(plan.parts_dir) / MANIFEST_NAME}"
            )
            messagebox.showinfo("Split complete", status_var.get())
        except Exception as e:
            show_exc("Split failed", e)

    def do_build() -> None:
        try:
            parts_dir = Path(parts_var.get().strip())
            if not parts_dir.exists():
                raise FileNotFoundError(f"Parts dir not found: {parts_dir}")

            built = build_gf_file(parts_dir=parts_dir, out_path=None)
            status_var.set(f"Rebuild OK: {built}")
            messagebox.showinfo("Rebuild complete", status_var.get())
        except Exception as e:
            show_exc("Rebuild failed", e)

    def do_verify() -> None:
        try:
            parts_dir = Path(parts_var.get().strip())
            if not parts_dir.exists():
                raise FileNotFoundError(f"Parts dir not found: {parts_dir}")

            verify_parts(parts_dir)
            status_var.set("Verify OK: rebuilt matches original (byte-for-byte).")
            messagebox.showinfo("Verify complete", status_var.get())
        except Exception as e:
            show_exc("Verify failed", e)

    frm = tk.Frame(root, padx=10, pady=10)
    frm.pack(fill="both", expand=True)

    tk.Label(frm, text="GF file (.gf):").grid(row=0, column=0, sticky="w")
    tk.Entry(frm, textvariable=gf_var, width=70).grid(row=0, column=1, sticky="we", padx=(6, 6))
    tk.Button(frm, text="Browse…", command=pick_gf).grid(row=0, column=2, sticky="e")

    tk.Label(frm, text="Parts folder:").grid(row=1, column=0, sticky="w")
    tk.Entry(frm, textvariable=parts_var, width=70).grid(row=1, column=1, sticky="we", padx=(6, 6))
    tk.Button(frm, text="Browse…", command=pick_parts).grid(row=1, column=2, sticky="e")

    tk.Label(frm, text="Naming:").grid(row=2, column=0, sticky="w")
    nm = tk.Frame(frm)
    nm.grid(row=2, column=1, sticky="w", padx=(6, 6))
    tk.Radiobutton(nm, text="structured", variable=naming_var, value="structured").pack(side="left")
    tk.Radiobutton(nm, text="numbered", variable=naming_var, value="numbered").pack(side="left", padx=(12, 0))

    tk.Label(frm, text="Bucket size:").grid(row=3, column=0, sticky="w")
    tk.Entry(frm, textvariable=bucket_var, width=12).grid(row=3, column=1, sticky="w", padx=(6, 6))

    tk.Label(frm, text="Header marker regex:").grid(row=4, column=0, sticky="w")
    tk.Entry(frm, textvariable=header_marker_var, width=70).grid(row=4, column=1, sticky="we", padx=(6, 6))
    tk.Label(frm, text="(default: oper)").grid(row=4, column=2, sticky="w")

    tk.Label(frm, text="Section start regex:").grid(row=5, column=0, sticky="w")
    tk.Entry(frm, textvariable=section_start_var, width=70).grid(row=5, column=1, sticky="we", padx=(6, 6))
    tk.Label(frm, text="(default: (mk[ANV])(\\d+) :)").grid(row=5, column=2, sticky="w")

    btns = tk.Frame(frm, pady=10)
    btns.grid(row=6, column=0, columnspan=3, sticky="w")
    tk.Button(btns, text="Split", width=14, command=do_split).pack(side="left", padx=(0, 8))
    tk.Button(btns, text="Rebuild", width=14, command=do_build).pack(side="left", padx=(0, 8))
    tk.Button(btns, text="Verify", width=14, command=do_verify).pack(side="left")

    tk.Label(frm, text="Status:").grid(row=7, column=0, sticky="nw")
    tk.Message(frm, textvariable=status_var, width=650).grid(row=7, column=1, columnspan=2, sticky="we", padx=(6, 6))

    frm.grid_columnconfigure(1, weight=1)
    root.mainloop()


# ----------------------------
# CLI
# ----------------------------

def run_cli(argv: List[str]) -> int:
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)

    sp = sub.add_parser("split", help="Split a GF file into parts (sections-only)")
    sp.add_argument("--gf", type=Path, required=True)
    sp.add_argument("--parts-dir", type=Path, default=None)
    sp.add_argument("--naming", choices=["structured", "numbered"], default="structured")
    sp.add_argument("--bucket-size", type=int, default=100)
    sp.add_argument("--header-marker-regex", type=str, default=DEFAULT_HEADER_MARKER_REGEX)
    sp.add_argument("--section-start-regex", type=str, default=DEFAULT_SECTION_START_REGEX)

    bp = sub.add_parser("build", help="Rebuild GF file from parts")
    bp.add_argument("--parts-dir", type=Path, required=True)
    bp.add_argument("--out", type=Path, default=None)

    vp = sub.add_parser("verify", help="Verify rebuilt matches original byte-for-byte")
    vp.add_argument("--parts-dir", type=Path, required=True)

    args = ap.parse_args(argv)

    if args.cmd == "split":
        parts_dir = args.parts_dir or (args.gf.parent / f"{args.gf.stem}_parts")
        plan = split_gf_file(
            gf_path=args.gf,
            parts_dir=parts_dir,
            naming=args.naming,
            bucket_size=args.bucket_size,
            header_marker_regex=args.header_marker_regex,
            section_start_regex=args.section_start_regex,
            overwrite_parts=True,
        )
        print(f"Split OK: {plan.parts_dir}")
        print(f"Naming: {plan.naming}")
        print(f"Bucket size: {plan.bucket_size}")
        print(f"Parts: {len(plan.part_files)}")
        print(f"Sections: {plan.section_count}")
        print(f"Manifest: {Path(plan.parts_dir) / MANIFEST_NAME}")
        return 0

    if args.cmd == "build":
        built = build_gf_file(parts_dir=args.parts_dir, out_path=args.out)
        print(f"Rebuild OK: {built}")
        return 0

    # verify
    verify_parts(args.parts_dir)
    print("Verify OK: rebuilt matches original (byte-for-byte).")
    return 0


def main() -> None:
    if len(sys.argv) == 1:
        try:
            run_gui()
        except Exception:
            print("GUI failed to start:\n", file=sys.stderr)
            traceback.print_exc()
        return
    raise SystemExit(run_cli(sys.argv[1:]))


if __name__ == "__main__":
    main()