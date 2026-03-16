# START HERE — Instructions for AI

You are given a repository codedump split into multiple volume files.

## Goal
Answer questions by opening the minimum necessary content.

## Format notes
- Use `==== FILE_INDEX ====` first (lines starting with `ENTRY`).
- Then jump to `----- FILE BEGIN -----` with matching `path="..."`.
- For big files, prefer `--- CHUNK BEGIN ---` blocks.


## How to navigate this dump
1) Open `Doclib.txt` (single combined upload doc) and search for the path you need.
   (Optional) Use `Index.txt` to locate the relevant volume faster.
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
- src_20260316_160437_01_ROOT.txt  —  ROOT FILES
- src_20260316_160437_02_albanian.txt  —  FOLDER: albanian

## ChatGPT upload helper (single file)
- Upload doc: `Doclib.txt`

