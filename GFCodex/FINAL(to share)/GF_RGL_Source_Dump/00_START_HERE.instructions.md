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
- RGL_Source_Code_20260225_140951_01_ROOT.txt  —  ROOT FILES
- RGL_Source_Code_20260225_140951_02_albanian.txt  —  FOLDER: albanian
- RGL_Source_Code_20260225_140951_03_ukrainian.txt  —  FOLDER: ukrainian
- RGL_Source_Code_20260225_140951_04_kazakh.txt  —  FOLDER: kazakh
- RGL_Source_Code_20260225_140951_05_belarusian.txt  —  FOLDER: belarusian
- RGL_Source_Code_20260225_140951_06_polish.txt  —  FOLDER: polish
- RGL_Source_Code_20260225_140951_07_macedonian.txt  —  FOLDER: macedonian
- RGL_Source_Code_20260225_140951_08_korean.txt  —  FOLDER: korean
- RGL_Source_Code_20260225_140951_09_gaelic.txt  —  FOLDER: gaelic
- RGL_Source_Code_20260225_140951_10_faroese.txt  —  FOLDER: faroese
- RGL_Source_Code_20260225_140951_11_russian.txt  —  FOLDER: russian
- RGL_Source_Code_20260225_140951_12_spanish.txt  —  FOLDER: spanish
- RGL_Source_Code_20260225_140951_13_catalan.txt  —  FOLDER: catalan
- RGL_Source_Code_20260225_140951_14_portuguese.txt  —  FOLDER: portuguese
- RGL_Source_Code_20260225_140951_15_italian.txt  —  FOLDER: italian
- RGL_Source_Code_20260225_140951_16_ancient_greek.txt  —  FOLDER: ancient_greek
- RGL_Source_Code_20260225_140951_17_armenian.txt  —  FOLDER: armenian
- RGL_Source_Code_20260225_140951_18_rukiga.txt  —  FOLDER: rukiga
- RGL_Source_Code_20260225_140951_19_greek.txt  —  FOLDER: greek
- RGL_Source_Code_20260225_140951_20_zulu.txt  —  FOLDER: zulu
- RGL_Source_Code_20260225_140951_21_bulgarian.txt  —  FOLDER: bulgarian
- RGL_Source_Code_20260225_140951_22_amharic.txt  —  FOLDER: amharic
- RGL_Source_Code_20260225_140951_23_finnish.txt  —  FOLDER: finnish
- RGL_Source_Code_20260225_140951_24_romanian.txt  —  FOLDER: romanian
- RGL_Source_Code_20260225_140951_25_german.txt  —  FOLDER: german
- RGL_Source_Code_20260225_140951_26_maltese.txt  —  FOLDER: maltese
- RGL_Source_Code_20260225_140951_27_estonian.txt  —  FOLDER: estonian
- RGL_Source_Code_20260225_140951_28_arabic.txt  —  FOLDER: arabic
- RGL_Source_Code_20260225_140951_29_japanese.txt  —  FOLDER: japanese
- RGL_Source_Code_20260225_140951_30_mongolian.txt  —  FOLDER: mongolian
- RGL_Source_Code_20260225_140951_31_icelandic.txt  —  FOLDER: icelandic
- RGL_Source_Code_20260225_140951_32_api.txt  —  FOLDER: api
- RGL_Source_Code_20260225_140951_33_lithuanian.txt  —  FOLDER: lithuanian
- RGL_Source_Code_20260225_140951_34_latin.txt  —  FOLDER: latin
- RGL_Source_Code_20260225_140951_35_english.txt  —  FOLDER: english
- RGL_Source_Code_20260225_140951_36_somali.txt  —  FOLDER: somali
- RGL_Source_Code_20260225_140951_37_french.txt  —  FOLDER: french
- RGL_Source_Code_20260225_140951_38_hungarian.txt  —  FOLDER: hungarian
- RGL_Source_Code_20260225_140951_39_latvian.txt  —  FOLDER: latvian
- RGL_Source_Code_20260225_140951_40_dutch.txt  —  FOLDER: dutch
- RGL_Source_Code_20260225_140951_41_nepali.txt  —  FOLDER: nepali
- RGL_Source_Code_20260225_140951_42_basque.txt  —  FOLDER: basque
- RGL_Source_Code_20260225_140951_43_swedish.txt  —  FOLDER: swedish
- RGL_Source_Code_20260225_140951_44_slovenian.txt  —  FOLDER: slovenian
- RGL_Source_Code_20260225_140951_45_urdu.txt  —  FOLDER: urdu
- RGL_Source_Code_20260225_140951_46_turkish.txt  —  FOLDER: turkish
- RGL_Source_Code_20260225_140951_47_malay.txt  —  FOLDER: malay
- RGL_Source_Code_20260225_140951_99_OTHERS.txt  —  OTHERS (Misc Folders)

