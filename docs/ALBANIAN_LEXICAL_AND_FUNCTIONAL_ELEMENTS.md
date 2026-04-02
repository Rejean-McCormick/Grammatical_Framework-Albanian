# ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS

## Purpose

This document defines how **lexical and functional elements** are organized in the Albanian GF grammar, with emphasis on elements that are not ordinary open-class lexical items: pronouns, determiners, quantifiers, articles, predeterminers, interrogative items, conjunctions, subordinators, prepositions, adverbials, utterance particles, comparative adverbs, and helper-constructor resources.

The goal is to give human maintainers and AI coding agents a stable map of:

* where these elements live,
* how they are represented,
* which modules own them,
* which ones are safe to extend mechanically,
* which ones must preserve full Albanian category shape,
* which ones are only shallow in specific module contexts,
* and which current patterns are canonical vs compatibility-only vs warning-state.

This document is aligned with the uploaded Albanian codedump and compile evidence. When documentation, comments, and current code disagree, **current code plus compiler evidence win for concrete implementation details**, while architecture documents win for ownership and layering decisions.

This file is not a replacement for:
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`

Instead, it is the lexical/functional **inventory and control companion** to those broader documents. Its job is to make the non-open-class surface of the Albanian grammar explicit enough that AI systems cannot drift by similarity, by stale comments, or by shallow-category overgeneralization.

---

## Source basis

Primary Albanian sources used for this document:

* `ConstructorsSqi.gf`
* `SyntaxSqi.gf`
* `albanian/CatSqi.gf`
* `albanian/ResSqi.gf`
* `albanian/NounSqi.gf`
* `albanian/AdjectiveSqi.gf`
* `albanian/AdverbSqi.gf`
* `albanian/ConjunctionSqi.gf`
* `albanian/StructuralSqi.gf`
* `albanian/StructuralSqiClause.gf`
* `albanian/StructuralSqiNominal.gf`
* `albanian/StructuralSqiVerbal.gf`
* `albanian/NamesSqi.gf`
* `albanian/ExtendSqiHelpers.gf`
* `albanian/ExtendSqiLexicon.gf`
* `albanian/ExtendSqiFocusPrep.gf`
* `albanian/ExtraSqi.gf`

Supporting basis:

* `Extend.gf`
* `ExtendFunctor.gf`
* GF codex routing / overload-selection guidance
* compile/run logs showing active lock-field and constructor-availability constraints
* Albanian architecture / category / constructor-rule documents in the current docs bundle
* the created support documents:
  - `ALBANIAN_HELPER_REGISTRY.md`
  - `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
  - `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
  - `ALBANIAN_STALE_COMMENT_TRACKER.md`
  - `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`

---

## 1. Architectural overview

### 1.1 Two major layers

The Albanian grammar separates lexical and functional behavior into two broad layers:

1. **Core category and morphology layer**
   * category shapes and low-level record fields are defined in `CatSqi.gf` and `ResSqi.gf`
   * morphological realization is handled by modules such as `MorphoSqi.gf`, `NounSqi.gf`, `AdjectiveSqi.gf`, `VerbSqi.gf`, and `ParadigmsSqi.gf`

2. **Structural and constructor layer**
   * closed-class and functional vocabulary is exposed through `StructuralSqi.gf`
   * this layer delegates heavily to specialized structural resources:
     * `StructuralSqiClause.gf`
     * `StructuralSqiNominal.gf`
     * `StructuralSqiVerbal.gf`
   * user-facing composition and constructor selection then surface through `SyntaxSqi.gf`, while `ConstructorsSqi.gf` and `TrySqi.gf` are façade/convenience layers rather than the primary source of language-specific grammatical truth

This split matters because lexical and functional elements often look “surface-simple” while still depending on:
- hidden agreement and lock fields,
- module-specific constructor availability,
- current export path,
- or subsystem ownership rules.

### 1.2 Why lexical/functional elements are drift-prone

Lexical and functional items are a high-drift zone because they are often:
- small,
- frequent,
- surface-visible,
- and apparently easy to fabricate locally.

That impression is misleading.

A lexical or functional element may:
- belong to a core producer module,
- require a resource constructor,
- require a paradigm constructor,
- only be safely introduced through a façade re-export,
- or be allowed as a compatibility wrapper only in the extension layer.

The documentation must therefore track lexical/functional items with more discipline than “it is a short string”.

### 1.3 Relationship to the structural layer

The current Albanian structural layer is not a single flat file. It is split into:

- `StructuralSqiClause.gf`
- `StructuralSqiNominal.gf`
- `StructuralSqiVerbal.gf`

and re-exported by:

- `StructuralSqi.gf`

This means a lexical or functional element must be documented not only by category, but also by:
- **owner module**
- **public export path**
- **constructor origin**
- **status**
- and whether the direct local constructor pattern is actually verified in the current module context.

### 1.4 Relationship to the extension layer

The extension layer (`ExtendSqi` and companion files) is not a second core grammar. It is a controlled override area, with subsystem ownership rules already fixed elsewhere. Lexical/functional items that live there should be treated differently from core grammar items:

- core grammar lexical/functional items are canonical unless marked otherwise,
- extension-layer lexical/functional wrappers are often **compatibility-oriented**, **fallback**, or **subsystem-local**, and should not automatically be documented as the primary canonical pattern.

This distinction is especially important for:
- `ReflPossPron`
- `UseDAP*`
- shared helper functions
- local surface helpers used only because the final target is shallow

### 1.5 Architecture-vs-implementation rule for this document

This document follows the general project rule:

- architecture documents decide ownership and layering,
- current code and current compiler behavior decide concrete legality.

Therefore:
- if architecture says an element belongs in the structural layer, this document respects that ownership,
- but if a proposed concrete constructor pattern fails in the current module context, this document records the module-context failure explicitly rather than pretending the pattern is valid.

---

## 2. Ownership map for lexical and functional elements

### 2.1 Core category authority

The categories themselves are defined in `CatSqi.gf`, often backed by implementation structures in `ResSqi.gf`. This gives the basic truth about whether an item is:

- richly structured,
- table-bearing,
- agreement-bearing,
- clitic-sensitive,
- or genuinely shallow.

This is the first question before any lexical or functional addition.

### 2.2 Core producer modules

The following modules are the main owners of lexical/functional construction patterns:

- `NounSqi.gf` for determiner/noun phrase interactions and nominal category-preserving patterns
- `AdjectiveSqi.gf` for adjective-side category-preserving patterns
- `AdverbSqi.gf` for adverbials and preposition composition
- `ConjunctionSqi.gf` for list categories and conjunction behavior
- `SentenceSqi.gf`, `QuestionSqi.gf`, and `RelativeSqi.gf` for clausal/question/relative functional composition
- `NumeralSqi.gf` for numeral-support categories
- `NamesSqi.gf` for lexical name constants
- `VerbSqi.gf` / `IdiomSqi.gf` / `ConstructionSqi.gf` for some verbal and idiomatic functional inventory

### 2.3 Structural resource owners

The structural layer is the preferred owner for many closed-class items:

- `StructuralSqiClause.gf`
  - prepositions
  - subordinators
  - conjunction-like items
  - adverbs / adverbials
  - interrogative adverbs
  - comparative adverbs
  - utterance particles
  - vocatives

- `StructuralSqiNominal.gf`
  - determiner-like and nominal closed-class elements surfaced structurally

- `StructuralSqiVerbal.gf`
  - verbal-function structural items surfaced structurally

### 2.4 Public export path

For every lexical or functional element, documentation should record whether it is:

* internal-only,
* exported through `StructuralSqi.gf`,
* surfaced through `SyntaxSqi.gf`,
* intentionally absent from `ConstructorsSqi.gf`,
* visible in `TrySqi.gf`,
* or confined to the `Extend` layer.

This is important because a category may exist internally without being intended as a public constructor surface.

### 2.5 Constructor-origin rule

For every lexical or functional element, documentation should record the constructor origin as one of:

* paradigm constructor
* resource constructor
* producer-module constructor path
* direct surface wrapper
* compatibility helper
* inherited from `ExtendFunctor`
* re-export only

This prevents AI systems from drifting from canonical constructors to ad-hoc local record literals.

---

## 3. Core ownership by class

## 3.1 Pronouns and NP-like functional items

Typical owners:
- `StructuralSqiNominal.gf`
- `NounSqi.gf`
- `NamesSqi.gf`
- occasionally `ExtendSqiLexicon.gf` for extension-layer compatibility or lexical-tail additions

Rules:
- pronouns are not safe string constants unless the current category and constructor path make that explicit
- many Albanian pronouns carry more structure than their surface form suggests
- do not treat `Pron` as interchangeable with generic `NP`
- if a pronoun is exported through structural layers, that structural owner must remain the primary documentation source
- if an extension file introduces a pronoun-like wrapper, it must be documented as extension-specific and not as the canonical core pattern

### Special caution
Do not create a pronoun as `{s : Str}` only because the visible surface looks simple. Check:
- exact category,
- case behavior,
- agreement,
- clitic or person behavior if relevant,
- and whether a producer helper already exists.

## 3.2 Determiners, quantifiers, predeterminers

Typical owners:
- `StructuralSqiNominal.gf`
- `NounSqi.gf`
- `ConjunctionSqi.gf` when list or agreement interaction matters

Rules:
- determiners and quantifiers are structurally higher-risk than their surface size suggests
- do not insert them as naked strings at NP level if the grammar already expects a structured det/quant path
- if the category is surface-like in current practice, it must still be introduced through the documented producer or structural module, not by guesswork
- quantifier and predeterminer ownership must be stable; do not place the same item in multiple owner modules

## 3.3 Interrogative items

Typical owners:
- `QuestionSqi.gf`
- `StructuralSqiClause.gf`
- `StructuralSqiNominal.gf`

Rules:
- interrogative adverbs (`IAdv`) and interrogative quantifier-like items should use the matching producer or structural path
- interrogative NP/IP-like items must preserve the exact category required by the current Albanian codedump
- do not reuse a nearby declarative helper or a surface adverb helper if the target category is interrogative-specific

## 3.4 Conjunctions and subordinators

Typical owners:
- `ConjunctionSqi.gf`
- `StructuralSqiClause.gf`
- `ParadigmsSqi.gf` for paradigm constructors such as `mkConj`, `mkSubj`, `mkPConj`

Rules:
- conjunction-like categories are a major drift zone because they often look shallow
- use paradigm constructors where the current grammar already uses them
- do not assume `DConj` can be built by the same pattern that works for `Conj` or `PConj`
- list-category interaction must remain aligned with `ConjunctionSqi.gf`

## 3.5 Prepositions

Typical owners:
- `StructuralSqiClause.gf`
- `AdverbSqi.gf`
- `ResSqi.gf` via `mkPrep`

Rules:
- prepositions are not “just strings” for documentation purposes
- lexical structural prepositions should be created through `ResSqi.mkPrep`
- composition with noun phrases should follow the `PrepNP` path in `AdverbSqi.gf`
- do not document naked string fabrication as canonical just because the category looks shallow in one summary
- current compile warnings mean prepositions remain a warning-state functional zone and must stay documented as such

## 3.6 Adverbs and adverbials

Typical owners:
- `StructuralSqiClause.gf`
- `AdverbSqi.gf`
- `ParadigmsSqi.gf`

Rules:
- distinguish among `Adv`, `AdV`, `AdA`, `AdN`, and `IAdv`
- do not treat one adverb-like category as a drop-in substitute for another
- prefer producer-module or paradigm constructors
- local direct surface construction is acceptable only when the target category is truly shallow and the current module context accepts that pattern

## 3.7 Utterance particles, vocatives, comparative adverbs

Typical owners:
- `StructuralSqiClause.gf`
- `ParadigmsSqi.gf`
- current structural façade in `StructuralSqi.gf`

Rules:
- `Utt`, `Voc`, and `CAdv` may all look shallow, but they are not equivalent
- `Utt` is broadly shallow and often safe as a final local target
- `CAdv` has a verified comparative structure and should be documented as such, not collapsed to one string
- `DConj` is the warning case: surface-looking but not automatically safe for direct local `lin` fabrication
- `Voc` should prefer paradigm construction where that path exists

## 3.8 Extension-layer lexical tail

Typical owners:
- `ExtendSqiLexicon.gf`
- `ExtendSqiHelpers.gf`
- `ExtendSqiFocusPrep.gf` for a tightly limited shallow-output subsystem

Rules:
- extension-layer lexical elements should be documented as extension-specific unless the core grammar adopts them
- compatibility wrappers belong here if they are explicitly labeled and kept out of the core canonical story
- helper-driven lexical-tail wrappers must record:
  - exact input category,
  - exact output category,
  - constructor origin,
  - export surface,
  - and status

---

## 4. Current lexical/functional categories and their handling

This section summarizes the most important current categories for lexical and functional work. Detailed shape facts still belong to `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`; this section focuses on operational lexical/functional interpretation.

## 4.1 `Prep`

Current practical rule:
- define lexical structural prepositions through `ResSqi.mkPrep`
- compose with `AdverbSqi.PrepNP`
- treat prepositions as producer-owned, not as naked strings

Operational status:
- **warning-state**
- reason: current compile/audit evidence still associates preposition handling with lock-field concerns
- consequence: do not promote naive direct local fabrication as canonical

## 4.2 `Subj`, `Conj`, `PConj`

Current practical rule:
- prefer `ParadigmsSqi` constructors when the constructor already exists:
  - `mkSubj`
  - `mkConj`
  - `mkPConj`

Operational status:
- generally **stable** when using the established paradigm path
- drift risk appears when a local direct wrapper is chosen only because the item looks surface-only

## 4.3 `DConj`

Current practical rule:
- treat `DConj` as a **warning case**
- shallow documented shape is not enough
- verify constructor availability in the actual module context before documenting or coding any local direct `lin DConj { ... }` pattern

Operational status:
- **warning**
- reason: current Albanian compile evidence showed that a plausible direct construction in `StructuralSqiClause.gf` was not accepted in that resource context

Policy:
- do not elevate any `DConj` constructor pattern to canonical unless it is verified in the current module and compile state

## 4.4 `Utt`

Current practical rule:
- local shallow composition is often acceptable when the final target is genuinely `Utt`
- this does **not** remove the requirement for exact input-category discipline

Operational status:
- **conditional but broadly usable**
- reason: `Utt` is often a shallow final-output category, but helper typing still matters

## 4.5 `CAdv`

Current practical rule:
- treat comparative adverbs as structured comparative lexical items, not merely arbitrary visible strings
- keep the comparative pair or relation (`s`, `p`, or equivalent current shape) intact

Operational status:
- **conditionally stable**
- safe if the comparative category pattern already exists and is verified in structural code

## 4.6 `DAP`

Current practical rule:
- `DAP` is currently an explicit shallow category in the current Albanian codebase
- do not trust older comments that imply it is absent or implicitly defaulted
- document `UseDAP*` style wrappers as compatibility/lexical-tail constructs unless or until they are promoted into canonical core grammar paths

Operational status:
- category shape itself: **stable**
- some wrapper usage around it: **fallback / compatibility**

## 4.7 Pronoun-related categories

Current practical rule:
- do not assume that a pronoun-like lexical item can be built as a one-field string object
- verify exact category and producer path
- preserve agreement, case, and any specialized behavior if the category requires it

Operational status:
- often **rich enough to be high-risk**
- document pronoun additions carefully

---

## 5. Constructor origins for lexical/functional items

## 5.1 Paradigm constructors

Canonical when available for the correct category.

Examples already documented as relevant in the current docs bundle:
- `mkConj`
- `mkSubj`
- `mkPConj`
- `mkAdv`
- `mkVoc`

Policy:
- prefer these for structural functional items when the category matches
- do not replace them with local string wrappers merely for convenience

## 5.2 Resource constructors

Canonical when the category already has a resource-level constructor.

Example:
- `ResSqi.mkPrep`

Policy:
- use when a structural/functional category already has an Albanian resource constructor
- preferred over naked string fabrication for prepositions and related items

## 5.3 Producer-module constructor paths

Canonical when the owning Albanian module already mediates the category composition.

Examples:
- `AdverbSqi.PrepNP`
- producer paths that build adverbials or clause-level functional structures
- noun/adjective/structural producers that preserve the current category shape

Policy:
- these are often safer than local direct `lin` even when the category looks shallow
- prefer them when the module already owns the grammatical behavior

## 5.4 Direct surface wrappers

Sometimes acceptable, but only under explicit conditions.

Allowed only when:
- the target category is genuinely shallow in current Albanian use,
- the constructor pattern is accepted in the current module context,
- the item is not bypassing a safer producer/resource/paradigm constructor,
- and the docs record the pattern as verified rather than guessed.

Typical legitimate uses:
- final `Utt` surface assembly
- some comparative/adverbial local wrappers
- some extension-layer lexical tails when explicitly marked as such

## 5.5 Compatibility helpers

These are not canonical by default.

Examples:
- `UseDAP*`-style wrappers
- compatibility builders in shared extension helpers
- wrappers that surface a shallow result while depending on a richer underlying category

Policy:
- document them as **compatibility**, **fallback**, or **temporary**
- do not silently present them as the same thing as a core canonical constructor path
- do not use a compatibility helper to justify a rich-category flattening story elsewhere

## 5.6 Inherited from `ExtendFunctor`

Some lexical/functional composition can legitimately be inherited through the default `ExtendFunctor` path.

Policy:
- if inheritance already gives a compositional, category-safe result, prefer it over a local Albanian hack
- when a lexical/functional element is only surfaced locally because `ExtendFunctor` leaves it to the language, record that distinction clearly

## 5.7 Re-export only

Some lexical/functional elements are merely re-exported by façade modules such as:
- `StructuralSqi.gf`
- `SyntaxSqi.gf`
- possibly convenience/public wrapper modules

Policy:
- do not mistake a façade re-export for the original owner
- ownership stays with the producing submodule

---

## 6. Safe mechanical extension vs unsafe zones

## 6.1 Usually safe to extend mechanically

Usually safe if the exact target category and module context are verified:

* surface-shaped structural constants created through existing paradigm/resource constructors
* additional pronoun constants built through established pronoun constructor patterns
* additional `UseDAP*`-style lexical-tail wrappers, if explicitly documented as compatibility wrappers
* façade re-exports in `StructuralSqi.gf` when the subresource already owns the item
* local shallow `Utt` assembly where the inputs are exact-type-safe and the final target is truly shallow

Even here, “usually safe” still means:
- check exact category,
- check module context,
- check current compile reality if the pattern is newly introduced.

## 6.2 Unsafe or high-risk zones

High-risk zones that require extra documentation and compile verification:

* prepositions
* pronouns
* quantifiers and articles
* any category with lock fields or hidden compiled structure
* `DConj` and similar shallow-looking categories when constructor availability is unclear in the current module
* any helper reuse across nearby categories (`A` vs `AP`, `CN` vs `NP`, list-category confusions)
* extension-layer lexical wrappers that might be mistaken for canonical core grammar patterns
* any change that touches list-category behavior in `ConjunctionSqi.gf`
* any change that looks justified only because the surface item is “small”

## 6.3 Anti-drift rules for lexical and functional elements

Do not:

* create a pronoun with only `s : Str`
* create a determiner as a string hack attached at NP level
* create a preposition as a naked string if the grammar expects the established prep constructor path
* place the same functional element in multiple owner modules
* expose language-specific closed-class items through `ConstructorsSqi.gf` unless that is explicitly intended
* infer category shape from surface behavior alone
* assume that a surface-only category can always be built with `lin Cat { ... }` without checking the current module context
* reuse a helper only because its name looks relevant
* use an `A` helper for `AP`, or an `AP` helper for `A`, unless the helper is explicitly typed for both
* trust stale comments over current code and compiler output
* treat compile-time constructor/type mismatches as documentation noise; they are architecture-relevant evidence
* treat a compatibility wrapper as if it proves the core grammar category is shallow or canonical

---

## 7. Current known issues relevant to this document

### 7.1 `must_VV`

Current run logs still treat `must_VV` as incomplete, and the structural façade currently keeps it disabled.

Policy:

* keep it documented as **planned but incomplete**
* do not silently treat it as fully supported until a real Albanian implementation lands and the façade enables it again

### 7.2 Preposition lock warnings

Multiple audit runs report warnings in `StructuralSqiClause.gf` around preposition handling, including `missing lock field lock_Prep`.

Interpretation:

* prepositions are structurally richer at compile time than a naive `{s : Str}` reading suggests
* documentation must treat prepositions as a warning-state functional zone, not as fully trivial string items
* future cleanup should regularize prep constructors so the expected shape is preserved without warnings

### 7.3 Constructor-availability mismatch risk

A current Albanian failure mode is:

* the documented lincat looks surface-only,
* but a chosen constructor or `lin Cat { ... }` pattern is not actually valid in the current module context.

Named example:

* `StructuralSqiClause.gf`
* `mkDConj : Str -> DConj = \s -> lin DConj {s = s}`
* compile failure: `constant not found: DConj` in that resource context

Documentation rule:

* “surface-only category” does **not** mean “any surface-style constructor works everywhere”

### 7.4 Exact helper-type mismatch risk

Another current Albanian failure mode is helper mismatch by family resemblance rather than exact type.

Named example:

* `adjSurfaceNomMascSg : A -> Str`
* `apSurfaceNomMascSg : AP -> Str`
* current `fp_FocusAP` used the `A` helper on an `AP`, which is not exact-category-safe and is reflected in compile diagnostics around `ExtendSqiFocusPrep.gf` / `ExtendSqi.gf`

Policy:

* helper reuse must match exact category
* if exact-type match is missing, the implementation remains provisional or wrong

### 7.5 Stale comment risk

The current codedump contains at least one stale explanatory comment: `ConjunctionSqi.gf` still says `DAP` is not defined in `CatSqi`, even though the current `CatSqi.gf` snapshot explicitly defines `DAP = {s : Str}`.

Policy:

* comments are secondary evidence only
* if comment, code, and compiler evidence disagree, update the comment/doc; do not “fix” code to match the stale comment

### 7.6 Compatibility-wrapper drift risk

Some extension-layer lexical wrappers are useful, but they are not proof that the underlying category is canonically constructed that way.

Policy:

* document wrapper status explicitly
* distinguish core canonical producer patterns from extension-layer fallback wrappers
* do not let a compatibility helper become the unmarked default explanation in later docs

---

## 8. Documentation obligations for future additions

Whenever a new lexical or functional element is added, the implementation must record:

* exact category
* owner module
* public export path
* constructor origin
* whether the constructor pattern is verified in the current module context
* whether any helper used is exact-type verified
* whether it is surfaced in `SyntaxSqi` / `ConstructorsSqi` / `TrySqi`
* whether it has any special case, clitic, definiteness, agreement, or lock-field behavior
* whether the implementation is canonical, fallback, temporary, warning-state, or incomplete

If any of that information is missing, the documentation remains incomplete and AI coding should treat the item as provisional.

### 8.1 Ownership obligation
Every lexical or functional item must have one clearly recorded owner module.

### 8.2 Export obligation
If the item is publicly surfaced, the public export path must be recorded.

### 8.3 Constructor obligation
The constructor origin must be named explicitly, not implied from visible code shape.

### 8.4 Status obligation
Every drift-prone or warning-prone item must carry a status.

### 8.5 Support-doc obligation
If the item belongs to a high-risk class, its support-doc entries should also be updated:
- helper registry
- shallow-category constructor matrix
- symbol status ledger
- stale comment tracker
- module extraction coverage
where applicable

---

## 9. Minimal checklist for AI coding agents

Before adding or editing a lexical or functional element, check:

1. What is the exact category in `CatSqi.gf`?
2. Is that category surface-only, or does it carry tables, agreement, clitic fields, or lock fields?
3. Which structural or extension submodule owns this class of element?
4. Is there already a helper constructor in `ParadigmsSqi`, `ResSqi`, or a producer module?
5. Does that helper match the exact input and output categories needed here?
6. Is the intended constructor pattern actually evidenced in the current Albanian codedump?
7. Is the chosen constructor available and accepted in the current module context?
8. Should the item be exported publicly through `StructuralSqi.gf`?
9. Should it appear in `SyntaxSqi` or be intentionally hidden from `ConstructorsSqi`?
10. Does the item interact with case, definiteness, clitics, agreement, or lock fields?
11. Is there already a nearby Albanian pattern in the codedump that should be copied exactly?
12. Do current compile logs show any warning or failure pattern relevant to this category?
13. Is the item canonical, compatibility-only, fallback, temporary, warning-state, or incomplete?
14. Does any related support doc need synchronized update?

Decision rule:

* if questions 5, 6, or 7 are unanswered, do not finalize the implementation from documentation alone
* re-check the current codedump and compile evidence first

---

## 10. Machine-readable inventory schema

This document should be maintained so it can support a machine-readable table with one row per lexical or functional element.

Recommended columns:

* `name`
* `category`
* `owner_module`
* `public_export_path`
* `constructor_origin`
* `constructor_pattern_verified_in_current_module_context` (`yes` / `no`)
* `helper_exact_type_verified` (`yes` / `no` / `not_applicable`)
* `surface_form`
* `morphosyntactic_notes`
* `status` (`stable`, `warning`, `incomplete`, `fallback`, `temporary`)
* `comment_staleness_risk` (`yes` / `no`)
* `compile_notes`

This table is especially important for:

* prepositions
* `DConj`
* `DAP`
* pronouns
* quantifiers / determiners
* `UseDAP*`
* `must_VV`
* any element created through compatibility helpers rather than core canonical constructors

### 10.1 Relationship to support docs

This document should stay synchronized with:

* `ALBANIAN_HELPER_REGISTRY.md`
* `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
* `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
* `ALBANIAN_STALE_COMMENT_TRACKER.md`
* `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`

These do not replace this document. They specialize parts of it.

---

## 11. Recommended cross-links

Read this document together with:

* `ALBANIAN_LANGUAGE_ARCHITECTURE.md`
* `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
* `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
* `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
* `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
* `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
* `ALBANIAN_MODULE_DEPENDENCY_MAP.md`
* `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`
* `ALBANIAN_DECISION_LOG.md`

This document is the lexical/functional inventory companion to those broader architecture, category, constructor, and anti-drift documents.

### 11.1 Especially close companions

Use these together most often:

* `ALBANIAN_HELPER_REGISTRY.md`
  - when the question is “which helper is exact-type-safe here?”

* `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
  - when the question is “does shallow shape actually license this constructor in this module?”

* `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
  - when the question is “is this item stable, warning-state, or blocked?”

* `ALBANIAN_STALE_COMMENT_TRACKER.md`
  - when the question is “can I trust this explanation/comment?”

---

## 12. Recommended reading order for maintainers and AI systems

To work safely with lexical and functional elements in Albanian, read in this order:

1. `CatSqi.gf` for current category shapes
2. `ResSqi.gf` for shared resource-level implementation types
3. the owning producer or structural module:
   * `StructuralSqiClause.gf`
   * `StructuralSqiNominal.gf`
   * `StructuralSqiVerbal.gf`
   * `ConjunctionSqi.gf`
   * `AdverbSqi.gf`
   * `NounSqi.gf`
   * `QuestionSqi.gf`
   * `SentenceSqi.gf`
   * `NamesSqi.gf`
   * `ExtendSqiLexicon.gf`
   as appropriate
4. `SyntaxSqi.gf` for public composition
5. `ConstructorsSqi.gf` / `TrySqi.gf` for façade visibility only
6. current compile/audit evidence if the item is warning-state or under repair
7. then this document and the linked anti-drift/support docs together

This order follows the current project-wide source-precedence rule.

---

## 13. Compact operational summary

The lexical/functional story in the current Albanian grammar is:

- ownership matters,
- category shape matters,
- constructor origin matters,
- module context matters,
- helper exact type matters,
- export path matters,
- and status matters.

So the safe default is:

1. identify the exact category,
2. identify the owner module,
3. identify the canonical constructor origin,
4. verify constructor availability in the current module,
5. verify exact helper compatibility,
6. check status and compile evidence,
7. only then code or document the element.

Anything less risks drift.