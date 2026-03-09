#!/usr/bin/env python3
# build_codex.py
#
# Build an AI-first Markdown codex from the GF SourceMaterial docs.
#
# Inputs used (relative to SourceMaterial root):
# - deep_tech/absfuns.html            (authoritative RGL function table)
# - doc/synopsis.txt                 (category meanings + paradigms sections; popups stripped)
# - manuals/gf-refman.html           (GF language reference)
# - manuals/gf-tutorial.html         (GF tutorial)
# - manuals/gf-shell-reference.html  (GF shell reference)
# - deep_tech/rgl-tutorial.html      (RGL tutorial)
# - doc/api-examples-Eng.txt         (English examples; cleaned)
#
# Output layout (default: ./Codex_MD):
# - 00_manifest/manifest.json
# - 01_gf_language/*.md
# - 02_gf_shell/*.md
# - 03_rgl_api/by_function/*.md
# - 03_rgl_api/by_module/*.md
# - 03_rgl_api/by_category/*.md
# - 04_paradigms/*.md
# - 06_examples/*.md
#
# Works in two modes:
# (A) filesystem mode: point --source to a real SourceMaterial folder
# (B) dump mode: point --dump-index to the Index.txt of the volume-dump format

from __future__ import annotations

import argparse
import datetime as _dt
import html as _html
import json
import re
import shutil
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple


# ---------------------------
# Utilities
# ---------------------------

def slugify(s: str) -> str:
    s = s.strip()
    s = re.sub(r"\s+", "_", s)
    s = re.sub(r"[^A-Za-z0-9_]+", "_", s)
    s = re.sub(r"_+", "_", s).strip("_")
    return s or "untitled"


def ensure_empty_dir(path: Path, overwrite: bool) -> None:
    if path.exists():
        if not overwrite:
            raise SystemExit(f"Refusing to overwrite existing output dir: {path}")
        shutil.rmtree(path)
    path.mkdir(parents=True, exist_ok=True)


# ---------------------------
# Repo abstraction
# ---------------------------

class Repo:
    def read_text(self, rel_path: str) -> str:
        raise NotImplementedError

    def exists(self, rel_path: str) -> bool:
        raise NotImplementedError


class FilesystemRepo(Repo):
    def __init__(self, root: Path):
        self.root = root

    def read_text(self, rel_path: str) -> str:
        p = self.root / rel_path
        if not p.exists():
            raise FileNotFoundError(rel_path)
        return p.read_text(encoding="utf-8", errors="replace")

    def exists(self, rel_path: str) -> bool:
        return (self.root / rel_path).exists()


def _extract_file_from_volume(volume_text: str, rel_path: str) -> Optional[str]:
    # Find file begin
    m = re.search(r'----- FILE BEGIN -----\npath="' + re.escape(rel_path) + r'"\n', volume_text)
    if not m:
        return None
    start = m.end()

    # File block ends right before the FILE END marker line
    m2 = re.search(r"\n----- FILE END -----\n", volume_text[start:])
    end = start + m2.start() if m2 else len(volume_text)
    block = volume_text[start:end]

    # Chunked files: concatenate chunk payloads
    chunks: List[str] = []
    chunk_begin = re.compile(r"--- CHUNK BEGIN ---\n.*?\n----\n", re.S)

    pos = 0
    while True:
        mb = chunk_begin.search(block, pos)
        if not mb:
            break
        cs = mb.end()
        # last chunk may end right before file end marker, so allow end-of-string
        me = re.search(r"\n--- CHUNK END ---(?=\n|$)", block[cs:])
        if not me:
            break
        ce = cs + me.start()
        chunks.append(block[cs:ce])
        pos = cs + me.end()

    if chunks:
        return "".join(chunks)

    # Non-chunked file: payload starts after first ---- delimiter if present
    m3 = re.search(r"\n----\n", block)
    return block[m3.end():] if m3 else block


class DumpRepo(Repo):
    """
    Reads files from the volume-dump format described in 00_START_HERE.instructions.md,
    using Index.txt to map rel paths -> volume filename.
    """

    def __init__(self, index_path: Path):
        self.index_path = index_path
        self.base_dir = index_path.parent
        self.path_to_volume: Dict[str, str] = {}
        self.vol_cache: Dict[str, str] = {}

        idx_txt = index_path.read_text(encoding="utf-8", errors="replace")

        locator_started = False
        for line in idx_txt.splitlines():
            if line.startswith("==== FILE LOCATOR"):
                locator_started = True
                continue
            if not locator_started:
                continue
            if not line.strip():
                continue

            parts = line.split("\t")
            if len(parts) >= 2 and parts[1].startswith("volume="):
                rel = parts[0].strip()
                vol = parts[1].split("volume=", 1)[1].strip()
                self.path_to_volume[rel] = vol

    def _load_volume(self, vol_name: str) -> str:
        if vol_name in self.vol_cache:
            return self.vol_cache[vol_name]
        p = self.base_dir / vol_name
        txt = p.read_text(encoding="utf-8", errors="replace")
        self.vol_cache[vol_name] = txt
        return txt

    def read_text(self, rel_path: str) -> str:
        vol = self.path_to_volume.get(rel_path)
        if not vol:
            raise FileNotFoundError(rel_path)
        vtxt = self._load_volume(vol)
        content = _extract_file_from_volume(vtxt, rel_path)
        if content is None:
            raise FileNotFoundError(rel_path)
        return content

    def exists(self, rel_path: str) -> bool:
        return rel_path in self.path_to_volume


# ---------------------------
# Parsers / Converters
# ---------------------------

@dataclass
class RglFunRow:
    function: str
    type: str
    example: str
    dependencies: str
    module: str
    module_href: str
    args: List[str]
    ret: str


def parse_absfuns_table(absfuns_html: str) -> List[RglFunRow]:
    # Extract first TABLE block
    m = re.search(r"<TABLE\b[^>]*>(.*?)</TABLE>", absfuns_html, flags=re.S | re.I)
    if not m:
        raise ValueError("Could not find <TABLE> in deep_tech/absfuns.html")
    table = m.group(1)

    rows = re.findall(r"<TR\b[^>]*>(.*?)</TR>", table, flags=re.S | re.I)
    out: List[RglFunRow] = []

    def strip_tags(s: str) -> str:
        s = re.sub(r"<[^>]+>", "", s)
        s = _html.unescape(s)
        return re.sub(r"\s+", " ", s).strip()

    for row in rows:
        # Skip header row
        if re.search(r"<B>\s*Function\s*</B>", row, flags=re.I):
            continue

        tds = re.findall(r"<TD\b[^>]*>(.*?)</TD>", row, flags=re.S | re.I)
        if len(tds) < 5:
            continue

        fn = strip_tags(tds[0])
        typ = strip_tags(tds[1])
        ex = strip_tags(tds[2])
        deps = strip_tags(tds[3])
        mod = strip_tags(tds[4])

        href = ""
        mh = re.search(r'<A\b[^>]*HREF="([^"]+)"', tds[4], flags=re.I)
        if mh:
            href = _html.unescape(mh.group(1))

        # Type breakdown: args / return
        parts = [p.strip() for p in typ.split("->")]
        if len(parts) >= 2:
            args = parts[:-1]
            ret = parts[-1]
        elif parts:
            args = []
            ret = parts[0]
        else:
            args = []
            ret = ""

        out.append(
            RglFunRow(
                function=fn,
                type=typ,
                example="" if ex == "-" else ex,
                dependencies="" if deps == "-" else deps,
                module=mod,
                module_href=href,
                args=args,
                ret=ret,
            )
        )

    return out


def clean_synopsis_txt2tags(text: str) -> str:
    """
    Remove txt2tags directives and remove #divpopup .. #ediv translation popups.
    Keep the rest (AI-friendly), minimal macro normalization.
    """
    lines = text.splitlines()

    cleaned: List[str] = []
    skip_directives = True
    popup_depth = 0

    for line in lines:
        # Drop txt2tags directive preamble + title line
        if skip_directives:
            if line.startswith("%!") or line.strip() == "" or line.startswith("GF Resource Grammar Library: Synopsis"):
                continue
            skip_directives = False

        # Remove popup blocks (translation token bloat)
        if popup_depth > 0:
            popup_depth += line.count("#divpopup")
            popup_depth -= line.count("#ediv")
            if popup_depth <= 0:
                popup_depth = 0
            continue

        if line.strip().startswith("#divpopup"):
            popup_depth = 1
            popup_depth += line.count("#divpopup") - 1
            popup_depth -= line.count("#ediv")
            if popup_depth < 0:
                popup_depth = 0
            continue

        # Normalize some macros to simple Markdown
        if line.strip().startswith("#divreveal"):
            cleaned.append("> Example:")
            continue
        if line.strip() == "#ediv":
            continue
        if line.strip() in {"#UL", "#EUL"}:
            continue
        if line.strip().startswith("#LI"):
            item = line.strip()[3:].strip()
            cleaned.append(f"- {item}" if item else "-")
            continue
        if line.strip() == "#quicklinks":
            continue

        cleaned.append(line)

    out = "\n".join(cleaned)
    out = re.sub(r"\n{3,}", "\n\n", out).strip() + "\n"
    return out


def split_synopsis_by_headers(clean_text: str) -> List[Tuple[str, str]]:
    """
    Split on txt2tags '== Header =='.
    Includes a preface section named 'Synopsis' if any content exists before the first header.
    """
    parts = re.split(r"^\s*==\s*([^=]+?)\s*==\s*$", clean_text, flags=re.M)
    sections: List[Tuple[str, str]] = []
    preface = parts[0].strip()
    if preface:
        sections.append(("Synopsis", preface))
    for i in range(1, len(parts), 2):
        title = parts[i].strip()
        body = parts[i + 1].strip()
        sections.append((title, body))
    return sections


def html_to_md_basic(html_text: str) -> str:
    """
    Minimal HTML -> Markdown conversion sufficient for LLM consumption.
    Uses BeautifulSoup if installed; otherwise falls back to tag stripping with pre-block preservation.
    """
    try:
        from bs4 import BeautifulSoup  # type: ignore

        soup = BeautifulSoup(html_text, "html.parser")
        for t in soup(["script", "style", "noscript"]):
            t.decompose()

        body = soup.body or soup

        md_lines: List[str] = []

        def emit(s: str = "") -> None:
            md_lines.append(s)

        def walk(node) -> None:
            # NavigableString
            if getattr(node, "name", None) is None:
                txt = re.sub(r"\s+", " ", str(node))
                if txt.strip():
                    emit(txt.strip())
                return

            name = node.name.lower()

            if name in {"h1", "h2", "h3", "h4", "h5", "h6"}:
                level = int(name[1])
                title = node.get_text(" ", strip=True)
                emit()
                emit("#" * level + " " + title)
                emit()
                return

            if name == "p":
                txt = node.get_text(" ", strip=True)
                if txt:
                    emit(txt)
                    emit()
                return

            if name == "pre":
                code = node.get_text("\n", strip=False).rstrip()
                emit("```")
                emit(code)
                emit("```")
                emit()
                return

            if name == "ul":
                emit()
                for li in node.find_all("li", recursive=False):
                    txt = li.get_text(" ", strip=True)
                    emit(f"- {txt}")
                emit()
                return

            if name == "ol":
                emit()
                i = 1
                for li in node.find_all("li", recursive=False):
                    txt = li.get_text(" ", strip=True)
                    emit(f"{i}. {txt}")
                    i += 1
                emit()
                return

            if name == "table":
                # degrade table to "row | row | row" lines
                emit()
                for tr in node.find_all("tr"):
                    cells = [c.get_text(" ", strip=True) for c in tr.find_all(["th", "td"])]
                    if cells:
                        emit(" | ".join(cells))
                emit()
                return

            # default: walk children
            for child in getattr(node, "children", []):
                walk(child)

        walk(body)
        md = "\n".join(md_lines)
        md = re.sub(r"\n{3,}", "\n\n", md).strip() + "\n"
        return md

    except Exception:
        # Fallback: preserve <pre> blocks, strip everything else
        pre_blocks: List[str] = []

        def repl_pre(m) -> str:
            pre_blocks.append(_html.unescape(m.group(1)))
            return f"__PRE_BLOCK_{len(pre_blocks)-1}__"

        tmp = re.sub(r"<pre\b[^>]*>(.*?)</pre>", repl_pre, html_text, flags=re.S | re.I)
        tmp = re.sub(r"<[^>]+>", "", tmp)
        tmp = _html.unescape(tmp)
        tmp = re.sub(r"\r\n", "\n", tmp)
        tmp = re.sub(r"\n{3,}", "\n\n", tmp)

        for i, code in enumerate(pre_blocks):
            tmp = tmp.replace(f"__PRE_BLOCK_{i}__", "```\n" + code.strip() + "\n```")

        return tmp.strip() + "\n"


def parse_api_examples_eng(text: str) -> List[Dict[str, object]]:
    """
    Parse doc/api-examples-Eng.txt blocks:
    - blocks separated by line: > > *
    - within a block, keep lines starting with: > >
    """
    lines = text.splitlines()
    blocks: List[List[str]] = []
    cur: List[str] = []

    for line in lines:
        if line.strip() == "> > *":
            if cur:
                blocks.append(cur)
                cur = []
            continue
        if line.startswith("> > "):
            cur.append(line[4:])

    if cur:
        blocks.append(cur)

    def clean_out(s: str) -> str:
        s = s.replace("Predef.SOFT_BIND", "").strip()
        s = re.sub(r"\s+\.", ".", s)
        s = re.sub(r"\s+\?", "?", s)
        s = re.sub(r"\s+,", ",", s)
        s = re.sub(r"\s{2,}", " ", s)
        return s.strip()

    out: List[Dict[str, object]] = []
    for b in blocks:
        if not b:
            continue
        label = b[0].strip()
        expr = b[1].strip() if len(b) > 1 else ""
        outputs = [clean_out(x) for x in b[2:] if x.strip()] if len(b) > 2 else []
        out.append({"label": label, "expr": expr, "outputs": outputs})
    return out


# ---------------------------
# Builders
# ---------------------------

def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content.rstrip() + "\n", encoding="utf-8")


def build_codex(repo: Repo, out_dir: Path, overwrite: bool) -> None:
    ensure_empty_dir(out_dir, overwrite=overwrite)

    # Create base layout
    for d in [
        "00_manifest",
        "01_gf_language",
        "02_gf_shell",
        "03_rgl_api/by_function",
        "03_rgl_api/by_module",
        "03_rgl_api/by_category",
        "04_paradigms",
        "06_examples",
    ]:
        (out_dir / d).mkdir(parents=True, exist_ok=True)

    # ---- 1) RGL API from absfuns.html
    abs_html = repo.read_text("deep_tech/absfuns.html")
    fun_rows = parse_absfuns_table(abs_html)

    producers: Dict[str, List[str]] = defaultdict(list)  # category -> functions returning it
    consumers: Dict[str, List[str]] = defaultdict(list)  # category -> functions taking it

    for r in fun_rows:
        if r.ret:
            producers[r.ret].append(r.function)
        for a in r.args:
            if a:
                consumers[a].append(r.function)

    manifest: Dict[str, object] = {
        "generated_at": _dt.datetime.utcnow().isoformat() + "Z",
        "functions": {},
        "modules": {},
        "categories": {},
    }

    # Per-function pages + module mapping
    for r in fun_rows:
        fn = r.function
        fn_slug = slugify(fn)
        md_rel = f"03_rgl_api/by_function/{fn_slug}.md"
        src_anchor = f"https://www.grammaticalframework.org/lib/doc/absfuns.html#{fn}"

        lines: List[str] = []
        lines.append(f"# {fn}\n")
        lines.append(f"- Module: `{r.module}`")
        lines.append(f"- Type: `{r.type}`")
        if r.dependencies:
            lines.append(f"- Dependencies: `{r.dependencies}`")
        if r.example:
            lines.append(f"- Example: {r.example}")
        lines.append(f"- Source: {src_anchor}\n")

        lines.append("## Type breakdown")
        if r.args:
            lines.append("- Args: " + ", ".join(f"`{a}`" for a in r.args))
        if r.ret:
            lines.append(f"- Returns: `{r.ret}`")
        lines.append("")

        write_text(out_dir / md_rel, "\n".join(lines))

        manifest["functions"][fn] = {
            "module": r.module,
            "type": r.type,
            "args": r.args,
            "ret": r.ret,
            "example": r.example,
            "dependencies": r.dependencies,
            "path": md_rel,
            "source": src_anchor,
        }

        modules = manifest["modules"]
        if r.module not in modules:
            modules[r.module] = {"functions": []}
        modules[r.module]["functions"].append(fn)

    # Per-module pages
    for mod, info in sorted(manifest["modules"].items(), key=lambda x: x[0].lower()):
        fns = sorted(info["functions"])
        mod_slug = slugify(mod)
        md_rel = f"03_rgl_api/by_module/{mod_slug}.md"

        lines = [f"# Module: {mod}\n", f"- Functions: {len(fns)}\n", "## Functions"]
        for fn in fns:
            fn_slug = slugify(fn)
            typ = manifest["functions"][fn]["type"]
            lines.append(f"- [{fn}](../by_function/{fn_slug}.md) — `{typ}`")

        write_text(out_dir / md_rel, "\n".join(lines))
        info["path"] = md_rel

    # ---- 2) Categories + paradigms from synopsis.txt
    syn_raw = repo.read_text("doc/synopsis.txt")
    syn_clean = clean_synopsis_txt2tags(syn_raw)
    syn_sections = split_synopsis_by_headers(syn_clean)
    syn_map = {t: b for t, b in syn_sections}

    # Write synopsis sections (except Explanations handled specially)
    for title, body in syn_sections:
        if title == "Explanations":
            continue

        if title.startswith("Paradigms for "):
            lang = title.replace("Paradigms for ", "").strip()
            md_rel = f"04_paradigms/Paradigms_{slugify(lang)}.md"
        else:
            md_rel = f"03_rgl_api/by_category/Synopsis_{slugify(title)}.md"

        write_text(out_dir / md_rel, f"# {title}\n\n{body}\n")

    # Parse Explanations (txt2tags table) into per-category files + index
    explain = syn_map.get("Explanations", "")
    cat_rows: List[Tuple[str, str, str]] = []  # (Cat, Meaning, Example)

    for line in explain.splitlines():
        if not line.startswith("|"):
            continue
        if line.startswith("||"):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if len(cells) < 3:
            continue

        cat_cell, meaning, example = cells[0], cells[1], cells[2]
        # cat cell is often like: [NP #NP]
        m = re.match(r"\[([^\s\]]+)\s*#([^\]]+)\]", cat_cell)
        cat = (m.group(1) if m else cat_cell).strip("[] ")

        example = re.sub(r"//", "", example)
        cat_rows.append((cat, meaning, example))

    # Category index
    idx_lines = ["# RGL Categories\n", f"- Categories: {len(cat_rows)}\n", "## Index"]
    for cat, meaning, _ in sorted(cat_rows, key=lambda x: x[0].lower()):
        idx_lines.append(f"- [`{cat}`](Cat_{slugify(cat)}.md) — {meaning}")
    write_text(out_dir / "03_rgl_api/by_category/Categories_Index.md", "\n".join(idx_lines))

    # Per-category pages: meaning + producer/consumer lists
    for cat, meaning, example in cat_rows:
        prods = sorted(set(producers.get(cat, [])))
        cons = sorted(set(consumers.get(cat, [])))

        lines: List[str] = [f"# Category: {cat}\n", f"- Meaning: {meaning}"]
        if example.strip():
            lines.append(f"- Example: {example}")
        lines.append("")
        lines.append("## Producers (returns this category)")
        lines.append(f"- Count: {len(prods)}")
        for fn in prods:
            lines.append(f"- [{fn}](../by_function/{slugify(fn)}.md)")

        lines.append("")
        lines.append("## Consumers (takes this category as an argument)")
        lines.append(f"- Count: {len(cons)}")
        for fn in cons:
            lines.append(f"- [{fn}](../by_function/{slugify(fn)}.md)")
        lines.append("")

        md_rel = f"03_rgl_api/by_category/Cat_{slugify(cat)}.md"
        write_text(out_dir / md_rel, "\n".join(lines))

        manifest["categories"][cat] = {
            "meaning": meaning,
            "example": example,
            "producers": prods,
            "consumers": cons,
            "path": md_rel,
        }

    # ---- 3) Manuals / tutorials HTML -> basic Markdown
    manual_map = {
        "manuals/gf-refman.html": "01_gf_language/gf-refman.md",
        "manuals/gf-tutorial.html": "01_gf_language/gf-tutorial.md",
        "manuals/gf-shell-reference.html": "02_gf_shell/gf-shell-reference.md",
        "deep_tech/rgl-tutorial.html": "04_paradigms/rgl-tutorial.md",
    }

    for src, dst in manual_map.items():
        if repo.exists(src):
            md = html_to_md_basic(repo.read_text(src))
            write_text(out_dir / dst, md)

    # ---- 4) English examples
    if repo.exists("doc/api-examples-Eng.txt"):
        examples = parse_api_examples_eng(repo.read_text("doc/api-examples-Eng.txt"))
        lines: List[str] = ["# RGL API Examples (English)\n"]
        for e in examples:
            label = str(e["label"])
            expr = str(e["expr"])
            outputs = e["outputs"]  # type: ignore

            lines.append(f"## {label}")
            if expr.strip():
                lines.append("```gf")
                lines.append(expr)
                lines.append("```")
            if outputs:
                lines.append("```txt")
                for o in outputs:
                    lines.append(str(o))
                lines.append("```")
            lines.append("")
        write_text(out_dir / "06_examples/api-examples-Eng.md", "\n".join(lines))

    # ---- 5) Manifest + README
    write_text(out_dir / "00_manifest/manifest.json", json.dumps(manifest, indent=2, ensure_ascii=False))

    readme = "\n".join(
        [
            "# Codex_MD",
            "",
            "Generated Markdown codex for AI consumption.",
            "",
            "## Layout",
            "- `03_rgl_api/by_function/` — one function per file (from `deep_tech/absfuns.html`)",
            "- `03_rgl_api/by_module/` — functions grouped by module",
            "- `03_rgl_api/by_category/` — category pages with producer/consumer lists (from `doc/synopsis.txt`)",
            "- `01_gf_language/` — core GF language + tutorial (HTML converted)",
            "- `02_gf_shell/` — GF shell reference (HTML converted)",
            "- `04_paradigms/` — paradigms sections + RGL tutorial (converted)",
            "- `06_examples/` — cleaned English API examples",
            "- `00_manifest/manifest.json` — machine-readable index",
            "",
        ]
    )
    write_text(out_dir / "README.md", readme)


# ---------------------------
# CLI
# ---------------------------

def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="Codex_MD", help="Output directory (default: Codex_MD)")
    ap.add_argument("--overwrite", action="store_true", help="Overwrite output dir if it exists")

    mode = ap.add_mutually_exclusive_group(required=True)
    mode.add_argument("--source", help="Path to real SourceMaterial folder (filesystem mode)")
    mode.add_argument("--dump-index", help="Path to Index.txt for volume-dump format (dump mode)")

    args = ap.parse_args()
    out_dir = Path(args.out).resolve()

    if args.source:
        repo: Repo = FilesystemRepo(Path(args.source).resolve())
    else:
        repo = DumpRepo(Path(args.dump_index).resolve())

    build_codex(repo=repo, out_dir=out_dir, overwrite=args.overwrite)

    # Minimal summary
    print(f"OK: wrote {out_dir}")
    print("Key outputs:")
    print(f"- {out_dir / '00_manifest' / 'manifest.json'}")
    print(f"- {out_dir / '03_rgl_api' / 'by_function'}")
    print(f"- {out_dir / '03_rgl_api' / 'by_category' / 'Categories_Index.md'}")


if __name__ == "__main__":
    main()