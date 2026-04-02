# ALBANIAN_IMPLEMENTATION_PATTERNS

## Purpose

This document records implementation patterns for the Albanian GF concrete syntax so code changes stay aligned with:

- the actual Albanian codedump,
- the inherited RGL design,
- the current compiler and audit behavior,
- the current anti-drift rule set,
- and the current Albanian documentation bundle.

It is written for editing, debugging, review, and AI-assisted maintenance.  
It is **not** end-user grammar documentation.  
It is **not** a redesign proposal.

The main objective is to prevent drift:

- preserve concrete category shapes;
- prefer inherited constructor paths from `ExtendFunctor` when they exist;
- use Albanian core modules as the primary style guide;
- treat warning clusters such as `missing lock_AP`, `missing lock_CN`, `missing lock_NP`, and `missing lock_Prep` as structural signals, not cosmetic noise;
- treat families like `RNP`, existential constructors, AP/CN conversion, and focus/preposition logic as subsystems, not isolated lines;
- distinguish category-shape knowledge from constructor availability in a specific module context;
- require exact helper/category compatibility before reusing a helper;
- separate stable patterns from temporary compatibility wrappers;
- make current implementation truth explicit enough that an AI cannot infer by similarity;
- prevent comments, older notes, or cross-module pattern copying from silently overriding current code and current compiler reality.

This document is one of the main implementation-control files in the Albanian documentation set.

---

## Companion control documents

This file must be read together with:

- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`

This document does not try to replace those files.  
Its job is to answer the practical question:

> **What kinds of implementation patterns are currently allowed, preferred, fragile, blocked, or forbidden in the Albanian codebase?**

---

## Source-of-truth order

When implementing or repairing Albanian code, use this priority order.

1. **The current file and current compiler behavior for that exact file**
   - current codedump for the module being edited;
   - current audit stderr/stdout if the module fails;
   - current nearby Albanian working pattern in the same module family.

2. **Abstract signatures** from `Extend.gf` and the GF API.

3. **Inherited default composition** from `ExtendFunctor.gf`.

4. **Actual Albanian category shapes and working idioms** from core Albanian modules:
   - `CatSqi.gf`
   - `ResSqi.gf`
   - `NounSqi.gf`
   - `AdjectiveSqi.gf`
   - `AdverbSqi.gf`
   - `SentenceSqi.gf`
   - `SyntaxSqi.gf`
   - `ConjunctionSqi.gf`
   - `ExtraSqi.gf`

5. **Current operational control docs**
   - helper registry,
   - shallow-category constructor matrix,
   - symbol status ledger,
   - stale-comment tracker,
   - current category/lincat reference,
   - current syntax/construction rules,
   - current override policy,
   - current decision log.

6. **Model-language references** for subsystems that Albanian customizes heavily:
   - Bulgarian first for minimal structured subsystem design.
   - German second for richer subsystem design.

7. **Local repair decisions** recorded in the decision log.

If a function can be expressed by an inherited functor composition, prefer that over a new Albanian string-concatenation implementation.

If a documentation statement conflicts with the current codedump or compiler reality, treat the documentation as requiring refinement rather than forcing the code to match an inferred pattern.

If a comment conflicts with current code or current compiler output, treat the comment as stale until verified.

---

## Global implementation principles

### 1. Category shape is primary

Do not design from surface strings first.  
Design from the target category’s real lincat shape first.

Examples from the Albanian dump and gfo artifacts:

- `CN` is noun-shaped, not flat.
- `AP` carries a full inflection table and a lock-bearing shape.
- `NP` carries a case table plus agreement.
- `Pron` has case plus clitic-specific fields.
- `ListNP`, `ListCN`, and `ListAP` are real structured list categories.
- `Prep` is often surface-like in Albanian, but still must be checked against the current constructor path and module context.

This means:

- only return `{s : Str}` when the target lincat is actually string-like in the current codebase and current module context;
- never replace a full `CN`, `AP`, `NP`, `Pron`, or list category with a flat surface string unless the target category expects a flat string;
- if a warning says `missing lock_AP`, `missing lock_CN`, `missing lock_NP`, or `missing lock_Prep`, assume the implementation is probably category-wrong or constructor-weak until proved otherwise.

### 2. Category shape does not automatically license a constructor

Knowing that a category is “surface-like” is not enough.

You must still verify that the intended constructor pattern is available and valid in the current module context.

In particular:

- a documented lincat shape does **not** automatically imply that `lin Cat { ... }` is valid in every module;
- a category that looks like `{s : Str}` in documentation may still fail if the category constant or constructor path is not available where you are writing the code;
- local resource definitions must follow what the current module can actually see and rename;
- a constructor pattern seen in one module is not automatically valid in another module with different `open`, `with`, inheritance, or alias context.

This rule exists because category documentation and current compile context answer different questions:

- documentation tells you what shape a category tends to have;
- the current module and compiler tell you whether a specific constructor pattern is legal there.

### 3. Prefer composition over reconstruction

If `ExtendFunctor` already gives a constructor path, use that path.  
Do not hand-linearize unless Albanian truly needs a language-specific override.

Typical good pattern:

- build with `UseComp`, `CompAdv`, `CompAP`, `CompCN`, `MassNP`, `ExistNP`, `UseQCl`, `PredVP`, `AdvVP`, `PrepNP`, etc.

Typical risky pattern:

- flattening an `AP` or `CN` to a string and then rebuilding a different category by concatenation.

### 4. Preserve family coherence

Some constructors are independent. Others are not.

Treat these as families:

- `RNP` family
- existential family
- AP/CN conversion family
- preposition/adverb/focus family
- structural closed-class functional-element family
- VP/VPSlash bridge family
- extension helper/compatibility family

If one member of a family changes representation, inspect the whole family.

### 5. Helper reuse requires exact category compatibility

A helper is reusable only when its input and output categories match the current implementation need exactly.

Do **not** reuse a helper merely because the surface behavior looks similar.

Examples:

- an `A -> Str` helper is **not** automatically valid for `AP -> Str`;
- an `AP -> Str` helper is **not** automatically valid for `A`;
- a `CN` helper is not automatically safe for a card-like or AP-like return type;
- a helper that reads one cell from a rich table is lossy and must not be reused for rich-category output construction.

Shallow output permission does not override this rule. A function returning `Utt` may allow surface extraction, but the extractor still has to accept the actual input category.

### 6. Albanian core modules are the style guide

When a pattern already exists in a core Albanian module, follow it.

Examples:

- `AdjCN` in `NounSqi.gf` shows how Albanian preserves `CN` table shape.
- `PrepNP` in `AdverbSqi.gf` shows the preposition + NP surface policy.
- `SyntaxSqi.gf` shows constructor-centered assembly (`mkCN`, `mkNP`, `mkAP`).
- `ExtraSqi.gf` shows how to project a `CN` into case tables such as `cnCaseIndef` and `cnCaseWithDet`.
- `VerbSqi.gf` shows where reductions to predicate-like or complement-like surface forms are expected and where they are not.

### 7. Current code and compiler beat stale comments

Comments are useful, but they are not final evidence.

Implementation rule:

- if comment, current code, and compile output disagree, trust:
  1. current compiler output,
  2. current code,
  3. then comment text.

A comment may describe an earlier state of the grammar and must not be allowed to overrule current implementation truth.

The stale-comment tracker should be treated as a live maintenance source when comments are suspected to be outdated.

---

## Helper taxonomy and usage policy

This section defines the helper classes that must be distinguished explicitly during Albanian implementation work.

### 1. Neutral utilities

Definition:
- helpers that do not fabricate or weaken grammatical category structure;
- separators, shared booleans, small string combinators, or non-category-specific utility logic.

Examples:
- whitespace/string separators such as `wordSep`;
- pure formatting combinators that do not stand in for grammar constructors.

Policy:
- safe to reuse broadly;
- must still not be confused with category constructors.

### 2. Category-preserving builders

Definition:
- helpers that build or preserve the full target category shape.

Examples:
- helpers that return full `NP`, `AP`, or `CN` records with the fields Albanian actually needs;
- constructor wrappers that preserve agreement tables, case tables, and lock-bearing structure.

Policy:
- preferred helper class for nontrivial outputs;
- safe only when the helper type matches the target category exactly.

### 3. Lossy surface extractors

Definition:
- helpers that extract one visible surface form from a richer category.

Examples:
- `A -> Str` surface helpers;
- `AP -> Str` surface helpers;
- one-cell projections from a noun or adjective table.

Policy:
- allowed only when the **target output is shallow**;
- forbidden as a substitute for rebuilding a rich category;
- must be named and documented as lossy.

### 4. Compatibility wrappers

Definition:
- helpers that build a category in a reduced/compatibility style for a tightly controlled use case.

Examples:
- wrappers like `mkCompatNPFromStr`, `mkCompatAPFromStr`, `mkCompatCNFromStr` when they are used as temporary or lexical-surface compatibility devices.

Policy:
- allowed only when explicitly justified;
- must not silently become the default pattern for rich-category construction;
- must be marked with status:
  - `stable`
  - `warning`
  - `temporary`
  - `fallback`

### 5. Family-local helpers

Definition:
- helpers valid only inside a specific subsystem family.

Examples:
- reflexive/RNP family helpers;
- existential-family local constructor chains;
- structural closed-class local helper shims;
- focus/preposition local surface adapters.

Policy:
- do not export their logic mentally into unrelated families;
- document the exact family they belong to.

### 6. Blocked helpers

Definition:
- helpers or local constructor shims that are documented because they exist or recently existed, but are **not approved** as reusable patterns.

Examples:
- helpers or constructor shims that fail in current module context;
- helpers known to encourage wrong cross-category reuse;
- local record builders that conflict with current constructor-availability rules.

Policy:
- keep them documented;
- do not recommend them;
- treat them as warnings, not patterns.

---

## Helper inventory requirements

Any helper used in Albanian repair work should be documentable in this schema.

Required fields:

- `helper_name`
- `defined_in`
- `exact_type`
- `class`
  - neutral
  - category-preserving
  - lossy
  - compatibility
  - family-local
  - blocked
- `allowed_for`
- `forbidden_for`
- `status`
  - stable
  - warning
  - temporary
  - fallback
  - blocked
- `notes`

Minimum examples that must remain explicitly distinguished in current Albanian work:

- `adjSurfaceNomMascSg : A -> Str`
- `apSurfaceNomMascSg : AP -> Str`
- `mkCompatNPFromStr`
- `mkCompatAPFromStr`
- `mkCompatCNFromStr`

These examples exist to block one of the most common AI drift behaviors: reusing a helper based on similar surface intent rather than exact category compatibility.

The helper registry is the authoritative inventory.  
This implementation-patterns file tells you **how** to interpret and use that registry.

---

## Pattern classes

This section defines the main implementation pattern classes currently recognized in Albanian work.

### 1. Inherited-composition pattern

Definition:
- use `ExtendFunctor` or a core grammar composition chain directly.

Examples:
- `CompBareCN` through `CompCN`
- `PrepCN` through `PrepNP prep (MassNP cn)`
- existential families through `ExistNP` / `ExistIP`
- adverbial predicates through `PredVP` + `UseComp`

Policy:
- preferred whenever it exists and preserves the right category.

### 2. Core-producer pattern

Definition:
- use the Albanian module that naturally produces the target category.

Examples:
- `NounSqi.gf` for `CN`, `NP`, nominal composition;
- `AdjectiveSqi.gf` for `AP`;
- `AdverbSqi.gf` for prep-based adverbials;
- `VerbSqi.gf` for `Comp`-level reduction and predicate-like verbal composition.

Policy:
- preferred over ad hoc local rebuilding.

### 3. Category-preserving local override

Definition:
- local Albanian override that still returns the full target category shape.

Examples:
- `CN -> CN` using full noun table and gender;
- `AP -> AP` using full agreement table;
- `NP -> NP` using case and agreement.

Policy:
- acceptable when inheritance is inadequate;
- must preserve the same structural dimensions as the current Albanian lincat.

### 4. Shallow-output extraction pattern

Definition:
- reduce a rich input category to a surface string because the target category is truly shallow.

Examples:
- `Comp`-level surface assembly;
- some `Utt`-level outputs;
- some sentence/question outputs that are already `{s : Str}`.

Policy:
- acceptable only if:
  - the target output is shallow,
  - the extractor type matches exactly,
  - no richer target category is being silently faked.

### 5. Compatibility-wrapper pattern

Definition:
- use a reduced builder because the final richer path is not yet available or the use case is intentionally compatibility-shaped.

Examples:
- lexical/DAP-facing wrappers;
- temporary bridge code inside an actively repaired subsystem.

Policy:
- acceptable only with explicit status labeling;
- not final unless the surrounding docs and symbol ledger say so.

### 6. Module-context-verified local constructor pattern

Definition:
- use local `lin Cat { ... }` or a similar local resource pattern only after verifying that:
  - the category is actually available in the module,
  - the fields match current Albanian shape,
  - the compiler accepts it there,
  - the pattern is not contradicted by the shallow-category constructor matrix.

Policy:
- allowed only after explicit verification;
- never assume from shape alone.

---

## Rich-category implementation patterns

## 1. `CN`-preserving patterns

Approved pattern:
- preserve `Species`, `Case`, `Number`, and `Gender`.

Good indicators:
- follow `NounSqi.gf`;
- keep `g`;
- keep `s : Species => Case => Number => Str`.

Anti-pattern:
- extract one noun surface string and rebuild a fake noun.

Use when:
- function returns `CN` or a noun-bearing category.

Do not:
- reduce a `CN` to `{s : Str}` for convenience;
- replace noun structure with a lexical placeholder unless the target truly is lexicalized/shallow and the simplification is documented.

## 2. `AP`-preserving patterns

Approved pattern:
- preserve `Species`, `Case`, `Gender`, and `Number`.

Good indicators:
- follow `AdjectiveSqi.gf`;
- preserve the full AP table.

Anti-pattern:
- extract one nominative masculine singular form and pretend it is still a full AP.

Use when:
- function returns `AP`.

Do not:
- reuse an `A -> Str` helper on an `AP`;
- flatten `AP` unless the target output is shallow and the helper type matches.

## 3. `NP`-preserving patterns

Approved pattern:
- preserve `s : Case => Str` and `a : Agr`.

Good indicators:
- use case-aware `NP` constructors;
- recompute or preserve agreement.

Anti-pattern:
- return a single string where `NP` is required;
- treat pronoun-only fields as if they were generic NP structure.

Use when:
- function returns `NP` or an `NP`-compatible extension family.

## 4. Pronoun patterns

Approved pattern:
- preserve pronoun-specific clitic fields where the category is really `Pron`.

Policy:
- do not silently downgrade `Pron` into generic `NP` reasoning;
- do not upgrade a generic NP helper into a pronoun helper.

## 5. List-category patterns

Approved pattern:
- use the actual list shape from `ConjunctionSqi.gf`.

Examples:
- `ListNP`
- `ListCN`
- `ListAP`

Policy:
- preserve agreement and table shape for rich list categories;
- do not collapse them to plain strings just because the final coordinated output will be surface-oriented later.

---

## Shallow-category implementation patterns

This section complements the shallow-category constructor matrix.

## 1. True shallow outputs

Typical current shallow categories:
- `Comp`
- many `S` / `QS` / `RS` / `Cl` / `QCl` / `RCl` / `SSlash` / `ClSlash`
- `Card`
- `Ord`
- `Predet`
- many structural discourse items
- many utterance-level outputs

Approved pattern:
- use direct surface composition **only** if:
  - the target category is really shallow in the current Albanian codebase,
  - the constructor path is verified in the current module context,
  - the extractor/helper type matches the input category exactly.

## 2. Shallow does not mean locally safe

Even if the target category is shallow:
- check the constructor matrix,
- check the symbol ledger,
- check the stale-comment tracker,
- check the current module scope.

Canonical failure class:
- `DConj` looked surface-like, but that did not make `lin DConj { ... }` valid in the actual resource context.

## 3. Structural shallow categories

For categories like:
- `Subj`
- `Conj`
- `PConj`
- `Voc`
- `Utt`
- `CAdv`
- `DConj`
- `Prep`

approved pattern depends on current producer ownership:

- paradigm-owned,
- `ResSqi`-owned,
- producer-owned,
- locally verified,
- warning-state,
- or blocked.

This is why these categories must be checked against the shallow-category constructor matrix instead of guessed from documentation alone.

---

## Module-family patterns

## 1. AP/CN conversion family

Functions like:
- `ICompAP`
- `AdjAsCN`
- `AdjAsNP`
- `CompBareCN`
- `PredAPVP`
- `CardCNCard`

Policy:
- start from abstract signature;
- then check inherited `ExtendFunctor` path;
- then check Albanian core constructor path;
- only then consider local override.

Common failure mode:
- reusing one lossy helper or one shallow surface form as if it were enough to reconstruct a rich category.

Approved strategy:
- preserve output category shape exactly;
- use local override only when the target category cannot be reached compositionally.

## 2. Existential family

Functions:
- `ExistS`
- `ExistNPQS`
- `ExistIPQS`
- `ExistCN`
- `ExistMassCN`
- `ExistPluralCN`
- `ExistsNP`

Approved pattern:
- use inherited existential/clause/question machinery whenever possible.

Good path:
- `ExistNP`
- `ExistIP`
- `UseCl`
- `UseQCl`
- `QuestCl`
- `MassNP`
- `DetCN`
- `DetQuant`

Anti-pattern:
- direct flat `{s = ...}` existential reconstruction when the function is structurally clause/question-based.

## 3. `RNP` family

Functions:
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

Approved default strategy:
- stay coherent with inherited `NP / ListNP` strategy unless Albanian proves it needs a different full family representation.

Pattern consequences:
- if `RNP` is effectively `NP`, then all family members must remain NP/ListNP-compatible;
- do not mix strings, fake lists, and real list categories inside one family.

## 4. Focus / preposition family

Functions like:
- `FocusObj`
- `FocusAdv`
- `FocusAdV`
- `FocusAP`
- `PrepCN`

Approved pattern:
- keep the subsystem small and coherent;
- use Albanian preposition behavior from `AdverbSqi.gf`;
- allow surface extraction only because targets like `Utt` are shallow, but still enforce exact helper typing.

Canonical failure:
- `fp_FocusAP`-type mismatch where an `AP` input reuses an `A` helper.

## 5. VP / VPSlash bridge family

Approved pattern:
- keep bridge ownership in the VP bridge subsystem;
- use shallow verbal categories as shallow where current Albanian actually treats them that way;
- do not let bridge logic become a second source of unsupported VPS/VPI family overrides.

## 6. Structural closed-class family

Includes:
- prepositions,
- conjunctions,
- discourse connectors,
- vocatives,
- shallow utterance items,
- comparative adverbials,
- `DConj`-like items.

Approved pattern:
- use the owning producer/paradigm if one exists;
- use local construction only when the constructor path is verified in the actual module;
- check shallow-category constructor matrix and stale-comment tracker before assuming local surface fabrication is acceptable.

---

## Module-context rule

Every implementation decision must answer two separate questions:

1. **What is the target category shape?**
2. **What constructor path is actually available in this module?**

Both answers are required.

A pattern is not validated until both are true.

Checklist:

- is the category rich or shallow?
- is the relevant constructor/category constant visible in this module?
- is the helper imported from a module that actually exports the needed shape?
- does a nearby working Albanian module already do this exact thing?
- does the compiler accept the category and constructor names in this context?
- is the symbol being resolved after inheritance, `open`, aliasing, and exclusion are all accounted for?
- does the shallow-category constructor matrix classify this as verified, warning-state, or blocked?
- does the symbol status ledger mark the relevant pattern as provisional or unstable?

---

## Lessons from current failure anchors

### `fp_FocusAP`

What failed:
- an `AP`-taking function reused a helper that expected `A`.

Lesson:
- helper reuse requires exact category match;
- shallow output permission does not license the wrong input helper;
- use an AP-specific extractor or a verified constructor path.

Permanent rule:
- `A -> Str` and `AP -> Str` helpers must be documented and treated as separate tools.

### `StructuralSqiClause` `DConj`

What failed:
- `DConj` was treated as directly constructible through `lin DConj {s = ...}` in a module context where the compiler could not resolve `DConj`.

Lesson:
- surface-shape documentation is not enough;
- direct `lin Cat { ... }` must be validated in the module where it is written;
- restore or copy the nearest previously working Albanian pattern if constructor availability is uncertain.

Permanent rule:
- a documented shallow shape is never enough to certify a constructor pattern.

### Comment drift

What failed:
- explanatory comments described an older local state and could mislead implementation choice.

Lesson:
- comments must be checked against current codedump and compiler truth;
- stale comments are documentation bugs, not implementation evidence.

Permanent rule:
- do not infer constructor or category policy from comments alone.

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
- if an Albanian helper like `apConst` or `cnConst` is used, it must be justified by the exact target lincat;
- do not waive lock warnings as cosmetic until the category shape and constructor path have both been checked.

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

These should remain visible in the symbol status ledger and test suite until cleanly resolved.

---

## Status labels for implementation patterns

Every nontrivial local pattern should be mentally classified with one of these statuses.

### `stable`

Use when:
- the helper/constructor pattern compiles cleanly;
- no lock-warning cluster is attached to it;
- the pattern matches current Albanian precedent.

### `warning`

Use when:
- the pattern compiles, but nearby failures or warning clusters suggest fragility;
- the pattern depends on a shallow extraction in a fragile zone;
- the pattern is valid only under current local assumptions.

### `temporary`

Use when:
- the pattern is a transitional repair to keep the subsystem compiling;
- a fuller constructor-preserving rewrite is still expected.

### `fallback`

Use when:
- the pattern is a compatibility wrapper or reduced builder;
- it is allowed only because a safer constructor path is currently unavailable.

### `blocked`

Use when:
- the pattern is known to drift;
- the pattern fails in current module context;
- or the docs retain it only as a lesson or warning.

No `warning`, `temporary`, `fallback`, or `blocked` pattern should silently become invisible in later reasoning.

The symbol status ledger is the canonical global tracker for these statuses.

---

## Approved implementation workflow

For every nontrivial function:

1. Read the abstract signature.
2. Check whether `ExtendFunctor` already gives a constructor path.
3. Read the Albanian lincat shape in `CatSqi.gf` or the gfo artifacts.
4. Inspect the same category in Albanian core modules.
5. Check current module-context availability of the intended constructor or helper.
6. Verify exact helper-category compatibility.
7. Check the helper registry if a shared or compatibility helper is involved.
8. Check the shallow-category constructor matrix if the target category looks surface-oriented.
9. Check the symbol status ledger if the function or helper is known fragile.
10. Check the stale-comment tracker if comments seem to drive the local pattern.
11. Assign a provisional status to the chosen pattern (`stable`, `warning`, `temporary`, `fallback`, `blocked`).
12. Only then inspect Bulgarian or German if the subsystem is genuinely custom.
13. Preserve the full target category shape unless the target is truly shallow.
14. Compile.
15. Resolve any lock-field warnings before considering the function stable.
16. If the change affects a family, inspect the related family members before finalizing.
17. If the failure reveals a new operational lesson, update the decision log and the relevant rule docs.

---

## Known anti-drift rules

1. Do not implement from function name alone.
2. Do not flatten `AP` or `CN` to a string unless the target category is really flat.
3. Do not rebuild `CN` with only `s` and `g` when the surrounding subsystem expects fuller category-preserving behavior.
4. Do not patch only one member of a structured family such as `RNP`.
5. Do not copy German field inventory into Albanian automatically.
6. Do not treat a compile success with lock warnings as finished.
7. Do not use model languages before checking Albanian core modules and `ExtendFunctor`.
8. Do not assume a constructor is available only because the category looks simple in documentation.
9. Do not reuse near-match helpers by intuition; exact type compatibility is required.
10. Do not force a documentation interpretation over current compiler reality.
11. Do not treat stale comments as implementation evidence.
12. Do not borrow a constructor pattern from another module until module-context availability is checked locally.
13. Do not treat compatibility wrappers as default rich-category patterns.
14. Do not let a local repair erase subsystem ownership boundaries.
15. Do not ignore the helper registry, shallow-category constructor matrix, or symbol status ledger once they exist.

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

### Model-language refusal rule

If Bulgarian or German suggests a pattern that current Albanian lincats or current Albanian constructor availability do not support, reject the transfer.

Model languages are explanatory aids, not override licenses.

---

## Current implementation priorities for Albanian repairs

Based on observed repair runs and the current docs bundle, the active priorities are:

1. eliminate category-shape mismatches in `ExtendSqi.gf` and its companion subsystems;
2. eliminate lock-field warnings in AP/CN and existential functions;
3. keep `RNP` on a coherent `NP/ListNP` strategy unless forced otherwise;
4. replace remaining flattening hacks with constructor-based implementations;
5. prefer current compile reality over inferred convenience patterns when documentation is underspecified;
6. keep helper usage explicit enough that `A`/`AP`, `CN`/`NP`, `Pron`/`NP`, and shallow structural categories cannot be confused;
7. use the new support docs to turn general rules into operational checks.

High-priority watchlist:
- `ICompAP`
- `N2VPSlash`
- `AdjAsCN`
- `AdjAsNP`
- `CompoundAP`
- `RNP` family
- any existential implementation not using constructor composition
- `FocusAP`
- structural shallow-category construction in `StructuralSqiClause.gf`

---

## Minimal checklist before accepting an Albanian implementation

Accept a change only if all are true:

- current file and current compile behavior checked;
- abstract signature checked;
- inherited `ExtendFunctor` path checked;
- Albanian category shape checked;
- Albanian core module precedent checked;
- current constructor/helper availability in the module checked;
- exact helper-type compatibility checked;
- helper registry checked if shared helper reuse is involved;
- shallow-category constructor matrix checked if the target or intermediate category is shallow-looking;
- symbol status ledger checked if the symbol or pattern is fragile;
- stale-comment tracker checked if comments influence the decision;
- no accidental category flattening;
- compatibility/fallback helpers explicitly justified if used;
- family coherence checked if the function belongs to a subsystem family;
- compile passes;
- no new lock-field warnings;
- if subsystem-level, related functions inspected together;
- no stale comment is being used as the decisive evidence;
- if a new lesson was learned, the decision log and rule docs have a follow-up path.

---

## Maintenance obligations

When this document changes, also check and synchronize:

- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`

This file is an operational control document.  
It is only useful if it stays synchronized with the live codebase and the rest of the anti-drift suite.

---

## Source anchors for this document

Primary Albanian files:

- `albanian/CatSqi.gf`
- `albanian/ResSqi.gf`
- `albanian/NounSqi.gf`
- `albanian/AdjectiveSqi.gf`
- `albanian/AdverbSqi.gf`
- `albanian/SentenceSqi.gf`
- `SyntaxSqi.gf`
- `albanian/ConjunctionSqi.gf`
- `albanian/ExtraSqi.gf`
- `albanian/ExtendSqi.gf`
- `albanian/ExtendSqiHelpers.gf`
- `albanian/ExtendSqiFocusPrep.gf`
- `albanian/StructuralSqiClause.gf`
- `albanian/StructuralSqi.gf`

RGL / API references:

- `abstract/Extend.gf`
- `common/ExtendFunctor.gf`
- codex router and per-function/per-type documentation

Control-doc references:

- helper registry
- shallow-category constructor matrix
- symbol status ledger
- stale-comment tracker
- current category and lincat reference
- current syntax and constructor rules
- current override and inheritance policy
- current anti-drift rules
- current decision log
- current minimal test suite

Model-language references:

- Bulgarian concrete files
- German `ExtendGer.gf` and related category files

Validation references:

- gf-audit run logs for Albanian compile/warning behavior
- Albanian evidence appendix
- Albanian module dependency map
- Albanian module extraction coverage