# START HERE — Instructions for AI

You are given a repository codedump split into multiple volume files.

## Goal
Answer questions by opening the minimum necessary content.

## Format notes
- Use `==== FILE_INDEX ====` first (lines starting with `ENTRY`).
- Then jump to `----- FILE BEGIN -----` with matching `path="..."`.
- For big files, prefer `--- CHUNK BEGIN ---` blocks.


## How to navigate this dump
1) Open `Index.txt` (master index) and use it to locate the right volume.
2) Pick the relevant volume file.
3) Use the per-volume index section to locate the path.
4) Read the exact file content (or required chunks only).
5) Expand cautiously (imports / calls / routes), 1–2 hops unless needed.

## Rules
- Do NOT try to read the entire dump.
- Prefer docs/diagrams/indices if present.
- When answering, cite file paths and the volume filename.

## Files
- Instructions (this): `00_START_HERE.instructions.md`
- Master index: `Index.txt`
- Volumes:
- Codex_MD_20260225_141239_01_ROOT.txt  —  ROOT FILES
- Codex_MD_20260225_141239_02_00_manifest.txt  —  FOLDER: 00_manifest
- Codex_MD_20260225_141239_03_04_paradigms.txt  —  FOLDER: 04_paradigms
- Codex_MD_20260225_141239_04_01_gf_language.txt  —  FOLDER: 01_gf_language
- Codex_MD_20260225_141239_05_03_rgl_api.txt  —  FOLDER: 03_rgl_api
- Codex_MD_20260225_141239_06_06_examples.txt  —  FOLDER: 06_examples
- Codex_MD_20260225_141239_07_02_gf_shell.txt  —  FOLDER: 02_gf_shell

