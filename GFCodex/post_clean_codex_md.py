# post_clean_codex_md.py
from __future__ import annotations

import html
import os
import re
from pathlib import Path

ROOT = Path(r"C:\MyCode\GFCodex\Codex_MD")

# Lines that are typical website navigation boilerplate in converted manuals
NAV_LINE_PATTERNS = [
    re.compile(r"^\s*Learn more\s*$", re.I),
    re.compile(r"^\s*Get started\s*$", re.I),
    re.compile(r"^\s*Develop\s*$", re.I),
    re.compile(r"^\s*Contribute\s*$", re.I),
    re.compile(r"^\s*Repositories\s*$", re.I),
    re.compile(r"^\s*GF\s*[·•]\s*$", re.I),
    re.compile(r"^\s*RGL\s*[·•]\s*$", re.I),
    re.compile(r"^\s*Contributions\s*$", re.I),
]

def strip_nav_lines(lines: list[str]) -> list[str]:
    out: list[str] = []
    for ln in lines:
        if any(p.match(ln) for p in NAV_LINE_PATTERNS):
            continue
        out.append(ln)
    return out

def clean_md_text(text: str) -> str:
    # Unescape common HTML entities everywhere
    text = html.unescape(text)

    # Remove stray </code> at end-of-line (common from <pre><code> conversions)
    text = re.sub(r"</code>\s*$", "", text, flags=re.MULTILINE)

    # Remove <code> wrappers at line start/end (often embedded inside ``` blocks)
    text = re.sub(r"^\s*<code>\s*", "", text, flags=re.MULTILINE)
    text = re.sub(r"\s*</code>\s*$", "", text, flags=re.MULTILINE)

    # If any inline <code> remains, convert to backticks (minimal)
    text = re.sub(r"<code>(.*?)</code>", lambda m: f"`{m.group(1)}`", text, flags=re.DOTALL)

    # Collapse excessive blank lines a bit
    text = re.sub(r"\n{4,}", "\n\n\n", text)

    # Strip some navigation boilerplate lines
    lines = text.splitlines(True)
    lines = strip_nav_lines(lines)
    return "".join(lines)

def main() -> None:
    if not ROOT.exists():
        raise SystemExit(f"Codex_MD folder not found: {ROOT}")

    changed = 0
    scanned = 0

    for p in ROOT.rglob("*.md"):
        scanned += 1
        raw = p.read_text(encoding="utf-8", errors="replace")
        cleaned = clean_md_text(raw)
        if cleaned != raw:
            p.write_text(cleaned, encoding="utf-8", newline="\n")
            changed += 1

    print(f"Scanned {scanned} .md files. Updated {changed} files.")

if __name__ == "__main__":
    main()