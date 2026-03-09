# START HERE — GF AI Codex (Feb 2026)

This package is a shareable snapshot intended to make it easier for **AI systems (LLMs)** to generate correct **GF / RGL** code.

It is not new GF content. It is mostly a **repackaging / indexing** of existing GF/RGL documentation plus optional archives.

## Top-level folders

### 1) GF_Codex_MD_Dump/
This is the **AI-facing codex**: an AI-friendly Markdown reference built from GF manuals + RGL docs.

What it contains (as a volume dump):
- Markdown pages for RGL constructors/constants with **overload-safe** signatures (one overload per file)
- Type pages listing **Producers / Consumers** (which constructors return or take a given type)
- Module indexes
- English examples
- GF language reference + tutorial + shell reference (not split; kept as large Markdown files)
- A small router file (`00_ROUTER.md`) that tells an AI where to look first

Files in this folder:
- `Index.txt` — maps each original path to the volume `.txt` that contains it
- `Codex_MD_20260225_141239_*.txt` — the actual stored content (grouped into volumes)

Note: this folder is stored as a **volume dump** (not a normal directory tree) to make sharing easy.  
If you want a normal `Codex_MD/` tree, reconstruct it using `Index.txt` + the volume files.

Intended use:
- Feed the reconstructed Markdown codex (or a retrieval index built from it) to an LLM so it can select the correct RGL constructors and overloads instead of guessing.

### 2) GF_RGL_Source_Dump/
This is a snapshot of **RGL source code** (also stored as a volume dump).

It is included so tooling (or humans) can:
- inspect implementation details,
- trace where a constructor comes from,
- cross-check behavior beyond the signatures.

Files in this folder:
- `Index.txt` — maps each source path to the volume `.txt`
- `RGL_Source_Code_20260225_140951_*.txt` — the stored source content (grouped by language / category)

This source dump is **optional** for using the codex, but useful for deeper verification.

### 3) GF_Lexicons_Archive/
This is an archive of many GF lexicon modules (`*.gf`).

This is **not required** for the AI codex itself.
It is included only as a reference archive (large), since full lexicons can be token-heavy for LLM contexts.

## What this package is meant to do
- Provide an “instruction book” for AI:
  - deterministic lookup paths (router + indexes),
  - correct constructor signatures,
  - overload resolution by type,
  - minimal token waste (removed large translation popup lists, etc.).

## Recommended starting point (after reconstruction)
- `Codex_MD/00_ROUTER.md` (entrypoint for navigation)
- `Codex_MD/03_rgl_api/Functions_Index.md`
- `Codex_MD/03_rgl_api/by_type/Types_Index.md`
- `Codex_MD/06_examples/api-examples-Eng.md`