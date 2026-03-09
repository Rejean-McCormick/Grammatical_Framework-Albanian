#!/usr/bin/env python3
"""
morpho_split_build.py  (GUI + CLI)

Split / rebuild large GF files (Morpho*.gf), for any language.

- Split is SECTION-based (no line-count splitting):
  Sections are detected by a regex (default matches mkN/mkA/mkV paradigm signature lines).
- Rebuild concatenates: HEADER + PART_0001.. + FOOTER (in manifest order).

GUI:
- Pick GF file
- Pick/derive parts folder (<same folder>/<stem>_parts)
- Sections-per-part
- Header marker regex (default: oper)
- Section start regex (default: mk[ANV]### :)
- Buttons: Split | Rebuild

CLI:
  Split:
    python morpho_split_build.py split --gf path/to/MorphoXxx.gf --sections-per-part 80
  Rebuild:
    python morpho_split_build.py build --parts-dir path/to/MorphoXxx_parts --out path/to/MorphoXxx.gf
"""

from __future__ import annotations

import argparse
import json
import re
import sys
import traceback
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import List, Optional, Tuple


MANIFEST_NAME = "parts_manifest.json"
HEADER_NAME = "HEADER.gfpart"
FOOTER_NAME = "FOOTER.gfpart"
PART_FMT = "PART_{num:04d}.gfpart"

DEFAULT_HEADER_MARKER_REGEX = r"^\s*oper\s*$"
DEFAULT_SECTION_START_REGEX = r"^\s*mk[ANV]\d+\s*:"  # mkN001 :, mkA014 :, mkV135 :


@dataclass
class SplitPlan:
    gf_path: str
    parts_dir: str
    sections_per_part: int
    header_marker_regex: str
    section_start_regex: str
    header_end: int
    footer_start: int
    part_files: List[str]


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


def split_body_by_sections(body_lines: List[str], section_start_regex: str) -> List[List[str]]:
    """
    Splits the body into sections starting at lines matching section_start_regex.
    Keeps preamble (before first match) as its own section if present.
    """
    rx = re.compile(section_start_regex)
    starts = [i for i, l in enumerate(body_lines) if rx.match(l)]

    if not starts:
        return [body_lines]

    sections: List[List[str]] = []
    if starts[0] > 0:
        sections.append(body_lines[:starts[0]])  # preamble

    for idx, s in enumerate(starts):
        e = starts[idx + 1] if idx + 1 < len(starts) else len(body_lines)
        sections.append(body_lines[s:e])

    return sections


def bundle_sections(sections: List[List[str]], sections_per_part: int, section_start_regex: str) -> List[List[str]]:
    """
    Bundles sections into parts of N sections each.
    Keeps preamble alone if it doesn't match section_start_regex.
    """
    if not sections:
        return []

    rx = re.compile(section_start_regex)
    bundles: List[List[str]] = []
    i = 0

    if sections[0] and not rx.match(sections[0][0]):
        bundles.append(sections[0])
        i = 1

    while i < len(sections):
        part: List[str] = []
        for _ in range(sections_per_part):
            if i >= len(sections):
                break
            part.extend(sections[i])
            i += 1
        bundles.append(part)

    return bundles


def cleanup_old_parts(parts_dir: Path) -> None:
    for p in parts_dir.glob("PART_*.gfpart"):
        try:
            p.unlink()
        except Exception:
            pass


def split_gf_file(
    gf_path: Path,
    parts_dir: Path,
    sections_per_part: int = 80,
    header_marker_regex: str = DEFAULT_HEADER_MARKER_REGEX,
    section_start_regex: str = DEFAULT_SECTION_START_REGEX,
    overwrite_parts: bool = True,
) -> SplitPlan:
    if not gf_path.exists():
        raise FileNotFoundError(gf_path)
    if sections_per_part < 1:
        raise ValueError("sections_per_part must be >= 1.")

    parts_dir.mkdir(parents=True, exist_ok=True)

    lines = read_lines(gf_path)
    header_end, footer_start = find_header_footer(lines, header_marker_regex=header_marker_regex)

    header = "".join(lines[:header_end])
    body = lines[header_end:footer_start]
    footer = "".join(lines[footer_start:])

    write_text(parts_dir / HEADER_NAME, header)
    write_text(parts_dir / FOOTER_NAME, footer)

    if overwrite_parts:
        cleanup_old_parts(parts_dir)

    sections = split_body_by_sections(body, section_start_regex=section_start_regex)
    bundles = bundle_sections(sections, sections_per_part=sections_per_part, section_start_regex=section_start_regex)

    part_files: List[str] = []
    for k, bundle in enumerate(bundles, start=1):
        fname = PART_FMT.format(num=k)
        part_files.append(fname)
        write_text(parts_dir / fname, "".join(bundle))

    plan = SplitPlan(
        gf_path=str(gf_path.resolve()),
        parts_dir=str(parts_dir.resolve()),
        sections_per_part=sections_per_part,
        header_marker_regex=header_marker_regex,
        section_start_regex=section_start_regex,
        header_end=header_end,
        footer_start=footer_start,
        part_files=part_files,
    )
    write_text(parts_dir / MANIFEST_NAME, json.dumps(asdict(plan), indent=2, ensure_ascii=False) + "\n")
    return plan


def load_manifest(parts_dir: Path) -> SplitPlan:
    mpath = parts_dir / MANIFEST_NAME
    if not mpath.exists():
        raise FileNotFoundError(f"Missing manifest: {mpath}")
    data = json.loads(mpath.read_text(encoding="utf-8", errors="replace"))
    return SplitPlan(**data)


def build_gf_file(parts_dir: Path, out_path: Path) -> Path:
    parts_dir = parts_dir.resolve()
    out_path = out_path.resolve()

    header_path = parts_dir / HEADER_NAME
    footer_path = parts_dir / FOOTER_NAME
    if not header_path.exists() or not footer_path.exists():
        raise FileNotFoundError(f"Missing {HEADER_NAME} or {FOOTER_NAME} in {parts_dir}")

    header = header_path.read_text(encoding="utf-8", errors="replace")
    footer = footer_path.read_text(encoding="utf-8", errors="replace")

    plan = load_manifest(parts_dir)
    part_paths = [parts_dir / p for p in plan.part_files]

    if not part_paths:
        raise FileNotFoundError(f"No part files listed in manifest: {parts_dir / MANIFEST_NAME}")

    missing = [p.name for p in part_paths if not p.exists()]
    if missing:
        raise FileNotFoundError(f"Missing part files in {parts_dir}: {missing}")

    body = "".join(p.read_text(encoding="utf-8", errors="replace") for p in part_paths)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(header + body + footer, encoding="utf-8")
    return out_path


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
    root.title("GF Split / Rebuild (Sections only)")

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
    sections_var = tk.StringVar(value="80")
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

            parts_dir = Path((parts_var.get().strip() or derive_parts_dir(str(gf_path))))
            sections_per_part = int(sections_var.get().strip() or "80")

            header_marker = header_marker_var.get().strip() or DEFAULT_HEADER_MARKER_REGEX
            section_start = section_start_var.get().strip() or DEFAULT_SECTION_START_REGEX

            plan = split_gf_file(
                gf_path=gf_path,
                parts_dir=parts_dir,
                sections_per_part=sections_per_part,
                header_marker_regex=header_marker,
                section_start_regex=section_start,
                overwrite_parts=True,
            )

            status_var.set(
                f"Split OK\n"
                f"Parts dir: {plan.parts_dir}\n"
                f"Parts: {len(plan.part_files)}\n"
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

            out_path: Optional[Path] = None
            try:
                plan = load_manifest(parts_dir)
                out_path = Path(plan.gf_path)
            except Exception:
                gp = gf_var.get().strip()
                if not gp:
                    raise ValueError("No output .gf path available. Select the original .gf file first.")
                out_path = Path(gp)

            built = build_gf_file(parts_dir=parts_dir, out_path=out_path)
            status_var.set(f"Rebuild OK: {built}")
            messagebox.showinfo("Rebuild complete", status_var.get())
        except Exception as e:
            show_exc("Rebuild failed", e)

    frm = tk.Frame(root, padx=10, pady=10)
    frm.pack(fill="both", expand=True)

    tk.Label(frm, text="GF file (.gf):").grid(row=0, column=0, sticky="w")
    tk.Entry(frm, textvariable=gf_var, width=70).grid(row=0, column=1, sticky="we", padx=(6, 6))
    tk.Button(frm, text="Browse…", command=pick_gf).grid(row=0, column=2, sticky="e")

    tk.Label(frm, text="Parts folder:").grid(row=1, column=0, sticky="w")
    tk.Entry(frm, textvariable=parts_var, width=70).grid(row=1, column=1, sticky="we", padx=(6, 6))
    tk.Button(frm, text="Browse…", command=pick_parts).grid(row=1, column=2, sticky="e")

    tk.Label(frm, text="Sections per part:").grid(row=2, column=0, sticky="w")
    tk.Entry(frm, textvariable=sections_var, width=12).grid(row=2, column=1, sticky="w", padx=(6, 6))

    tk.Label(frm, text="Header marker regex:").grid(row=3, column=0, sticky="w")
    tk.Entry(frm, textvariable=header_marker_var, width=70).grid(row=3, column=1, sticky="we", padx=(6, 6))
    tk.Label(frm, text="(default: oper)").grid(row=3, column=2, sticky="w")

    tk.Label(frm, text="Section start regex:").grid(row=4, column=0, sticky="w")
    tk.Entry(frm, textvariable=section_start_var, width=70).grid(row=4, column=1, sticky="we", padx=(6, 6))
    tk.Label(frm, text="(default: mk[ANV]### :)").grid(row=4, column=2, sticky="w")

    btns = tk.Frame(frm, pady=10)
    btns.grid(row=5, column=0, columnspan=3, sticky="w")
    tk.Button(btns, text="Split", width=14, command=do_split).pack(side="left", padx=(0, 8))
    tk.Button(btns, text="Rebuild (Concatenate)", width=22, command=do_build).pack(side="left")

    tk.Label(frm, text="Status:").grid(row=6, column=0, sticky="nw")
    tk.Message(frm, textvariable=status_var, width=650).grid(row=6, column=1, columnspan=2, sticky="we", padx=(6, 6))

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
    sp.add_argument("--sections-per-part", type=int, default=80)
    sp.add_argument("--header-marker-regex", type=str, default=DEFAULT_HEADER_MARKER_REGEX)
    sp.add_argument("--section-start-regex", type=str, default=DEFAULT_SECTION_START_REGEX)

    bp = sub.add_parser("build", help="Rebuild GF file from parts")
    bp.add_argument("--parts-dir", type=Path, required=True)
    bp.add_argument("--out", type=Path, default=None)

    args = ap.parse_args(argv)

    if args.cmd == "split":
        parts_dir = args.parts_dir or (args.gf.parent / f"{args.gf.stem}_parts")
        plan = split_gf_file(
            gf_path=args.gf,
            parts_dir=parts_dir,
            sections_per_part=args.sections_per_part,
            header_marker_regex=args.header_marker_regex,
            section_start_regex=args.section_start_regex,
            overwrite_parts=True,
        )
        print(f"Split OK: {plan.parts_dir}")
        print(f"Parts: {len(plan.part_files)}")
        print(f"Manifest: {Path(plan.parts_dir) / MANIFEST_NAME}")
        return 0

    parts_dir = args.parts_dir
    out = args.out
    if out is None:
        plan = load_manifest(parts_dir)
        out = Path(plan.gf_path)
    built = build_gf_file(parts_dir=parts_dir, out_path=out)
    print(f"Rebuild OK: {built}")
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