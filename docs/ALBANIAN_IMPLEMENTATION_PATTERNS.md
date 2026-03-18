# ALBANIAN_IMPLEMENTATION_PATTERNS

## Purpose

This document records implementation patterns for the Albanian GF concrete syntax so code changes stay aligned with the actual codedump, the inherited RGL design, and the observed compiler behavior. It is written for editing and debugging, not for end-user grammar documentation.

The main objective is to prevent drift:

- preserve concrete category shapes;
- prefer inherited constructor paths from `ExtendFunctor` when they exist;
- use Albanian core modules as the primary style guide;
- treat warning clusters such as `missing lock_AP` and `missing lock_CN` as structural signals, not cosmetic noise;
- treat families like `RNP` and existential constructors as subsystems, not isolated lines.

---

## Source-of-truth order

When implementing or repairing Albanian code, use this priority order.

1. **Abstract signatures** from `Extend.gf` and the GF API.
2. **Inherited default composition** from `ExtendFunctor.gf`.
3. **Actual Albanian category shapes and working idioms** from core Albanian modules:
   - `CatSqi.gf`
   - `ResSqi.gf`
   - `NounSqi.gf`
   - `AdjectiveSqi.gf`
   - `AdverbSqi.gf`
   - `SyntaxSqi.gf`
   - `ExtraSqi.gf`
4. **Model-language references** for subsystems that Albanian customizes heavily:
   - Bulgarian first for minimal structured subsystem design.
   - German second for richer subsystem design.
5. **Local repair decisions** recorded in the decision log.

If a function can be expressed by an inherited functor composition, prefer that over a new Albanian string-concatenation implementation.

---

## Global implementation principles

### 1. Category shape is primary

Do not design from surface strings first. Design from the target category’s real lincat shape first.

Examples from the Albanian dump and gfo artifacts:

- `CN` is noun-shaped, not flat.
- `AP` carries a full inflection table and a lock field.
- `NP` carries a case table plus agreement.
- `Prep` is string-like in Albanian.

This means:

- only return `{s : Str}` when the target lincat is actually string-like;
- never replace a full `CN` or `AP` with a flat surface string unless the target category expects a flat string;
- if a warning says `missing lock_AP` or `missing lock_CN`, assume the implementation is probably category-wrong.

### 2. Prefer composition over reconstruction

If `ExtendFunctor` already gives a constructor path, use that path. Do not hand-linearize unless Albanian truly needs a language-specific override.

Typical good pattern:

- build with `UseComp`, `CompAdv`, `CompAP`, `CompCN`, `MassNP`, `ExistNP`, `UseQCl`, `PredVP`, `AdvVP`, etc.

Typical risky pattern:

- flattening an `AP` or `CN` to a string and then rebuilding a different category by concatenation.

### 3. Preserve family coherence

Some constructors are independent. Others are not.

Treat these as families:

- `RNP` family
- existential family
- AP/CN conversion family
- preposition/adverb family

If one member of a family changes representation, inspect the whole family.

### 4. Albanian core modules are the style guide

When a pattern already exists in a core Albanian module, follow it.

Examples:

- `AdjCN` in `NounSqi.gf` shows how Albanian preserves `CN` table shape.
- `PrepNP` in `AdverbSqi.gf` shows the preposition + NP surface policy.
- `SyntaxSqi.gf` shows constructor-centered assembly (`mkCN`, `mkNP`, `mkAP`).
- `ExtraSqi.gf` shows how to project a `CN` into case tables such as `cnCaseIndef` and `cnCaseWithDet`.

---

## Albanian category-preserving patterns

### CN-preserving pattern

Use this whenever input and output are both noun-like.

Reference pattern:

```gf
AdjCN ap cn = {
  s = \\spec,c,n => cn.s ! spec ! c ! n ++ ap.s ! spec ! c ! cn.g ! n ;
  g = cn.g
}
```

Implications:

- preserve the full noun table;
- preserve gender;
- do not collapse `CN` to a single string if the result is still `CN`.

### NP-preserving pattern

Use `lin NP { s = \\c => ... ; a = ... }` when returning `NP`.

Reference pattern:

```gf
DetCN det cn = {
  s = \\c => det.s ! c ! cn.g ++ cn.s ! det.spec ! c ! det.n ;
  a = agrgP3 cn.g det.n
}
```

Implications:

- case projection belongs in the `s = \\c => ...` table;
- agreement must be preserved or recomputed;
- if you inherit `RNP = NP`, every `RNP` implementation must behave like a real `NP`.

### AP-preserving pattern

Use a full AP table when returning `AP`.

Reference pattern from Albanian adjective code:

- adjective phrases are realized over `Species => Case => Gender => Number => Str`.
- Albanian already defines `SentAP` and `AdvAP` in AP-preserving form.

Implications:

- avoid `apStr` if the target is still `AP`;
- avoid building APs with only `{s = ...}` unless you know every required field.

### String-like categories

Some Albanian categories really are string-like.

Examples:

- `Prep = Compl`, and Albanian `Compl` is surface-string-like.
- many local helper lincats in `ExtendSqi` were intentionally simplified to `{s : Str}`.

Implications:

- surface concatenation is acceptable only for categories whose lincat is truly string-like;
- do not generalize from `Prep` to `CN`, `AP`, or `NP`.

---

## Constructor-first patterns from inherited RGL design

These patterns should be preferred whenever signatures match.

### Complement patterns

Use inherited complement builders where available:

- `CompCN`
- `CompAP`
- `CompAdv`
- `CompIP`
- `UseComp`

These are safer than flattening AP/CN to strings and reconstructing a complement manually.

### Existential patterns

Build existential meanings via the existential constructors and question/clause constructors, not with raw string concatenation.

Preferred path shape:

- `ExistNP`
- `UseCl`
- `QuestCl`
- `UseQCl`
- `ExistIP`

Do **not** implement `ExistS`, `ExistNPQS`, or `ExistIPQS` as flat surface strings unless the target category is provably a flat sentence string.

### Preposition + nominal patterns

Preferred order:

1. use existing `PrepNP` if you already have an NP;
2. if abstract/functional design calls for `Prep + CN`, first convert the CN through an approved nominal path;
3. only override directly if Albanian requires a language-specific bare-noun behavior.

### Apposition and adverbial predicate patterns

Prefer ordinary grammar combinators such as:

- `PredVP`
- `AdvVP`
- `UseComp`

These keep the target category shape correct.

---

## Albanian-specific implementation patterns

### Bare noun extraction

When a true surface noun form is required from a `CN`, Albanian already has a pattern for projecting case-sensitive noun forms.

Approved sources:

- `cnCaseIndef`
- `cnCaseWithDet`
- `cnBare`

Use these rather than inventing ad-hoc `cn.s ! ...` projections in many places.

### Preposition policy

In `AdverbSqi.gf`, Albanian uses accusative after a preposition through `npAfterPrep` and `PrepNP`.

Implementation rule:

- if you need the object form after a prep and no stronger Albanian-specific rule exists, accusative is the default structural policy.

### Constructor layer policy

`SyntaxSqi.gf` is the lightweight assembly layer.

Use it as the preferred assembly style:

- `mkCN : N -> CN = UseN`
- `mkCN : AP -> CN -> CN = AdjCN`
- `mkNP : Det -> CN -> NP = DetCN`
- `mkNP : Pron -> NP = UsePron`
- `mkAP : A -> AP = PositA`

If a change can be written as constructor composition in this style, prefer that to a handwritten linearization.

---

## RNP-family patterns

### Policy

The `RNP` family must be treated as one coherent subsystem.

Functions include:

- `ReflRNP`
- `ReflPron`
- `ReflPoss`
- `PredetRNP`
- `AdvRNP`
- `AdvRVP`
- `AdvRAP`
- `ReflA2RNP`
- `PossPronRNP`
- `ConjRNP`
- `Base_*_RNP`
- `Cons_*_RNP`

### Current safest Albanian strategy

The safest strategy is to inherit `RNP = NP` and `RNPList = ListNP` from `ExtendFunctor`, then implement the family consistently on top of `NP/ListNP` rather than inventing a new local record.

Why this is the low-risk path:

- it matches inherited RGL design;
- it avoids premature commitment to a custom Albanian `RNP` record;
- it has already moved the failure frontier forward in the observed repair runs.

### When a custom `RNP` design becomes justified

Only introduce a custom Albanian `RNP` record if the inherited `NP/ListNP` strategy proves insufficient across the whole family.

If that happens:

- design the entire family together;
- use Bulgarian as the first minimal reference;
- use German as a richer secondary reference;
- record the chosen representation in the decision log.

### Anti-pattern

Do not mix:

- string-based `RNP` implementations,
- NP-shaped `RNP` implementations,
- and custom-record `RNP` implementations

within the same file without a deliberate subsystem design.

---

## AP/CN conversion patterns

These are the highest-risk drift points.

### `ICompAP`

This must return an interrogative complement-like value, not an `AP` and not a raw category-mismatched record.

Pattern rule:

- if an inherited composition exists, use it;
- otherwise derive from the AP’s predicative form only if the target category is demonstrably string-like.

### `AdjAsCN`

This is only safe if the result really is a noun-like category and preserves the required noun shape.

Pattern rule:

- if implemented manually, build a full `CN` table and preserve gender deliberately;
- do not return a flat string.

### `AdjAsNP`

Pattern rule:

- return a full `NP` with case table and agreement;
- if using AP surface material, project it through the NP target shape.

### `CompoundAP`

Pattern rule:

- if the output is `AP`, keep an AP table;
- do not use a `CN` helper and then assume the result is AP-safe.

### `CardCNCard`

Pattern rule:

- if the target category is card-like/string-like, return the target shape;
- never use a `CN` constructor as a shortcut unless the abstract signature truly returns `CN`.

The earlier `CardCNCard` failure is the canonical example of why category shape matters more than surface plausibility.

---

## Existential family patterns

Functions:

- `ExistS`
- `ExistNPQS`
- `ExistIPQS`
- `ExistCN`
- `ExistMassCN`
- `ExistPluralCN`
- `ExistsNP`

### Pattern rule

Build these through the inherited existential/clause/question machinery whenever available.

Approved structural path:

- `ExistNP`
- `ExistIP`
- `UseCl`
- `QuestCl`
- `UseQCl`
- `MassNP`
- `DetCN`
- `DetQuant`

### Anti-pattern

Do not implement existential constructors as direct `{s = ...}` concatenations unless the target category is confirmed to be plain sentence text.

Observed run data showed that flat existential implementations produced record-type mismatches.

---

## Lock-field policy

### Rule

Warnings like these are structural warnings:

- `missing lock_AP`
- `missing lock_CN`
- `missing lock_Prep`
- `missing lock_NP`

Treat them as evidence that a category is being rebuilt too weakly.

### Consequences

- a compile that still emits lock warnings is not final;
- any implementation pattern that repeatedly causes lock warnings should be rewritten using inherited constructors or fuller category-preserving records;
- if an Albanian helper like `apConst` or `cnConst` is used, it must be justified by the exact target lincat.

### Current hot spots

Observed warning clusters in current and recent runs show that the most fragile areas are:

- `ICompAP`
- `FocusAP`
- `AdvIsNPAP`
- `AdjAsCN`
- `AdjAsNP`
- `CompBareCN`
- `CompoundAP`
- `CardCNCard`
- some preposition-related functions using simplified `Prep`/`NP` handling

---

## Approved implementation workflow

For every nontrivial function:

1. Read the abstract signature.
2. Check whether `ExtendFunctor` already gives a constructor path.
3. Read the Albanian lincat shape in `CatSqi.gf` or the gfo artifacts.
4. Inspect the same category in Albanian core modules.
5. Only then inspect Bulgarian or German if the subsystem is genuinely custom.
6. Preserve the full target category shape.
7. Compile.
8. Resolve any lock-field warnings before considering the function stable.

---

## Known anti-drift rules

1. Do not implement from function name alone.
2. Do not flatten `AP` or `CN` to a string unless the target category is really flat.
3. Do not rebuild `CN` with only `s` and `g` when the surrounding subsystem expects lock-bearing category values.
4. Do not patch only one member of a structured family such as `RNP`.
5. Do not copy German field inventory into Albanian automatically.
6. Do not treat a compile success with lock warnings as finished.
7. Do not use model languages before checking Albanian core modules and `ExtendFunctor`.

---

## Model-language guidance for implementation patterns

### Bulgarian

Use Bulgarian first when you need a minimal structured model for a subsystem, especially `RNP`.

Why:

- it shows a compact structured subsystem design;
- it is closer to the “minimal custom record” end of the spectrum than German.

### German

Use German when you need a richer subsystem reference or when Bulgarian is too small to explain field interactions.

Why:

- it shows how a language with rich internal fields preserves category structure;
- it is useful as a stress test for subsystem coherence.

Do not copy German wholesale into Albanian.

---

## Current implementation priorities for Albanian repairs

Based on observed repair runs, the active priorities are:

1. eliminate category-shape mismatches in `ExtendSqi.gf`;
2. eliminate lock-field warnings in AP/CN and existential functions;
3. keep `RNP` on a coherent `NP/ListNP` strategy unless forced otherwise;
4. replace remaining flattening hacks with constructor-based implementations.

High-priority watchlist:

- `ICompAP`
- `N2VPSlash`
- `AdjAsCN`
- `AdjAsNP`
- `CompoundAP`
- `RNP` family
- any existential implementation not using constructor composition

---

## Minimal checklist before accepting an Albanian implementation

Accept a change only if all are true:

- abstract signature checked;
- inherited `ExtendFunctor` path checked;
- Albanian category shape checked;
- Albanian core module precedent checked;
- no accidental category flattening;
- compile passes;
- no new lock-field warnings;
- if subsystem-level, related functions inspected together.

---

## Source anchors for this document

Primary Albanian files:

- `albanian/CatSqi.gf`
- `albanian/ResSqi.gf`
- `albanian/NounSqi.gf`
- `albanian/AdjectiveSqi.gf`
- `albanian/AdverbSqi.gf`
- `albanian/SyntaxSqi.gf`
- `albanian/ExtraSqi.gf`
- `albanian/ExtendSqi.gf`

RGL / API references:

- `abstract/Extend.gf`
- `common/ExtendFunctor.gf`
- Codex router and per-function/per-type documentation

Model-language references:

- Bulgarian concrete files
- German `ExtendGer.gf` and related category files

Validation references:

- gf-audit run logs for Albanian compile/warning behavior

