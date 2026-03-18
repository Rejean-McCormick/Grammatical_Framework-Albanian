# ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES

## 1. Purpose

This document defines **forbidden implementation patterns** and **anti-drift rules** for the Albanian GF concrete syntax.

Its job is to prevent future edits from:

- breaking Albanian category shapes,
- flattening structured categories into strings,
- copying model-language solutions blindly,
- drifting away from `Extend.gf`, `ExtendFunctor.gf`, and the Albanian core modules,
- reintroducing errors already observed in `ExtendSqi.gf` compile runs.

This file is normative for Albanian implementation work.

---

## 2. Source Precedence (highest to lowest)

When sources disagree, follow this order:

1. `abstract/Extend.gf` and other Albanian-relevant abstract signatures.
2. `common/ExtendFunctor.gf` default compositions and `variants {}` boundaries.
3. Albanian lincat and constructor reality in core Albanian modules (`CatSqi.gf`, `NounSqi.gf`, `AdjectiveSqi.gf`, `AdverbSqi.gf`, `ResSqi.gf`, `QuestionSqi.gf`, `ExtraSqi.gf`, `StructuralSqi*.gf`).
4. Compile diagnostics from Albanian runs.
5. Model languages:
   - Bulgarian first for minimal structured subsystems, especially `RNP`.
   - German second for richer subsystem architecture.
6. Local repair decisions already recorded in Albanian docs.

If a lower source conflicts with a higher one, the lower source must not drive implementation.

---

## 3. Non-Negotiable Albanian Category Facts

These are the baseline assumptions that must not be violated:

- `Prep = Compl`, and Albanian prepositions are surface-string-like (`s : Str`).
- `CN = Noun`, not `Str`.
- `NP = {s : Case => Str; a : Agr}`.
- `AP` is an inflecting record over `Species => Case => Gender => Number => Str`.
- Albanian noun records are not flat; `cn.s` is indexed as `spec -> case -> number`, and nouns also carry gender.
- Working Albanian `CN -> CN` patterns preserve the noun table and gender instead of flattening to one string.

Implication: every implementation must respect the real category shape before any surface concatenation is attempted.

---

## 4. Absolute Forbidden Patterns

### 4.1 Never implement by name alone

Do **not** choose an implementation because the function name looks familiar.

Always resolve a function by:

- exact abstract signature,
- return category,
- module context,
- Albanian lincat shape,
- whether `ExtendFunctor` provides a default composition or leaves `variants {}`.

**Forbidden:**

- “This looks like it should return a noun phrase.”
- “German does X for something with a similar name, so Albanian should too.”
- “This compiles as a string, so it must be correct.”

---

### 4.2 Never flatten structured categories to `Str` unless the target category really is `{s : Str}`

This is the central anti-drift rule.

Do **not** use helper projections like a single surface string to implement a target whose real type is `CN`, `AP`, `NP`, `RNP`, `Card`, or another structured category.

**Forbidden examples:**

- implementing `CN` with only one chosen noun form,
- implementing `AP` with one nominative singular masculine string unless the target is truly string-like,
- building `Card` by returning a `CN`,
- treating `RNP` as raw text when it inherits from `NP` or a structured subsystem.

If the target category has tables, agreement fields, or lock fields, preserve them.

---

### 4.3 Never hand-build reduced AP/CN records when full category shape is expected

Avoid ad-hoc records like these unless the full category is genuinely minimal in Albanian:

- `lin AP {s = ...}` with only one field,
- `lin CN {s = ... ; g = ...}` when the target environment expects the real Albanian CN shape,
- any implementation that suppresses lock fields by construction.

These patterns are especially dangerous in:

- `ICompAP`,
- `PredAPVP`,
- `FocusAP`,
- `AdjAsCN`,
- `AdjAsNP`,
- `AdvIsNPAP`,
- `N2VPSlash`,
- `CompBareCN`,
- `ExistCN`, `ExistMassCN`, `ExistPluralCN`,
- `CompoundAP`,
- `CardCNCard`.

If compiler output mentions `missing lock_AP` or `missing lock_CN`, treat that as evidence that a reduced record or flattened input/output shape was used incorrectly.

---

### 4.4 Never redesign one member of a subsystem in isolation

Certain constructor families are subsystem-level, not single-function-level.

This is especially true for:

- `RNP`, `RNPList`,
- `ReflPron`, `ReflPoss`, `PredetRNP`, `AdvRNP`, `AdvRVP`, `AdvRAP`, `ReflA2RNP`, `PossPronRNP`, `ConjRNP`, `Base_*_RNP`, `Cons_*_RNP`,
- existential constructors,
- AP/CN conversion constructors.

**Forbidden:**

- fixing only `ReflPoss` while leaving the rest of the `RNP` family on a different representation,
- changing one existential function to use clauses while the others still return flat strings,
- changing only one list constructor without updating its base/cons pair.

Subsystems must be coherent.

---

### 4.5 Never copy German field inventory into Albanian without proof

German is useful as a structural reference, but German records often contain fields that Albanian does not necessarily need.

**Forbidden:**

- copying German `RNP` fields into Albanian just because German uses them,
- copying German AP/CN architectures without checking Albanian lincats,
- using German as the first or only source when Bulgarian or Albanian local files give a simpler closer pattern.

Use German to understand **subsystem structure**, not to import unverified field layouts.

---

### 4.6 Never assume that a warning is harmless when it is a shape warning

The following warnings are not cosmetic and must be treated as design failures until eliminated:

- `missing lock_AP`,
- `missing lock_CN`,
- expected structured record but inferred `{s : Str}` or vice versa,
- “record type expected” around existential or complement functions,
- “table type expected” where a structured Albanian table was collapsed.

Shape warnings usually indicate that category structure has been lost.

---

### 4.7 Never invent abstract functions locally

If the compiler warns that a function is “not in abstract”, do not normalize that pattern into Albanian design practice.

Such local-only helpers may exist temporarily, but they must be treated as non-authoritative and clearly marked.

**Forbidden:**

- using non-abstract local names as if they were stable API,
- using them as model-language evidence,
- building new architecture around them.

---

## 5. Anti-Drift Rules for Inheritance vs Override

### 5.1 Prefer inherited composition when `ExtendFunctor` already provides one

If `ExtendFunctor` implements a function by composing existing grammar constructors, Albanian should inherit or mirror that composition unless Albanian-specific evidence proves otherwise.

Examples of the rule:

- if the functor uses `CompCN`, Albanian should not replace it with `cnStr` unless the target really is string-like;
- if the functor uses clause/question constructors for existentials, Albanian should not reduce them to raw `{s = ...}` strings;
- if the functor inherits `RNP = Grammar.NP` and `RNPList = Grammar.ListNP`, do not weaken that to `{s : Str}`.

### 5.2 Only override where the functor uses `variants {}` or Albanian forces a different strategy

Overrides are allowed when:

- `ExtendFunctor` leaves the function unimplemented (`variants {}`),
- Albanian category shape or word order requires a custom implementation,
- Albanian morphology requires category-specific realization that default composition cannot produce.

### 5.3 Mark every custom override by strategy class

Each override should be explicitly classified as one of:

- inherited unchanged,
- inherited composition mirrored locally,
- Albanian-specific surface override,
- Albanian-specific subsystem redesign,
- temporary approximation pending evidence.

Unclassified overrides are drift-prone.

---

## 6. Anti-Drift Rules for AP/CN/NP Work

### 6.1 AP rules

- Preserve full AP inflection shape unless the target category is genuinely string-like.
- Do not derive AP semantics from one nominative singular masculine form unless the abstract signature clearly allows a string result.
- If an AP is embedded into another constructor, prefer a constructor path such as `CompAP` or an Albanian AP-preserving operation.

### 6.2 CN rules

- Preserve the Albanian noun table and gender.
- Do not choose one noun form and use it to stand in for all cases/species/numbers.
- If converting from CN to another category, check whether the target expects a complement, an adverb, an NP, or another CN.

### 6.3 NP rules

- Preserve `s : Case => Str` and agreement `a`.
- If a subsystem inherits from `NP`, do not weaken it to raw strings.
- When building NP-like families (`RNP` in inherited mode), use `lin NP` / `lin ListNP`, not anonymous string records.

---

## 7. Anti-Drift Rules for Existential and Complement Constructions

### 7.1 Existentials must follow clause/question structure

Do not implement:

- `ExistS`,
- `ExistNPQS`,
- `ExistIPQS`

as raw string concatenation if the abstract/functor path builds them through clause or question constructors.

A string-only existential implementation is forbidden unless the target category is explicitly `{s : Str}` and the higher-order constructor shape has already been satisfied.

### 7.2 Complements must respect target category

For functions like:

- `CompBareCN`,
- `CompIQuant`,
- `PredAPVP`,
- `AdvIsNP`,
- `AdvIsNPAP`,

always verify whether the target is a complement, clause, VP-derived object, or another structured category before using surface strings.

---

## 8. Anti-Drift Rules for RNP and Reflexive Subsystems

### 8.1 Choose one Albanian `RNP` strategy and keep it consistent

Permitted strategies:

1. inherited `RNP = NP`, `RNPList = ListNP`, implemented coherently;
2. explicit Albanian custom `RNP` subsystem with a documented record shape.

Forbidden strategy:

- mixed implementation where some `RNP` functions assume NP/ListNP while others are raw strings or copied from a different record design.

### 8.2 Use Bulgarian before German for minimal `RNP` structure

Bulgarian is the preferred first model for `RNP` because it shows a compact structured subsystem. German is a secondary model for richer subsystem organization.

### 8.3 If any `RNP` member changes representation, audit the whole family

A change to one of these triggers a full-family review:

- `ReflPron`,
- `ReflPoss`,
- `PredetRNP`,
- `AdvRNP`,
- `AdvRVP`,
- `AdvRAP`,
- `ReflA2RNP`,
- `PossPronRNP`,
- `ConjRNP`,
- all `Base_*_RNP` and `Cons_*_RNP`.

---

## 9. Explicit Forbidden Coding Moves

Do not do any of the following without explicit evidence and documentation:

- pick a single Albanian noun form and call it a `CN` implementation,
- use `apStr`/`cnStr` to satisfy non-string targets,
- change only the body of a function without re-checking its abstract signature,
- copy German `PrepCN`, `RNP`, or AP/CN subsystem fields directly into Albanian,
- return a `CN` where the abstract says `Adv`,
- return a structured category where the abstract expects `{s : Str}` only,
- return a raw record where inherited `ListNP` or `NP` should be wrapped with `lin ListNP` / `lin NP`,
- trust a compile that still emits lock-field warnings,
- treat “best-effort” code as final if it still depends on guessed flattening.

---

## 10. Required Implementation Workflow

Every nontrivial Albanian change must follow this order:

1. Read the exact abstract signature.
2. Check whether `ExtendFunctor` provides a concrete composition or `variants {}`.
3. Confirm Albanian lincat shape in Albanian core files.
4. Check current Albanian usage examples in sibling modules.
5. Only then consult model languages, preferring Bulgarian before German when the subsystem matches.
6. Implement while preserving the target category shape.
7. Recompile.
8. Resolve shape warnings before declaring the work complete.
9. Record the decision in the decision log.

Skipping any of steps 1–5 is drift.

---

## 11. Finalization Standard

An Albanian implementation is **not final** if any of these remain:

- hard type errors,
- `missing lock_AP`,
- `missing lock_CN`,
- record/table mismatch warnings,
- subsystem inconsistency,
- undocumented use of model-language copying,
- undocumented approximation where `ExtendFunctor` uses `variants {}`.

“Compiles with warnings” is not an acceptable completion state for core Albanian syntax work.

---

## 12. Documentation Obligations

When a fragile function is implemented or changed, the accompanying documentation must record:

- abstract signature,
- target category,
- Albanian lincat assumptions used,
- whether the implementation comes from `ExtendFunctor`, Albanian local evidence, Bulgarian, German, or a temporary approximation,
- why rejected alternatives were rejected,
- compile result after the change.

If that evidence is absent, the change is undocumented drift.

---

## 13. Short Operational Checklist

Before accepting any Albanian patch, verify all of the following:

- exact signature checked,
- return category preserved,
- Albanian lincat shape preserved,
- no flattened surrogate used for structured categories,
- no lock warnings introduced,
- subsystem consistency maintained,
- model-language use justified,
- decision logged.

If any item fails, do not merge the patch.
