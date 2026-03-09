#!/usr/bin/env python3
# build_codex_v2.py
#
# Builds an AI-first Markdown codex from GF SourceMaterial with:
# - RGL API extracted from deep_tech/absfuns.html
# - overload-safe function pages (mkNP etc.)
# - synopsis Explanations -> TYPE pages only (filtered to real types used in signatures)
# - popup-translation bloat removed everywhere
# - manuals converted to readable Markdown (basic)
# - English API examples cleaned
#
# Works in two modes:
#   (A) filesystem mode: --source /path/to/SourceMaterial
#   (B) dump mode:       --dump-index /path/to/Index.txt  (volume-dump format)

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
# helpers
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


def write_text(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content.rstrip() + "\n", encoding="utf-8")


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
    m = re.search(r'----- FILE BEGIN -----\npath="' + re.escape(rel_path) + r'"\n', volume_text)
    if not m:
        return None
    start = m.end()

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
        me = re.search(r"\n--- CHUNK END ---\n", block[cs:])
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
    Reads files from the volume-dump format (Index.txt + volume text files).
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
# Cleaning: remove popup translation bloat
# ---------------------------

# Remove inline popup blocks anywhere in a string (same-line or multi-line)
def strip_popups_anywhere(s: str) -> str:
    if not s:
        return ""
    while True:
        start = s.find("#divpopup")
        if start < 0:
            break
        end = s.find("#ediv", start)
        if end < 0:
            s = s[:start]
            break
        end = end + len("#ediv")
        # consume immediate repeated "#ediv" tokens separated only by whitespace
        while True:
            m = re.match(r"\s*#ediv", s[end:])
            if not m:
                break
            end += m.end()
        s = s[:start] + s[end:]
    return s


DIVREVEAL_RE = re.compile(r"#divreveal\s*//(.*?)//", flags=re.S)
LIAPI_RE = re.compile(r"#LIAPI:\s*``([^`]+)``")
LIENG_RE = re.compile(r"#LIEng:\s*(?://([^/]+)//|([^#]+))")


def compress_example(cell: str) -> str:
    """
    Input: synopsis Example cell (often contains #divreveal + #divpopup hover list)
    Output: compact AI-friendly: "<english_gloss> | `<liapi>`"
    """
    if not cell:
        return ""
    cell = cell.replace("\r\n", "\n")

    gloss = ""
    m = DIVREVEAL_RE.search(cell)
    if m:
        gloss = m.group(1).strip()

    api = ""
    m = LIAPI_RE.search(cell)
    if m:
        api = m.group(1).strip()

    if not gloss:
        m = LIENG_RE.search(cell)
        if m:
            gloss = (m.group(1) or m.group(2) or "").strip()

    if gloss and api:
        return f"{gloss} | `{api}`"
    if api:
        return f"`{api}`"
    if gloss:
        return gloss

    return strip_popups_anywhere(cell).replace("#divreveal", "").strip()


def clean_synopsis_txt2tags_for_sections(text: str) -> str:
    """
    Clean synopsis for slicing normal sections (NOT Explanations table):
    - remove txt2tags directives
    - remove popup translation blocks (line-oriented)
    - keep readable content
    """
    text = text.replace("\r\n", "\n")
    lines = text.splitlines()

    cleaned: List[str] = []
    skip_directives = True
    popup_depth = 0

    for line in lines:
        if skip_directives:
            if line.startswith("%!") or line.strip() == "" or line.startswith("GF Resource Grammar Library: Synopsis"):
                continue
            skip_directives = False

        # popup begins on this line
        if "#divpopup" in line:
            # keep anything before popup marker (usually reveal gloss)
            prefix = line.split("#divpopup", 1)[0].rstrip()
            if prefix:
                cleaned.append(prefix)
            # update depth correctly even if #ediv is on same line
            popup_depth = max(0, popup_depth + line.count("#divpopup") - line.count("#ediv"))
            continue

        # inside popup
        if popup_depth > 0:
            popup_depth = max(0, popup_depth - line.count("#ediv"))
            continue

        # minimal macro normalization
        if line.strip().startswith("#divreveal"):
            cleaned.append("> Example:")
            continue
        if line.strip() == "#ediv":
            continue
        if line.strip() in {"#UL", "#EUL", "#quicklinks"}:
            continue
        if line.strip().startswith("#LI"):
            item = line.strip()[3:].strip()
            cleaned.append(f"- {item}" if item else "-")
            continue

        cleaned.append(line)

    out = "\n".join(cleaned)
    out = re.sub(r"\n{3,}", "\n\n", out).strip() + "\n"
    return out


def split_synopsis_by_headers(clean_text: str) -> List[Tuple[str, str]]:
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


def extract_synopsis_section_raw(synopsis_raw: str, section_title: str) -> str:
    """
    Extract a raw txt2tags section body between:
      == <section_title> ==
    and the next header (== ... ==) or EOF.
    """
    synopsis_raw = synopsis_raw.replace("\r\n", "\n")
    # section header line
    pat = re.compile(rf"^\s*==\s*{re.escape(section_title)}\s*==\s*$", flags=re.M)
    m = pat.search(synopsis_raw)
    if not m:
        return ""
    start = m.end()
    m2 = re.search(r"^\s*==\s*[^=]+?\s*==\s*$", synopsis_raw[start:], flags=re.M)
    end = start + m2.start() if m2 else len(synopsis_raw)
    return synopsis_raw[start:end].strip()


# ---------------------------
# Parsers
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
    """
    absfuns.html in this corpus does not reliably contain a closing </TABLE>.
    So: parse from <TABLE ...> up to </BODY> (or EOF) and extract <TR> blocks.
    """
    m = re.search(r"<TABLE\b[^>]*>", absfuns_html, flags=re.I)
    if not m:
        raise ValueError("Could not find <TABLE ...> in deep_tech/absfuns.html")

    start = m.start()
    end = len(absfuns_html)
    m_end = re.search(r"</BODY>", absfuns_html, flags=re.I)
    if m_end:
        end = m_end.start()

    table = absfuns_html[start:end]
    rows = re.findall(r"<TR\b[^>]*>(.*?)</TR>", table, flags=re.S | re.I)

    def strip_tags(s: str) -> str:
        s = re.sub(r"<[^>]+>", "", s)
        s = _html.unescape(s)
        return re.sub(r"\s+", " ", s).strip()

    out: List[RglFunRow] = []
    for row in rows:
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

        parts = [p.strip() for p in typ.split("->")]
        args = parts[:-1] if len(parts) >= 2 else []
        ret = parts[-1] if parts else ""

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


def html_to_md_basic(html_text: str) -> str:
    """
    Minimal HTML -> Markdown:
    - preserve <pre> blocks
    - strip other tags
    """
    pre_blocks: List[str] = []

    def repl_pre(m) -> str:
        pre_blocks.append(_html.unescape(m.group(1)))
        return f"__PRE_BLOCK_{len(pre_blocks)-1}__"

    tmp = re.sub(r"<pre\b[^>]*>(.*?)</pre>", repl_pre, html_text, flags=re.S | re.I)
    tmp = re.sub(r"<script\b.*?</script>", "", tmp, flags=re.S | re.I)
    tmp = re.sub(r"<style\b.*?</style>", "", tmp, flags=re.S | re.I)
    tmp = re.sub(r"<[^>]+>", "", tmp)
    tmp = _html.unescape(tmp)
    tmp = tmp.replace("\r\n", "\n")
    tmp = re.sub(r"\n{3,}", "\n\n", tmp)

    for i, code in enumerate(pre_blocks):
        tmp = tmp.replace(f"__PRE_BLOCK_{i}__", "```\n" + code.strip() + "\n```")

    return tmp.strip() + "\n"


def parse_api_examples_eng(text: str) -> List[Dict[str, object]]:
    text = text.replace("\r\n", "\n")
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
        s = s.replace("Predef.SOFT_BIND", "")
        s = re.sub(r"\s{2,}", " ", s).strip()
        return s

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
# Build
# ---------------------------

def build_codex(repo: Repo, out_dir: Path, overwrite: bool) -> None:
    ensure_empty_dir(out_dir, overwrite=overwrite)

    for d in [
        "00_manifest",
        "01_gf_language",
        "02_gf_shell",
        "03_rgl_api/by_function",
        "03_rgl_api/by_module",
        "03_rgl_api/by_type",
        "04_paradigms",
        "06_examples",
    ]:
        (out_dir / d).mkdir(parents=True, exist_ok=True)

    # ---- RGL API (absfuns)
    fun_rows = parse_absfuns_table(repo.read_text("deep_tech/absfuns.html"))

    # overload handling
    rows_by_name: Dict[str, List[RglFunRow]] = defaultdict(list)
    for r in fun_rows:
        rows_by_name[r.function].append(r)

    # signature-id tables for type graphs and linking
    sig_meta: Dict[str, Dict[str, object]] = {}
    producers: Dict[str, List[str]] = defaultdict(list)  # type -> sig_id (returns)
    consumers: Dict[str, List[str]] = defaultdict(list)  # type -> sig_id (args)

    manifest: Dict[str, object] = {
        "generated_at": _dt.datetime.utcnow().isoformat() + "Z",
        "functions": {},   # name -> {overloads:[...], path_if_aggregator?}
        "modules": {},     # module -> {entries:[sig_id...], path}
        "types": {},       # type -> {meaning, example, producers, consumers, path}
        "signatures": {},  # sig_id -> {function, overload, type, args, ret, module, path, source}
    }

    # write per-function overload pages + (if overloaded) aggregator page
    for fn in sorted(rows_by_name.keys(), key=str.lower):
        rows = rows_by_name[fn]
        rows_sorted = sorted(rows, key=lambda r: r.type)

        # if overloaded, create an aggregator at by_function/<fn>.md and put overloads into __NN
        if len(rows_sorted) > 1:
            agg_rel = f"03_rgl_api/by_function/{slugify(fn)}.md"
            agg_lines = [
                f"# {fn}",
                "",
                f"- Overloads: {len(rows_sorted)}",
                "",
                "## Overloads",
            ]
            for i, r in enumerate(rows_sorted, start=1):
                sig_id = f"{fn}#{i}"
                fn_file = f"{slugify(fn)}__{i:02d}.md"
                fn_rel = f"03_rgl_api/by_function/{fn_file}"
                agg_lines.append(f"- [{fn} (overload {i})]({fn_file}) — `{r.type}`")
                # write overload file below
            write_text(out_dir / agg_rel, "\n".join(agg_lines))
            agg_path = agg_rel
        else:
            agg_path = ""  # no aggregator

        overloads: List[Dict[str, object]] = []
        for i, r in enumerate(rows_sorted, start=1):
            sig_id = f"{fn}#{i}"
            if len(rows_sorted) > 1:
                md_file = f"{slugify(fn)}__{i:02d}.md"
                title = f"# {fn} (overload {i}/{len(rows_sorted)})"
            else:
                md_file = f"{slugify(fn)}.md"
                title = f"# {fn}"

            md_rel = f"03_rgl_api/by_function/{md_file}"
            src_anchor = f"https://www.grammaticalframework.org/lib/doc/absfuns.html#{fn}"

            lines: List[str] = [title, ""]
            lines.append(f"- Module: `{r.module}`")
            lines.append(f"- Type: `{r.type}`")
            if r.dependencies:
                lines.append(f"- Dependencies: `{r.dependencies}`")
            if r.example:
                lines.append(f"- Example: {r.example}")
            lines.append(f"- Source: {src_anchor}")
            lines += ["", "## Type breakdown"]
            if r.args:
                lines.append("- Args: " + ", ".join(f"`{a}`" for a in r.args))
            if r.ret:
                lines.append(f"- Returns: `{r.ret}`")
            lines.append("")

            write_text(out_dir / md_rel, "\n".join(lines))

            sig_meta[sig_id] = {
                "function": fn,
                "overload": i,
                "type": r.type,
                "args": r.args,
                "ret": r.ret,
                "module": r.module,
                "dependencies": r.dependencies,
                "example": r.example,
                "path": md_rel,
                "source": src_anchor,
            }
            manifest["signatures"][sig_id] = sig_meta[sig_id]

            overloads.append(
                {
                    "overload": i,
                    "type": r.type,
                    "args": r.args,
                    "ret": r.ret,
                    "module": r.module,
                    "dependencies": r.dependencies,
                    "example": r.example,
                    "path": md_rel,
                    "source": src_anchor,
                    "sig_id": sig_id,
                }
            )

            if r.ret:
                producers[r.ret].append(sig_id)
            for a in r.args:
                if a:
                    consumers[a].append(sig_id)

            # module index entries should reference sig_id (not just name)
            mod = r.module
            manifest["modules"].setdefault(mod, {"entries": []})
            manifest["modules"][mod]["entries"].append(sig_id)

        manifest["functions"][fn] = {
            "aggregator_path": agg_path or None,
            "overloads": overloads,
        }

    # derive real types from signatures
    all_types = set(producers.keys()) | set(consumers.keys())

    # ---- per-module pages
    for mod, info in sorted(manifest["modules"].items(), key=lambda x: x[0].lower()):
        entries: List[str] = info["entries"]
        # stable: sort by function name then overload
        entries_sorted = sorted(entries, key=lambda sid: (sig_meta[sid]["function"].lower(), int(sig_meta[sid]["overload"])))
        mod_slug = slugify(mod)
        md_rel = f"03_rgl_api/by_module/{mod_slug}.md"

        lines = [
            f"# Module: {mod}",
            "",
            f"- Signatures: {len(entries_sorted)}",
            "",
            "## Entries",
        ]
        for sid in entries_sorted:
            m = sig_meta[sid]
            fn = m["function"]
            overload = int(m["overload"])
            typ = m["type"]
            path = Path(m["path"]).name  # by_function file
            label = f"{fn} (overload {overload})" if len(manifest["functions"][fn]["overloads"]) > 1 else fn
            lines.append(f"- [{label}](../by_function/{path}) — `{typ}`")

        write_text(out_dir / md_rel, "\n".join(lines))
        info["path"] = md_rel

    # ---- synopsis: paradigms sections (cleaned)
    synopsis_raw = repo.read_text("doc/synopsis.txt")
    synopsis_clean = clean_synopsis_txt2tags_for_sections(synopsis_raw)
    syn_sections = split_synopsis_by_headers(synopsis_clean)

    for title, body in syn_sections:
        if title.startswith("Paradigms for "):
            lang = title.replace("Paradigms for ", "").strip()
            md_rel = f"04_paradigms/Paradigms_{slugify(lang)}.md"
            write_text(out_dir / md_rel, f"# Paradigms: {lang}\n\n{body}\n")

    # ---- synopsis: Explanations table (RAW extract; then compress examples; filter to real types)
    explain_raw = extract_synopsis_section_raw(synopsis_raw, "Explanations")

    type_rows: List[Tuple[str, str, str]] = []  # (Type, Meaning, Example)
    for line in explain_raw.splitlines():
        if not line.startswith("|") or line.startswith("||"):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if len(cells) < 3:
            continue

        cat_cell, meaning_cell, example_cell = cells[0], cells[1], cells[2]

        # cat cell is often like: [NP #NP]
        m = re.match(r"\[([^\s\]]+)\s*#([^\]]+)\]", cat_cell)
        cat = (m.group(1) if m else cat_cell).strip("[] ")

        if cat not in all_types:
            continue

        meaning = strip_popups_anywhere(meaning_cell).strip()
        example = compress_example(example_cell)

        type_rows.append((cat, meaning, example))

    # type index + type pages
    idx_lines = ["# RGL Types", "", f"- Types: {len(type_rows)}", "", "## Index"]
    for t, meaning, _ in sorted(type_rows, key=lambda x: x[0].lower()):
        idx_lines.append(f"- [`{t}`](Type_{slugify(t)}.md) — {meaning}")
    write_text(out_dir / "03_rgl_api/by_type/Types_Index.md", "\n".join(idx_lines))

    for t, meaning, example in type_rows:
        prod_sids = sorted(set(producers.get(t, [])), key=lambda sid: (sig_meta[sid]["function"].lower(), int(sig_meta[sid]["overload"])))
        cons_sids = sorted(set(consumers.get(t, [])), key=lambda sid: (sig_meta[sid]["function"].lower(), int(sig_meta[sid]["overload"])))

        lines = [f"# Type: {t}", "", f"- Meaning: {meaning}"]
        if example:
            lines.append(f"- Example: {example}")

        lines += ["", "## Producers (returns this type)", f"- Count: {len(prod_sids)}"]
        for sid in prod_sids:
            m = sig_meta[sid]
            fn = m["function"]
            overload = int(m["overload"])
            typ = m["type"]
            path = Path(m["path"]).name
            label = f"{fn} (overload {overload})" if len(manifest["functions"][fn]["overloads"]) > 1 else fn
            lines.append(f"- [{label}](../by_function/{path}) — `{typ}`")

        lines += ["", "## Consumers (takes this type as an argument)", f"- Count: {len(cons_sids)}"]
        for sid in cons_sids:
            m = sig_meta[sid]
            fn = m["function"]
            overload = int(m["overload"])
            typ = m["type"]
            path = Path(m["path"]).name
            label = f"{fn} (overload {overload})" if len(manifest["functions"][fn]["overloads"]) > 1 else fn
            lines.append(f"- [{label}](../by_function/{path}) — `{typ}`")

        lines.append("")

        md_rel = f"03_rgl_api/by_type/Type_{slugify(t)}.md"
        write_text(out_dir / md_rel, "\n".join(lines))

        manifest["types"][t] = {
            "meaning": meaning,
            "example": example,
            "producers": prod_sids,
            "consumers": cons_sids,
            "path": md_rel,
        }

    # ---- manuals
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

    # ---- examples
    if repo.exists("doc/api-examples-Eng.txt"):
        examples = parse_api_examples_eng(repo.read_text("doc/api-examples-Eng.txt"))
        lines: List[str] = ["# RGL API Examples (English)\n"]
        for e in examples:
            lines.append(f"## {e['label']}")
            expr = str(e.get("expr", ""))
            outputs = e.get("outputs", [])
            if expr.strip():
                lines += ["```gf", expr, "```"]
            if outputs:
                lines.append("```txt")
                for o in outputs:
                    lines.append(str(o))
                lines.append("```")
            lines.append("")
        write_text(out_dir / "06_examples/api-examples-Eng.md", "\n".join(lines))

    # ---- function index
    idx = ["# RGL Functions", "", f"- Functions: {len(manifest['functions'])}", "", "## Index"]
    for fn in sorted(manifest["functions"].keys(), key=str.lower):
        finfo = manifest["functions"][fn]
        ol = finfo["overloads"]
        if len(ol) == 1:
            path = Path(ol[0]["path"]).name
            idx.append(f"- [{fn}](by_function/{path}) — `{ol[0]['type']}`")
        else:
            agg = finfo.get("aggregator_path")
            if agg:
                idx.append(f"- [{fn}](by_function/{Path(agg).name}) — overloads: {len(ol)}")
            else:
                idx.append(f"- {fn} — overloads: {len(ol)}")
    write_text(out_dir / "03_rgl_api/Functions_Index.md", "\n".join(idx))

    # ---- manifest + README
    write_text(out_dir / "00_manifest/manifest.json", json.dumps(manifest, indent=2, ensure_ascii=False))

    readme = "\n".join(
        [
            "# Codex_MD",
            "",
            "- `03_rgl_api/by_function/`: function/constant signatures (overload-safe)",
            "- `03_rgl_api/by_module/`: signatures grouped by module",
            "- `03_rgl_api/by_type/`: types with meaning + producer/consumer signatures",
            "- `04_paradigms/`: paradigms sections + rgl-tutorial",
            "- `01_gf_language/`: gf-refman + gf-tutorial",
            "- `02_gf_shell/`: gf shell reference",
            "- `06_examples/`: English API examples",
            "- `00_manifest/manifest.json`: machine index",
            "",
        ]
    )
    write_text(out_dir / "README.md", readme)

    # ---- hard fail if popup tokens leaked
    leaked = []
    for p in out_dir.rglob("*.md"):
        if "#divpopup" in p.read_text(encoding="utf-8", errors="replace"):
            leaked.append(str(p))
            if len(leaked) >= 10:
                break
    if leaked:
        raise SystemExit("Popup tokens leaked into output (first hits):\n" + "\n".join(leaked))


# ---------------------------
# CLI
# ---------------------------

def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="Codex_MD", help="Output directory (default: Codex_MD)")
    ap.add_argument("--overwrite", action="store_true", help="Overwrite output dir if it exists")

    mode = ap.add_mutually_exclusive_group(required=True)
    mode.add_argument("--source", help="Path to SourceMaterial folder (filesystem mode)")
    mode.add_argument("--dump-index", help="Path to Index.txt for volume-dump format (dump mode)")

    args = ap.parse_args()
    out_dir = Path(args.out).resolve()

    if args.source:
        repo: Repo = FilesystemRepo(Path(args.source).resolve())
    else:
        repo = DumpRepo(Path(args.dump_index).resolve())

    build_codex(repo=repo, out_dir=out_dir, overwrite=args.overwrite)

    print(f"OK: wrote {out_dir}")
    print("Key files:")
    print(f"- {out_dir / '03_rgl_api' / 'Functions_Index.md'}")
    print(f"- {out_dir / '03_rgl_api' / 'by_type' / 'Types_Index.md'}")
    print(f"- {out_dir / '00_manifest' / 'manifest.json'}")


if __name__ == "__main__":
    main()