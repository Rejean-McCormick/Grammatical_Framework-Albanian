# ALBANIAN_STALE_COMMENT_TRACKER

## Status
Authoritative maintenance tracker for stale, historically descriptive, misleading, or drift-prone comments in the Albanian GF codebase.

This document exists because comments can remain in the code long after:
- category shapes have changed,
- helper inventories have changed,
- constructor availability has changed,
- extension architecture has changed,
- or the compiler has already rejected the older pattern.

This tracker is part of the Albanian anti-drift documentation set.

It is not a generic code-style note.
It is a concrete maintenance control document.

---

## 1. Purpose

The purpose of this file is to prevent AI systems and maintainers from treating comments as implementation truth when those comments are older than the live codebase.

In the Albanian grammar, stale comments are especially dangerous because they can mislead work on:

- category shape,
- constructor legality,
- helper reuse,
- subsystem ownership,
- and extension-layer override behavior.

A comment can be useful historical context while still being wrong as present-tense implementation guidance.

This tracker therefore records:

1. confirmed stale comments,
2. comments that are historically descriptive but still acceptable if clearly treated as history,
3. comments that look suspicious and require audit,
4. comments that must **not** be “fixed away” because they still describe a live open issue.

---

## 2. Governing rule

Comments are secondary evidence only.

When comments, current source, and current compiler behavior disagree, current source plus compiler reality win.

This means:

- do **not** fix code to match a stale comment,
- do **not** use a comment as the sole evidence for a constructor pattern,
- do **not** treat a comment as stronger than the current codedump,
- do **not** treat comments as equal to typed source.

If a comment conflicts with live code, do one of the following:

- update the comment,
- mark it historical,
- or document the discrepancy explicitly.

---

## 3. Scope

Primary scope:
- `GF/lib/src/albanian/*.gf`

Especially relevant files:
- `CatSqi.gf`
- `ResSqi.gf`
- `ConjunctionSqi.gf`
- `StructuralSqiClause.gf`
- `StructuralSqi.gf`
- `StructuralSqiVerbal.gf`
- `ExtendSqiHelpers.gf`
- `ExtendSqiFocusPrep.gf`
- `ExtendSqi.gf`
- other structural, extension, and core producer modules as needed

This tracker covers comments that can mislead implementation, not ordinary prose comments that merely explain the code.

---

## 4. What counts as a stale comment

A comment is stale if one or more of the following is true:

1. it describes a category shape that is no longer current,
2. it claims a category is absent even though current code defines it,
3. it suggests a constructor path that current compiler/module context rejects,
4. it describes a helper inventory that no longer matches the current code,
5. it implies a fallback/default behavior that the current codebase has since replaced,
6. it describes subsystem ownership that no longer matches the current architecture.

A comment is **not** automatically stale merely because:
- it describes an open issue,
- it describes a currently disabled item,
- it warns about a known unresolved bug,
- or it records a still-current limitation.

The key question is:
**Does the comment still describe present implementation truth, or only an older state?**

---

## 5. Comment status labels

Use these statuses when recording comment state.

### 5.1 `confirmed_stale`
The comment contradicts current code, current category definitions, or current compile reality.

Required action:
- update or remove the comment,
- and update any documentation that still repeats it.

### 5.2 `historical_but_allowed`
The comment describes an older state but remains acceptable if explicitly marked historical and not used as present-tense evidence.

Required action:
- mark it historical if not already clear.

### 5.3 `suspicious_needs_audit`
The comment may be stale, but the conflict has not yet been fully verified.

Required action:
- inspect current source,
- inspect compile behavior if relevant,
- and then reclassify.

### 5.4 `current_and_valid`
The comment still correctly describes the live codebase or a currently open known issue.

Required action:
- leave it,
- but keep it under periodic review if it describes a bug or disabled item.

---

## 6. Tracker fields

Each tracker entry should record:

- `ID`
- `Status`
- `File`
- `Comment summary`
- `Why it is stale / historical / current`
- `Current truth`
- `Risk if trusted`
- `Required action`
- `Cross-doc updates needed`
- `Last checked`

This file is both a human tracker and an AI anti-drift boundary.

---

## 7. Confirmed stale comments

## STC-001

**Status:** `confirmed_stale`  
**File:** `GF/lib/src/albanian/ConjunctionSqi.gf`

**Comment summary:**  
The file contains an explanatory comment saying that `DAP` is not defined in `CatSqi` and that GF inserts a default `{s : Str}`-style behavior.

**Why it is stale:**  
Current Albanian category documentation and current codedump both treat `DAP` as explicitly present in the current Albanian snapshot.

**Current truth:**  
`DAP = {s : Str}` is already part of the current Albanian category reference and current documentation state.  
Therefore, the comment in `ConjunctionSqi.gf` reflects an older state, not the current one.

**Risk if trusted:**  
An AI or maintainer may:
- infer the wrong historical/current boundary,
- treat `DAP` as implicit/defaulted rather than explicitly documented,
- over-trust old local commentary,
- or reason incorrectly about constructor provenance and ownership.

**Required action:**  
Update the comment so it no longer says `DAP` is absent from `CatSqi`.
Preferred fixes:
1. replace with a current-tense comment that reflects the present codebase, or
2. mark the old note explicitly as historical if there is value in keeping the migration context.

**Cross-doc updates needed:**  
- none if the tracker remains current,
- but any local code comment update should remain consistent with:
  - category/lincat reference,
  - lexical/functional elements doc,
  - decision log,
  - syntax/construction rules.

**Last checked:**  
2026-03-25

---

## 8. Historical comments that are still allowed

At present, no additional Albanian comment has been promoted here as `historical_but_allowed` with repository-confirmed wording.

Policy:
- do **not** populate this section speculatively,
- only add entries when the exact comment has been verified and there is a reason to preserve it.

---

## 9. Comments that are current and must not be “cleaned up” as if stale

These items are included because they are easy to misclassify.

## STC-VER-001

**Status:** `current_and_valid`  
**File:** `GF/lib/src/albanian/StructuralSqi.gf`

**Comment summary:**  
`must_VV` remains disabled with an explicit note that the crash source is not yet isolated in the verbal helper chain.

**Why it is not stale:**  
This note still matches the current documented status of the item.
The decision log treats this as an open tracked issue rather than an accidental omission.

**Current truth:**  
The note reflects a real unresolved state and should stay until the verbal-side failure is repaired and validated.

**Risk if misclassified as stale:**  
A maintainer or AI may:
- remove the note,
- re-enable `must_VV` without evidence,
- or falsely normalize a still-open structural issue.

**Required action:**  
Do not remove the note without real repair evidence.
When the issue is fixed, update:
- the code comment,
- this tracker,
- the decision log,
- and the minimal test suite.

**Last checked:**  
2026-03-25

---

## 10. High-priority audit targets for additional stale comments

These are not confirmed stale comments yet.
They are the files where stale or historically descriptive comments would be most damaging.

### 10.1 `StructuralSqiClause.gf`
Why audit:
- constructor availability is currently sensitive,
- the recent `DConj` failure showed that simple-looking category assumptions are dangerous,
- any comment implying universal constructor availability is high risk.

### 10.2 `ExtendSqiFocusPrep.gf`
Why audit:
- helper-family confusion (`A` vs `AP`) is already a live failure class,
- comments that blur helper categories would be high-risk drift sources.

### 10.3 `ExtendSqiHelpers.gf`
Why audit:
- this file defines the live helper inventory,
- any old comment about helper intent, category coverage, or safe reuse can directly mislead AI-assisted edits.

### 10.4 `StructuralSqiVerbal.gf`
Why audit:
- verbal helper chains already include disabled/open-state behavior,
- comments here can easily drift from current bug status.

### 10.5 `StructuralSqi.gf`
Why audit:
- it is a public structural façade,
- comments here can be mistaken for global truth about exported readiness.

### 10.6 `ExtendSqi.gf`
Why audit:
- coordinator-policy comments are helpful,
- but if subsystem ownership or inherited-family policy changes, these comments become architecture drift risks.

### 10.7 `CatSqi.gf` and `ResSqi.gf`
Why audit:
- these are the baseline category truth sources,
- comments here can mislead entire families of downstream edits if they stop matching the current lincat/resource state.

---

## 11. Audit procedure for suspected stale comments

When you find a suspicious comment, do this in order:

1. Read the exact current source file containing the comment.
2. Identify the category/helper/constructor the comment is talking about.
3. Read the current category definition in `CatSqi.gf` and, if relevant, `ResSqi.gf`.
4. Read the current producer/owner module that actually implements the pattern.
5. Check whether current compile behavior supports or rejects the commented pattern.
6. Classify the comment:
   - `confirmed_stale`
   - `historical_but_allowed`
   - `suspicious_needs_audit`
   - `current_and_valid`
7. If stale, update:
   - the comment,
   - this tracker,
   - and any doc that currently repeats the stale statement.

Do **not** skip step 5 when constructor availability is involved.

---

## 12. What maintainers and AI systems must do

### 12.1 Do
- treat comments as context, not authority,
- cross-check comments against current source,
- cross-check constructor claims against current module context,
- update stale comments instead of silently reasoning around them,
- record confirmed stale comments here.

### 12.2 Do not
- treat a local comment as proof of current category shape,
- treat a local comment as proof that a helper is safe to reuse,
- treat a local comment as proof that a constructor is available,
- treat a local comment as stronger than the compiler,
- “fix” code so it matches an old explanatory comment.

---

## 13. Relationship to other Albanian documentation

This tracker is downstream of, and must remain consistent with:

- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`

Conflict rule:
- if the issue is **comment evidence**, this tracker and the decision log govern comment status;
- if the issue is **live category shape**, `CatSqi.gf` / `ResSqi.gf` and the category reference win;
- if the issue is **current constructor legality**, current source plus current compile reality win;
- if the issue is **subsystem architecture**, architecture/policy docs win.

---

## 14. Update obligations

Whenever a stale comment is confirmed, do all of the following:

1. update the comment in code if safe and appropriate,
2. add or update the tracker entry here,
3. update any doc that repeats the stale statement,
4. update the decision log if the stale comment exposed a new anti-drift lesson,
5. add a minimal regression test/doc note if the stale comment caused or could cause implementation drift.

A stale comment is not considered fully handled until the tracker and the dependent docs converge.

---

## 15. Current closure standard

This tracker is considered healthy when:

- all confirmed stale comments are listed,
- no tracked entry still lacks status/action,
- no known stale comment remains undocumented,
- comments that describe current open issues are clearly separated from stale comments,
- and AI systems can rely on this file to avoid using old comments as present-tense evidence.

As of the current Albanian documentation state:
- one confirmed stale comment is already known (`ConjunctionSqi.gf` / `DAP`),
- one current-but-valid warning comment is explicitly tracked (`must_VV` disabled note),
- and several high-risk modules remain prioritized for audit.

That is the correct current state of the tracker.