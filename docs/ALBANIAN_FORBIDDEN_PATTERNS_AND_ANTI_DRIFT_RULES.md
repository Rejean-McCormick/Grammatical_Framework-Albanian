# ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES

## Status

Authoritative anti-drift control document for Albanian GF maintenance and AI-assisted editing.

This document defines **forbidden implementation patterns**, **forbidden inference habits**, and **required anti-drift checks** for the Albanian GF concrete syntax.

Its purpose is to stop future work from:

- breaking Albanian category shapes,
- flattening structured categories into strings,
- reusing helpers across near-types,
- copying model-language solutions blindly,
- guessing constructors from category descriptions,
- drifting away from `Extend.gf`, `ExtendFunctor.gf`, and the Albanian core modules,
- reintroducing errors already observed in Albanian compile and audit runs,
- trusting stale comments or guessed constructor patterns over live compiler reality,
- and treating fallback/compatibility wrappers as canonical architecture.

This file is **normative** for Albanian implementation work.

It should be used together with:

- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`

This document is not a code-style guide.  
It is a **maintenance safety document**.

---

## 1. Purpose

The Albanian GF grammar is now documented well enough that future work should not need to rediscover the same failure modes over and over.

This document exists to record the **things that must not be done** even when they look plausible.

The central lesson is simple:

> A pattern can look linguistically reasonable, can look GF-like, and can even resemble something used elsewhere in the grammar — and still be wrong for the current Albanian module, category, helper inventory, or compile context.

This file therefore forbids:

- category-shape drift,
- constructor-availability guessing,
- near-type helper reuse,
- stale-comment reasoning,
- subsystem splitting,
- model-language over-transfer,
- and untracked fallback promotion.

---

## 2. Source precedence (highest to lowest)

When sources disagree, follow this order:

1. `abstract/Extend.gf` and other Albanian-relevant abstract signatures.
2. Current compiler behavior and current audit output for the actual module.
3. Current Albanian codedump and current nearby Albanian source patterns.
4. `common/ExtendFunctor.gf` default compositions and `variants {}` boundaries.
5. Albanian lincat and constructor reality in core Albanian modules:
   - `CatSqi.gf`
   - `ResSqi.gf`
   - `NounSqi.gf`
   - `AdjectiveSqi.gf`
   - `AdverbSqi.gf`
   - `SentenceSqi.gf`
   - `QuestionSqi.gf`
   - `ConjunctionSqi.gf`
   - `RelativeSqi.gf`
   - `SyntaxSqi.gf`
   - `ExtraSqi.gf`
6. Albanian architecture and policy documents.
7. Bulgarian and German model-language references.
8. Comments, historical notes, and chat history.

### 2.1 Consequences of this precedence

Forbidden:
- forcing code to match a stale comment,
- forcing code to match an inferred constructor pattern not accepted by the compiler,
- ignoring current compile failure because a doc summary “looked simple”,
- choosing a helper by semantic similarity instead of exact type.

Required:
- verify exact abstract type first,
- check the live module next,
- confirm constructor availability in module context,
- and only then use documentation/model-language support.

---

## 3. Governing anti-drift principles

## 3.1 Category shape is primary

The target category controls the implementation strategy.

Forbidden:
- returning a flat string because the surface wording is easy,
- rebuilding a rich category from one extracted surface cell,
- ignoring hidden fields such as agreement or lock fields,
- assuming that because something prints like a string it can be implemented like one.

Required:
- preserve the real Albanian lincat shape of the target category,
- preserve agreement, case, species, number, and gender where those belong,
- preserve list category structure where list categories are involved.

## 3.2 Shape does not license a constructor

A documented or inferred lincat shape is necessary evidence, but it is **not sufficient** to justify a constructor pattern.

Forbidden:
- “`DConj` looks like `{s : Str}`, so `lin DConj { ... }` must be safe everywhere”
- “`Prep` looks simple, so any naked string is fine”
- “`Utt` is shallow, so any vaguely related helper is acceptable”
- “the category summary says it is surface-like, so no module-context check is needed”

Required:
- verify constructor availability in the actual current module context,
- verify the category is actually in scope,
- verify the record fields match the accepted current representation,
- verify the constructor path is supported by current code or compile reality.

## 3.3 Exact helper type is mandatory

Helper reuse is allowed only under exact category compatibility.

Forbidden:
- reusing an `A -> Str` helper for an `AP -> Str` use site,
- reusing a `CN` helper on `NP`,
- reusing list helpers across list categories by similarity,
- reusing a compatibility wrapper as a canonical rich-category builder,
- treating semantic intent as stronger than typed input/output shape.

Required:
- verify exact helper input type,
- verify exact helper output role,
- check the helper registry before reusing a helper,
- treat helper names as non-evidence until the type is confirmed.

## 3.4 Comments are secondary evidence only

Comments may explain history, intent, or an old design state. They are never stronger than current code and compiler reality.

Forbidden:
- fixing code to match a stale comment,
- using a comment as sole proof of constructor legality,
- copying historical comments into new code without verification,
- citing an old note as if it were present-tense architecture.

Required:
- update or mark comments when they drift,
- consult the stale-comment tracker when a comment looks suspicious,
- treat live typed source as stronger evidence than prose.

---

## 4. Forbidden patterns: category flattening and record fabrication

## 4.1 Rich-category flattening

Do not flatten rich Albanian categories into strings unless the target category is genuinely string-like.

Forbidden:
- `CN` built from a surface string in final rich-category code,
- `AP` built from a single nominative masculine singular form,
- `NP` built from a single string without case/agreement,
- `ListNP` treated like one concatenated surface string,
- treating a flattened compatibility wrapper as an acceptable final category-preserving implementation.

High-risk examples:
- `apStr`
- `cnStr`
- `apConst`
- `cnConst`
- any ad hoc `lin NP {s = ...}` missing the real Albanian obligations.

## 4.2 Partial record fabrication

Do not fabricate partial records for categories that Albanian core code treats as structured.

Forbidden:
- leaving out `a : Agr` from an `NP`,
- leaving out `g : Gender` from a `CN`/noun-like category,
- treating `ListNP` as a bare `Str`,
- inventing a minimal record because only one field seems visible in a nearby snippet.

Required:
- check the category reference,
- check the live source producer,
- check the current compiler behavior for missing fields/lock warnings,
- and only then decide whether direct record construction is acceptable.

## 4.3 Shallow-target fallacy

A shallow target does not cancel type discipline.

Forbidden:
- because the target is `Utt`, any adjective-family helper is acceptable,
- because the result is surface-facing, helper categories can be mixed loosely,
- because a category prints simply, the input category no longer matters.

Example of forbidden reasoning:
- using an `A` helper on an `AP` because both are “adjective-like”.

---

## 5. Forbidden patterns: constructor guessing and module-context drift

## 5.1 Constructor-by-shape guessing

Forbidden:
- choosing `lin Cat { ... }` from category shape alone,
- assuming a shallow-looking category is always locally constructible,
- inferring constructor legality from one documentation note without checking the live module.

This is one of the main anti-drift rules in the Albanian documentation suite.

## 5.2 Borrowed constructor transfer

A constructor pattern seen in one module is not automatically valid in another.

Forbidden:
- importing a `lin Cat { ... }` pattern from one module into another with different opens/imports,
- assuming a structural-category constructor works anywhere a similar category is mentioned,
- copying a pattern from a support/fallback module into a core module and calling it canonical.

Required:
- verify scope,
- verify aliases,
- verify current module imports,
- verify current compile acceptance.

## 5.3 “It compiled somewhere else” reasoning

Forbidden:
- “this constructor pattern appears in another module, so it should work here too”
- “this older patch used the category directly, so it must still be legal”
- “the category is exported somewhere, so `lin Cat { ... }` must be available here”

Required:
- treat module context as part of the constructor legality check.

## 5.4 Structural-category guessing

Structural and functional items are especially drift-prone because they often look shallow.

High-risk items include:
- `Prep`
- `Subj`
- `Conj`
- `PConj`
- `DConj`
- `CAdv`
- `Adv`
- `IAdv`
- `Utt`
- `Voc`

Forbidden:
- guessing structural constructors from lincat description alone,
- assuming one shallow structural item behaves like another,
- assuming that documented surface shape implies direct local `lin` is approved.

Required:
- consult `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`,
- check the owning module,
- confirm verified constructor path,
- and respect structural ownership boundaries.

---

## 6. Forbidden patterns: helper misuse

## 6.1 Name-based helper reuse

Forbidden:
- reusing a helper because its name “looks close enough”,
- treating shared and local helpers as interchangeable,
- using a helper outside its documented category family.

Examples:
- `adjSurfaceNomMascSg` on `AP`
- `cn`-style extractor on `NP`
- list-oriented helper on non-list category
- compatibility wrapper presented as canonical builder

## 6.2 Family-neighbor substitution

Forbidden:
- treating `A`, `A2`, and `AP` as interchangeable,
- treating `N` and `CN` as interchangeable,
- treating `Pron` and generic `NP` as interchangeable,
- treating `ListNP`, `ListCN`, and `ListAP` as swappable just because all are list-like.

## 6.3 Fallback promotion

Forbidden:
- documenting a fallback/compatibility helper as if it were a stable canonical pattern,
- moving a temporary helper into a shared helper layer without review,
- allowing a workaround to become invisible by omitting status labels.

Required:
- consult `ALBANIAN_HELPER_REGISTRY.md`,
- keep fallback labels visible,
- and consult `ALBANIAN_SYMBOL_STATUS_LEDGER.md` before promoting a helper pattern.

## 6.4 Unverified promotion into shared helpers

A local helper may not be promoted to the shared helper layer merely because it appears reusable.

Forbidden:
- promoting a helper without exact type classification,
- promoting a helper without a registry entry,
- promoting a helper while its compile or semantic status is still warning/fallback/blocked.

Required:
- helper registry entry,
- exact type verification,
- safe target-category statement,
- and current compile acceptance in the shared context.

---

## 7. Forbidden patterns: subsystem drift

## 7.1 One-function family patching

Some Albanian areas must be treated as families, not isolated edits.

High-risk families:
- existential family,
- AP/CN conversion family,
- RNP family,
- focus/preposition family,
- VP/VPSlash bridge family,
- structural functional-item families.

Forbidden:
- redesigning one family member without checking the rest,
- mixing fallback and canonical representations within the same family without documentation,
- splitting one family across unrelated local hacks.

## 7.2 Coordinator pollution

`ExtendSqi.gf` is a thin coordinator, not a second core grammar.

Forbidden:
- reintroducing helper logic into `ExtendSqi.gf`,
- local coordinator-side category construction,
- restoring VPS/VPI/VPS2/VPI2/list-family machinery in the coordinator,
- moving family logic out of companion modules into the coordinator.

Required:
- keep coordinator thin,
- keep family ownership in companion modules,
- and follow `ALBANIAN_EXTENDSQI_FINAL_TARGET.md`, `ALBANIAN_EXTENDSQI_OVERRIDE_MATRIX.md`, and `ALBANIAN_FUTURE_EXTENDSQI_STRUCTURE.md`.

## 7.3 Unsupported-family resurrection

Forbidden:
- creating `ExtendSqiVPS.gf` in the current cycle,
- silently overriding unsupported VPS/VPI/VPS2/VPI2/list wrappers,
- drifting back into unsupported inherited-family customizations without an architecture decision.

---

## 8. Forbidden patterns: structural and lexical-functional drift

## 8.1 Structural vocabulary must be treated as owner-sensitive

If a structural item belongs in:
- `StructuralSqiClause.gf`,
- `StructuralSqiNominal.gf`,
- `StructuralSqiVerbal.gf`,
- `StructuralSqiRes.gf`,
- or another explicit structural owner,

then do not casually relocate it into:
- `ExtendSqi.gf`,
- lexical tail modules,
- unrelated helpers,
- or one-off workaround modules.

## 8.2 Never infer lexical-functional truth from shallow appearance

Forbidden:
- assuming `Prep`, `DConj`, `Utt`, or `CAdv` are “just like lexical constants” everywhere,
- moving functional items into lexical modules because their visible form is short,
- equating functional shallowness with constructor freedom.

Required:
- use `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`,
- use the shallow-category constructor matrix,
- and track warning/blocked states in the symbol status ledger.

## 8.3 Structural export inconsistency

Forbidden:
- changing a structural item in the owner module but not in the aggregator/export layer,
- exposing a structural workaround through a public aggregator without documenting it,
- documenting public structural exports without checking the real owner module.

---

## 9. Forbidden patterns: model-language misuse

## 9.1 Blind copying from Bulgarian or German

Model-language references are valid only after:
- abstract signature,
- current compiler result,
- current Albanian code,
- current Albanian lincat/core constructor path,
- and architecture docs.

Forbidden:
- copying a German/Bulgarian field inventory into Albanian automatically,
- copying word order or internal record structure because it looks elegant,
- assuming a model-language override means Albanian must also override.

## 9.2 Selective copying without subsystem reasoning

Forbidden:
- copying one function from German or Bulgarian without understanding the whole family,
- using a model-language snippet to justify a local Albanian constructor that current Albanian lincats do not support,
- using model-language code as primary truth instead of Albanian code.

## 9.3 Model language over compiler reality

Forbidden:
- preferring a foreign-language pattern over a direct current Albanian compile failure,
- using Bulgarian/German to override current Albanian category shape evidence.

---

## 10. Forbidden patterns: evidence misuse

## 10.1 Documentation-over-code misuse

Documentation is normative for:
- architecture,
- ownership,
- evidence precedence,
- allowed override families,
- anti-drift obligations.

Documentation is **not** a license to invent unverified local constructor forms.

Forbidden:
- using architecture docs as proof that a concrete constructor is legal,
- treating documentation prose as stronger than current compiler/module context,
- using one policy sentence to bypass current code reality.

## 10.2 Comment-over-code misuse

Forbidden:
- “the comment says this category is implicit/defaulted, so we should code it that way”
- “this comment mentions an older fallback, so we can reuse it”
- “the comment looks authoritative, so no code check is needed”

Required:
- consult the stale-comment tracker,
- mark historical comments as historical,
- and update comments when a conflict is confirmed.

## 10.3 Chat-history-only decisions

Forbidden:
- leaving an important repair lesson only in conversation history,
- making a major policy shift without updating the decision log and rule docs,
- assuming later maintainers will infer the lesson from partial context.

Required:
- update rule docs,
- update the decision log,
- update the relevant support control docs if needed.

---

## 11. Required anti-drift workflow

For every non-trivial Albanian edit:

1. Read the exact abstract signature.
2. Check whether `ExtendFunctor` or inherited grammar already provides the composition.
3. Read the Albanian lincat shape in `CatSqi.gf`, `ResSqi.gf`, and the relevant producer modules.
4. Check the current Albanian source dump for the intended category and subsystem.
5. Verify the intended constructor is available in the current module context.
6. Verify exact helper-category compatibility.
7. Check symbol status in `ALBANIAN_SYMBOL_STATUS_LEDGER.md`.
8. Check relevant stale comments in `ALBANIAN_STALE_COMMENT_TRACKER.md`.
9. Check shallow-category rules if the target or helper path looks surface-oriented.
10. Check recent compile logs and warnings for similar failures.
11. Only then inspect Bulgarian or German if the subsystem is genuinely custom.
12. Preserve the full target category shape.
13. Compile.
14. Resolve warnings before calling the result final.
15. Record the decision if it changes family policy, helper policy, constructor policy, or stale-comment status.

Skipping steps 4–10 is drift-prone and forbidden.

---

## 12. Required status labels in Albanian docs and repairs

When a repair or pattern is not fully settled, it must be labeled as one of:

- `stable`
- `warning`
- `temporary`
- `fallback`
- `incomplete`
- `blocked`
- `blocked by compile reality`
- `historical comment only`

Forbidden:
- presenting a fallback as canonical architecture,
- presenting a blocked pattern as reusable,
- presenting a temporary workaround as a stable subsystem template,
- silently using a warning-state pattern without documenting the status.

Required:
- keep status visible in the symbol status ledger,
- mirror relevant status in the helper registry if helpers are involved,
- and use the same labels consistently across docs.

---

## 13. Current regression anchors

The following cases must remain visible as anti-drift anchors in documentation and testing.

## 13.1 FocusAP helper mismatch
Canonical forbidden pattern:
- using an `A`-typed helper on `AP`

Lesson:
- similarity of purpose is irrelevant,
- exact helper type is mandatory,
- shallow output does not relax input-category discipline.

## 13.2 Structural `DConj` constructor-context mistake
Canonical forbidden pattern:
- assuming a documented shallow category shape automatically licenses local `lin Cat { ... }`

Lesson:
- constructor availability must be checked in the actual module.

## 13.3 Stale-comment misuse
Canonical forbidden pattern:
- using an older comment as current implementation proof

Lesson:
- comments are secondary evidence only,
- stale-comment tracking is part of the anti-drift system.

## 13.4 Fallback-promotion misuse
Canonical forbidden pattern:
- documenting or reusing a compatibility wrapper as if it were a stable final builder

Lesson:
- fallback is not final,
- and compatibility is not architecture.

---

## 14. Interaction with support-control docs

This document now depends on the support-control layer.

### 14.1 `ALBANIAN_HELPER_REGISTRY.md`
Use this when:
- checking helper legality,
- verifying exact type,
- checking whether a helper is stable, fallback, temporary, or blocked.

### 14.2 `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
Use this when:
- a category looks surface-like,
- a structural/functional item tempts direct `lin`,
- or constructor availability is uncertain.

### 14.3 `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
Use this when:
- checking whether a pattern is stable,
- identifying fragile symbols before reuse,
- or deciding whether a repair can be called final.

### 14.4 `ALBANIAN_STALE_COMMENT_TRACKER.md`
Use this when:
- code comments appear to conflict with live code,
- a historical rationale looks suspicious,
- or a repair seems to depend on old prose rather than current source truth.

### 14.5 `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`
Use this when:
- deciding whether a module is already documented deeply enough,
- planning documentation work,
- or deciding whether re-auditing the source dump is still necessary for a module.

---

## 15. Promotion, demotion, and removal rules

## 15.1 Promotion rule
A local pattern may be promoted into shared documentation or shared helper use only if:
1. it compiles cleanly,
2. it matches exact category expectations,
3. it does not violate constructor-context rules,
4. it is documented with the correct status,
5. it has no unresolved drift warnings.

## 15.2 Demotion rule
A pattern must be demoted from canonical to fallback/warning if:
1. compile behavior rejects it in some modules,
2. exact helper typing was not verified,
3. constructor availability turns out to be module-specific,
4. the pattern depends on a stale comment,
5. the pattern encourages drift by similarity.

## 15.3 Removal rule
A workaround/helper/pattern should be removed or retired when:
1. an inherited constructor path becomes sufficient,
2. an Albanian core-module path replaces it,
3. the pattern is shown to encourage repeated drift,
4. the symbol status ledger no longer justifies keeping it visible as a live pattern.

---

## 16. Maintenance obligations

Whenever one of the following changes:

- current category shape,
- current constructor availability,
- helper legality,
- symbol status,
- stale-comment status,
- structural ownership,
- known fragile shallow-category behavior,
- or subsystem family policy,

update all relevant documents, including at minimum:

- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- and this file

If a new lesson changes anti-drift discipline, it is not enough to update only one doc.

---

## 17. Compact anti-drift summary

The Albanian anti-drift system requires all of the following:

- preserve Albanian category shape exactly,
- distinguish shape from constructor availability,
- require exact helper-category compatibility,
- treat comments as secondary evidence only,
- respect subsystem family coherence,
- keep coordinators thin,
- do not resurrect unsupported families,
- do not guess structural constructors from shallow appearance,
- do not copy model-language implementations blindly,
- do not promote fallback patterns into canonical architecture,
- and always resolve disputes against current compiler reality and current Albanian source truth.

The central rule is simple:

**A pattern is forbidden whenever it is justified by similarity, convenience, or historical prose rather than by exact type, current module context, current compiler behavior, and current Albanian category reality.**