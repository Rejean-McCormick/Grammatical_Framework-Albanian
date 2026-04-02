# ALBANIAN_LANGUAGE_ARCHITECTURE

## Status

Authoritative architecture document for the Albanian GF grammar in the current uploaded code snapshot.

This document is the top-level map for how the Albanian concrete syntax is organized, which modules define category shapes, which modules are the stable grammatical center, which modules are structural or extension layers, which modules are thin wrappers or package surfaces, and how future work should align with the current architecture instead of drifting into ad hoc local rewrites.

It is an architecture document, not a repair log.

It is intentionally separate from the more operational documents that govern:
- exact constructor legality,
- exact helper compatibility,
- stale-comment handling,
- symbol maturity,
- shallow-category constructor verification,
- and test-level regression policy.

Those belong to:
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`

This file defines the architectural picture those documents are expected to preserve.

---

## Purpose

The Albanian GF grammar has reached the point where maintainers and AI systems need one document that answers the architecture question clearly:

- What is the stable center of the Albanian grammar?
- Which modules define concrete category shapes?
- Which modules are the intended producers of the most important categories?
- Which modules are architectural aggregators rather than owners?
- Which modules are extension/risk zones?
- Which modules should remain thin?
- Where do structural items belong?
- Which documents should be consulted for architecture, and which for concrete implementation discipline?

The purpose of this document is to preserve that stable architectural picture while also stating, explicitly, the architectural boundaries that prevent AI systems and maintainers from confusing:

- architectural approval with constructor legality,
- category shape with module-local constructor availability,
- module ownership with local patch permission,
- and surface permissibility with helper-type compatibility.

This document therefore does two things at once:

1. it describes the architectural layering of the Albanian grammar;  
2. it states the architectural boundaries that operational docs must respect.

---

## Scope

The architecture described here is based on:

- the uploaded Albanian source dump under `GF/lib/src/albanian`,
- the visible root-level resources `SyntaxSqi`, `ConstructorsSqi`, `TrySqi`, and `SymbolicSqi`,
- the current extension/debugging context around `ExtendSqi`,
- the current Albanian documentation bundle,
- and selected comparison sources such as `ExtendFunctor.gf`, `Extend.gf`, and the codex router/guidance only as supporting comparison points, not as primary sources for Albanian facts.

This document is not intended to replace more detailed implementation-control documents such as:
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`

It also does not replace support-control documents such as:
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`

Instead, it provides the architectural frame that those documents refine.

---

## 1. Top-level system shape

The Albanian grammar follows the standard RGL layering pattern.

At the top sit the exposed and practical entry points:
- `LangSqi`
- `GrammarSqi`
- `SyntaxSqi`
- `ConstructorsSqi`
- `TrySqi`
- `SymbolicSqi`

Below those sit the ordinary Albanian grammar modules:
- `NounSqi`
- `AdjectiveSqi`
- `NumeralSqi`
- `VerbSqi`
- `SentenceSqi`
- `QuestionSqi`
- `RelativeSqi`
- `ConjunctionSqi`
- `IdiomSqi`
- `TextSqi`
- `PhraseSqi`

Below or alongside them sit the Albanian resource and paradigm layers:
- `ResSqi`
- `CatSqi`
- `MorphoSqi`
- `ParadigmsSqi`

Next to the ordinary grammar sits the structural vocabulary path:
- `StructuralSqiRes`
- `StructuralSqiNominal`
- `StructuralSqiVerbal`
- `StructuralSqiClause`
- `StructuralSqi`

And outside the stable core sits the explicit extension/override layer:
- `ExtraSqi`
- `ExtraSqiAbs`
- `ExtendSqi`
- `ExtendSqiScaffolding`
- `ExtendSqiHelpers`
- `ExtendSqiVPBridge`
- `ExtendSqiAPCN`
- `ExtendSqiExistential`
- `ExtendSqiRNP`
- `ExtendSqiFocusPrep`
- `ExtendSqiLexicon`

This is the basic architectural picture:
- the core grammar remains the baseline,
- the structural layer supplies the shared structural vocabulary,
- the user-facing API is narrower than the full graph,
- and `ExtendSqi` is an additional override layer rather than the center of the language.

This distinction must remain explicit.

---

## 2. Architectural layers

## 2.1 Resource and parameter layer

### `ResSqi`
`ResSqi` is the foundational Albanian resource layer.

Architecturally, it is the main source of truth for:
- shared low-level structures,
- agreement machinery,
- core noun/adjective/verb record shapes,
- complements and preposition-like support structures,
- clitic-linking behavior,
- and basic lexical support constructors.

This means:
- low-level Albanian shape decisions should be grounded in `ResSqi`,
- not inferred indirectly from abstract category names alone,
- and not reverse-engineered from one surface string.

### `MorphoSqi`
`MorphoSqi` is the main morphological realization layer.

Architecturally, it carries the heavy language-specific inflectional machinery. It is large, foundational, and downstream-critical, but it is not the preferred first coding surface for ordinary syntactic edits. Most syntax work should treat it as a lower layer whose effects are accessed through `ResSqi`, `ParadigmsSqi`, and the core grammar modules.

### `ParadigmsSqi`
`ParadigmsSqi` sits above the resource/morphology base as the lexical-pattern and constructor-pattern layer.

Architecturally, it matters because:
- many structural and lexical modules use paradigm constructors,
- it is a safe source of public lexical/functional builders when available,
- and it often supplies the correct package boundary between raw morphology and grammar-level use.

### `ParamX`
`ParamX` is part of the shared parameter environment visible across many Albanian modules. It belongs to the low-level structural environment rather than to the user-facing grammar surface.

## 2.2 Category layer

### `CatSqi`
`CatSqi` is the hinge between abstract RGL categories and Albanian concrete representations.

This is one of the most important architectural facts in the whole grammar.

`CatSqi` defines which categories are:
- rich,
- shallow,
- list-like,
- pronoun-sensitive,
- agreement-bearing,
- or simplified for higher-level composition.

The current Albanian architecture deliberately uses a mixed model:
- some categories preserve rich internal structure,
- many higher clausal or verbal categories are shallow/string-like.

This rich/shallow divide is intentional and must remain visible.

The architecture therefore assumes:

- `CN` is rich
- `AP` is rich
- `NP` is rich enough to carry case and agreement
- `Pron` is rich
- important list categories preserve structure
- many clause/sentence/question outputs are shallow

This is not a bug and must not be “normalized away”.

## 2.3 Core syntax layer

### `GrammarSqi`
`GrammarSqi` is the ordinary core grammar aggregator.

It combines the main Albanian syntax modules and serves as the baseline grammar without extension-specific override logic. Architecturally, this is the stable center of the language.

New work should prefer:
- core grammar reuse,
- core constructor paths,
- and the `SyntaxSqi` API built on top of them,

before reaching for the extension layer.

### Core syntax producers
The main ordinary syntax producers are:

- `NounSqi`
- `AdjectiveSqi`
- `NumeralSqi`
- `VerbSqi`
- `SentenceSqi`
- `QuestionSqi`
- `RelativeSqi`
- `ConjunctionSqi`
- `IdiomSqi`
- `TextSqi`
- `PhraseSqi`

Architecturally, these are the modules that define the ordinary Albanian grammar. They should be treated as the default home for ordinary syntactic behavior.

### `SyntaxSqi`
`SyntaxSqi` is the practical API layer.

It exposes a narrower and more practical constructor surface than the full module graph. That design is intentional. The preferred path for most composition is through `SyntaxSqi` and the stable core modules, not through direct low-level record rebuilding.

This means:
- for ordinary composition, `SyntaxSqi` is the preferred public surface,
- for architectural reasoning, `GrammarSqi` is the core grammar center,
- and for low-level category truth, `CatSqi` and `ResSqi` remain authoritative.

---

## 3. Core data model

## 3.1 Nouns and noun phrases

`CN` is a rich nominal record, and `NounSqi` uses it compositionally.

Architecturally, the nominal pipeline is:

- lexical noun-like material builds `CN`
- determination and quantification turn `CN` into `NP`
- higher syntax consumes `NP`

This is the correct Albanian reading and should not be blurred.

The key architectural consequence is:
- noun-like lexical material belongs on the `CN` side,
- sentence-level consumption belongs on the `NP` side,
- and it is a mistake to treat a noun string as if it were already a full `CN` or `NP`.

## 3.2 Adjectives and adjective phrases

`AP` is structurally sensitive and agreement-bearing.

Architecturally, `AP` must not be confused with a lexical adjective item or a single extracted adjective surface cell.

This means:
- `A`/lexical adjective material and `AP` are not the same architectural object,
- `AP` belongs to the rich side of the grammar,
- and any architecture or coding discussion must keep `A`/`Adj` distinct from `AP`.

Surface extraction is architecturally acceptable only when the **target** is shallow. That rule belongs to implementation control, but it follows from architecture.

## 3.3 Pronouns and agreement

`Pron` is not merely a string.
`NP` is not merely a string.
Agreement is part of the architecture.

This matters because pronouns, agreement-bearing NPs, and list categories sit on the rich side of the grammar even when many clause-level outputs do not. Architectural work therefore has to treat nominal/pronominal categories as structurally sensitive, not as “surface-like because Albanian often linearizes strings at higher levels”.

## 3.4 Verbs and predication

Albanian verbal and clausal architecture is intentionally mixed:
- much of the higher predicational surface is shallow,
- while nominal and adjectival structure remains richer.

This rich/shallow asymmetry is one of the most important architectural facts of Albanian GF.

Therefore:
- a shallow `Cl`/`S`/`QS`/`VP`-side result does not imply that its inputs were architecturally shallow,
- and a rich `AP`/`NP`/`CN` target still requires structure even if the surrounding clause layer is string-like.

## 3.5 List categories

`ConjunctionSqi` and related list architecture show that list categories matter structurally.

Architecturally:
- `ListNP`, `ListCN`, and `ListAP` are not disposable wrappers,
- and their treatment must preserve the shape of what they coordinate when that shape matters.

This becomes especially important in:
- nominal coordination,
- reflexive-NP work,
- and any place where list categories are tempted into flattening because the visible surface looks easy.

---

## 4. Composition pattern across modules

The main upward path of Albanian composition is:

1. `ResSqi` / `MorphoSqi` / `ParadigmsSqi` define low-level materials and lexical patterns.
2. `CatSqi` assigns Albanian concrete category shapes.
3. Domain modules (`NounSqi`, `AdjectiveSqi`, `VerbSqi`, etc.) implement the ordinary grammar.
4. `GrammarSqi` aggregates the ordinary grammar.
5. `SyntaxSqi` provides a narrower practical API.
6. Structural modules supply shared structural vocabulary.
7. `ExtendSqi` and `ExtraSqi` provide additional extension behavior outside the stable center.

This is the “happy path” of Albanian development.

A change is architecturally safe when it respects that path:
- low-level truth comes from resources and categories,
- ordinary grammar belongs in the core modules,
- structural vocabulary belongs in structural resources,
- extension-specific behavior belongs in extension layers,
- and user-facing composition should not bypass the API layer unnecessarily.

---

## 5. Structural architecture

## 5.1 Structural path

The structural vocabulary is intentionally split into subresources and then re-exported:

- `StructuralSqiRes`
- `StructuralSqiNominal`
- `StructuralSqiVerbal`
- `StructuralSqiClause`
- `StructuralSqi`

This is not accidental factoring. It is the architectural path for:
- determiners,
- quantifiers,
- structural pronouns,
- prepositions,
- clause particles,
- conjunction-like items,
- and other structural vocabulary.

## 5.2 Ownership rule

Architecturally:
- `StructuralSqi` should remain a pure aggregator,
- ownership belongs in the structural submodules,
- and fixes to clause/preposition/function-word behavior usually belong in structural resources, not in `ExtendSqi`.

This is especially important because recent drift cases have shown that:
- clause-level structural items can look deceptively simple,
- but their ownership still belongs to the structural layer.

## 5.3 Structural join point

`StructuralSqi` is the structural join point used by `SyntaxSqi`.

That means:
- it is architecturally important,
- but not as a place for new logic,
- rather as the surface where the already-owned structural submodules are re-exported.

The architecture should continue to treat it as a thin aggregator.

---

## 6. Extension architecture

## 6.1 `ExtraSqi`
`ExtraSqi` is an extra grammar layer with non-core helpers and additional constructions.

Architecturally, it sits outside the stable core grammar but inside the Albanian-specific extension space. It is not the same thing as `ExtendSqi`, and it should not be conflated with the controlled `ExtendFunctor` override discipline. It is a shared extension-support area and deserves explicit respect as a separate layer.

## 6.2 `ExtendSqi`
`ExtendSqi` is the high-risk extension/override layer for `Extend`.

Architecturally:
- it is instantiated from `ExtendFunctor`,
- it must start from inherited design,
- and it must override only where Albanian has a genuine local need.

This remains one of the main architectural rules of the current cycle.

## 6.3 Thin-coordinator decision
The approved cycle design keeps:
- `ExtendSqi.gf` thin,
- companion subsystem modules as the owners of Albanian-specific implementation logic,
- and unsupported families inherited.

That decision is architecturally correct and should not be changed casually.

In particular:
- `ExtendSqi.gf` is not a second Albanian core grammar,
- it is not the place for local ad hoc helpers,
- and it is not the place to quietly reintroduce unsupported family machinery.

## 6.4 Companion subsystem structure

The companion split under the current architecture includes:
- scaffolding
- helpers
- VP bridge
- AP/CN conversion
- existential
- RNP
- focus/preposition
- lexical tail

Architecturally, this means:
- extension logic should be grouped by subsystem,
- subsystem ownership belongs in companion files,
- and family coherence matters more than one-off function patches.

## 6.5 Unsupported inherited families

The current architecture explicitly keeps the VPS/VPI/VPS2/VPI2/list-wrapper family inherited this cycle.

Architectural consequence:
- no `ExtendSqiVPS.gf`
- no quiet reintroduction of VPS-family ownership into companion modules
- no drift from the approved cycle scope

This is a locked architectural decision for the current cycle.

---

## 7. Risk zones

The architecture now clearly distinguishes between the stable center and the high-risk override zones.

## 7.1 Stable architectural center

The stable center includes:
- `ResSqi`
- `CatSqi`
- `NounSqi`
- the ordinary core grammar modules
- `GrammarSqi`
- the structural split and aggregation path
- the `SyntaxSqi` API surface

These are the modules and paths that future work should prefer first.

## 7.2 High-risk override zones

The highest architectural risk sits in:
- `ExtendSqi`
- its companion override subsystem modules
- `ExtraSqi`
- structurally shallow-looking but ownership-sensitive clause/function-word zones
- modules where stale comments or fallback patterns can distort AI reasoning

This risk classification does **not** mean those modules are architecturally wrong. It means they require stronger discipline and stronger documentation.

## 7.3 Rich/shallow boundary as a permanent risk
The deepest Albanian architectural risk is not one file. It is the boundary between:
- rich categories (`CN`, `AP`, `NP`, `Pron`, list categories)
- and shallow higher categories (`Cl`, `S`, `QS`, many `VP`-side outputs, structural shell outputs)

Many future bugs come from forgetting which side a category belongs to.

The architecture therefore requires that this boundary remain explicit.

---

## 8. Thin wrappers and package surfaces

Several top-level or support modules are intentionally thin:
- `ConstructorsSqi`
- `TrySqi`
- `SymbolicSqi`
- `AllSqi`
- `AllSqiAbs`
- `LangSqi`
- `TextSqi` in practice
- some support/test modules

Architecturally, these are:
- package surfaces,
- convenience shells,
- or light aggregators.

They should remain thin and should not become storage for new grammatical logic.

That thinness is a feature, not an omission.

---

## 9. Architecture vs implementation truth

This distinction now needs to be explicit.

### Architecture truth
Architecture determines:
- ownership,
- layering,
- stable center vs extension zones,
- aggregation boundaries,
- which family belongs where,
- which files should remain thin.

### Implementation truth
Implementation determines:
- exact constructor legality,
- exact helper compatibility,
- exact module-context availability,
- compile acceptance,
- warning-state behavior,
- and current symbol maturity.

The architecture document therefore **does not certify**:
- that a specific `lin Cat { ... }` pattern is valid,
- that a helper can be reused across categories,
- or that a shallow category summary guarantees a safe local constructor.

Those belong to the operational docs.

This distinction must remain explicit so that no one treats architecture approval as implementation proof.

---

## 10. Relationship to the operational documents

This file should be read together with the following documents, each with a different role.

### `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
Use for:
- shape-preserving implementation logic,
- constructor legality discipline,
- exact-helper-type rule,
- comment-authority rule,
- module-context constructor rule.

### `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
Use for:
- approved coding patterns,
- helper classes,
- compatibility wrappers,
- constructor-chain use,
- pattern-by-pattern implementation decisions.

### `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
Use for:
- current Albanian category shapes,
- rich vs shallow category classification,
- shape caveats,
- “do not conclude from shape alone” guidance.

### `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
Use for:
- source-precedence hierarchy,
- inherit-vs-override decisions,
- architecture-vs-implementation conflict resolution,
- evidence order for concrete fixes.

### `ALBANIAN_HELPER_REGISTRY.md`
Use for:
- exact helper names,
- exact types,
- helper class,
- allowed and forbidden reuse zones.

### `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
Use for:
- category-by-category shallow constructor availability,
- module-context verification,
- preferred constructor paths for structurally shallow-looking items.

### `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
Use for:
- whether a symbol or file is stable,
- fallback,
- warning-state,
- blocked,
- historical,
- or pending repair.

### `ALBANIAN_STALE_COMMENT_TRACKER.md`
Use for:
- known comment hazards,
- historical explanations no longer safe as evidence,
- comment cleanup obligations.

### `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`
Use for:
- which modules are already documented deeply enough,
- which are only structurally covered,
- and which still need targeted extraction.

This file remains the top-level map above those operational layers.

---

## 11. Current architecture-backed decisions that should remain fixed

The following decisions are architecturally correct and should remain fixed unless new strong evidence appears.

1. `ExtendSqi.gf` remains a thin coordinator.
2. Companion subsystem modules own `ExtendSqi` logic.
3. Unsupported VPS/VPI/VPS2/VPI2/list-wrapper families remain inherited this cycle.
4. `StructuralSqi.gf` remains a pure aggregator.
5. Structural clause/preposition/function-word behavior belongs in structural resources rather than drifting into `ExtendSqi`.
6. The stable grammar center remains the ordinary core modules aggregated by `GrammarSqi`.
7. `SyntaxSqi` remains the practical API surface for most composition.
8. Rich categories must stay visibly rich in the architecture.
9. Thin wrappers should remain thin.
10. Module ownership must remain separate from local patch temptation.

---

## 12. Architectural reading order for maintainers and AI systems

When orienting to the Albanian grammar at the architectural level, read in this order:

1. `ALBANIAN_LANGUAGE_ARCHITECTURE.md`
2. `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`
3. `ALBANIAN_MODULE_DEPENDENCY_MAP.md`
4. `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
5. `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
6. `ALBANIAN_HELPER_REGISTRY.md`
7. `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
8. relevant source file(s) in the current codedump
9. current compile/audit evidence
10. model-language references only if still needed

This order preserves the distinction between:
- architecture,
- implementation control,
- live code reality,
- and comparison material.

---

## 13. What this document forbids

This architecture document forbids the following confusions:

- treating `ExtendSqi` as the main Albanian grammar center,
- treating architecture approval as proof of constructor legality,
- treating category shape as proof of local constructor availability,
- treating shallow clause categories as evidence that rich nominal/adjectival categories may also be flattened,
- moving ownership from structural resources into `ExtendSqi` because a local patch feels convenient,
- moving extension-specific logic into thin aggregators or API wrappers,
- rebuilding low-level records directly when the architecture already provides a stable path through core modules or API layers,
- and mistaking stale comments for architecture truth.

---

## 14. Summary

The Albanian GF grammar has a stable and readable architecture:

- `ResSqi`, `MorphoSqi`, and `ParadigmsSqi` form the low-level material/pattern base.
- `CatSqi` defines the concrete category regime.
- ordinary grammar modules implement the stable center.
- `GrammarSqi` aggregates that center.
- `SyntaxSqi` provides the practical public API.
- `StructuralSqi*` modules provide structural vocabulary through a split ownership model.
- `ExtendSqi` is a controlled, high-risk override layer outside the stable center.
- thin wrappers remain thin.

The architecture does **not** need rewriting.

What must remain strict is the boundary between:
- architecture truth,
- implementation truth,
- and live compile truth.

This file therefore serves as the top-level architectural reference for all future Albanian work: preserve the stable center, keep ownership where it belongs, and let the operational docs govern exact constructors, helpers, and anti-drift enforcement.