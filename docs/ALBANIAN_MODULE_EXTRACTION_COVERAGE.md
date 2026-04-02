# ALBANIAN_MODULE_EXTRACTION_COVERAGE

## Status

Authoritative documentation-planning file for the Albanian GF grammar.

This document tracks **which Albanian modules have already been extracted into the language-wide documentation set**, which are only partially documented, which are still pending targeted extraction, and which are intentionally thin/support modules that do not require the same level of narrative coverage.

It is not a repair log.
It is not a compile-status file.
It is a **documentation coverage map**.

Its purpose is to prevent AI systems and maintainers from overestimating what is already documented, underestimating which modules still require explicit extraction, or re-auditing the full source dump when the documentation set should already answer the question.

---

## 1. Purpose

The Albanian documentation suite is now strong on architecture, category shape, override policy, anti-drift rules, and `ExtendSqi` subsystem planning. However, the open design-debt notes explicitly identified an unresolved question: **which Albanian modules are still missing extraction into the language-wide documentation set**. This file closes that gap by turning the remaining uncertainty into an explicit coverage inventory.

The goal is to make it possible to answer, for any Albanian module:

* whether it is already documented deeply enough for safe coding,
* whether it is only covered at an architectural or dependency level,
* whether it still needs targeted extraction,
* what kind of extraction it still needs,
* and what priority that extraction has.

The closure criterion already proposed in the design-debt notes is kept here as the governing standard:

> the module dependency map and category reference must be complete enough to support coding without re-auditing the whole dump.

---

## 2. Scope

This document covers:

* the current Albanian source tree under `GF/lib/src/albanian`
* the visible root-level Albanian resources such as `SyntaxSqi`, `ConstructorsSqi`, `TrySqi`, and related entry points
* the current Albanian documentation bundle
* the current architectural/dependency classification already established in the Albanian architecture and dependency-map docs.

This document does **not** attempt to restate the entire content of:

* `ALBANIAN_LANGUAGE_ARCHITECTURE.md`
* `ALBANIAN_MODULE_DEPENDENCY_MAP.md`
* `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
* `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`

Instead, it records whether those documents already cover each module strongly enough.

---

## 3. Reading model

Each module receives a **documentation coverage status**.

### 3.1 Coverage statuses

**COVERED_IN_DEPTH**
The module is documented deeply enough that an AI or maintainer can usually work on it without re-reading the full source dump, because the documentation bundle already captures:

* its role,
* its main category shapes or constructor responsibilities,
* its main safe constructor patterns,
* and its main drift risks.

**COVERED_STRUCTURALLY**
The module is documented at the architecture/dependency/ownership level, but not yet extracted deeply enough for category- or constructor-level work. The docs usually tell you where the module sits and why it exists, but not all of the detailed implementation patterns.

**PARTIALLY_EXTRACTED**
The module has meaningful documentation coverage, but still lacks some critical details required for safe editing. A maintainer can orient quickly, but not finish non-trivial work safely without checking the source dump.

**PENDING_TARGETED_EXTRACTION**
The module is explicitly or effectively still under-extracted. It should receive a dedicated extraction pass because current docs are not yet enough to support reliable editing without re-auditing source.

**THIN_WRAPPER / LOW_EXTRACTION_PRIORITY**
The module is intentionally thin, aggregating, support-oriented, or low-surface-area. It still needs to be named and classified, but it does not need the same level of deep narrative extraction as the richer syntax/resource modules.

**OUT_OF_SCOPE_SUPPORT**
The module is support/test/tooling material. It should be indexed and named, but it is not a priority for language-wide grammatical extraction.

### 3.2 Important distinction

Coverage status is **not** the same thing as compile maturity.

A module can be:

* well extracted in documentation but still implementation-fragile,
* or lightly extracted in documentation but implementation-stable because it is thin.

This document tracks **documentation completeness**, not only compile health. The architecture docs already distinguish between stable core modules, fallback/simplified areas, and active override zones; this coverage file complements that by asking whether the docs themselves are strong enough.

---

## 4. Current closure standard

This document is “done” only when all of the following hold:

1. every Albanian module in the visible source tree is explicitly classified here,
2. every high-impact grammar module is at least `COVERED_STRUCTURALLY`,
3. every category-critical or constructor-critical module is either `COVERED_IN_DEPTH` or assigned a concrete extraction task,
4. the current set of `PENDING_TARGETED_EXTRACTION` modules is small and deliberate,
5. the documentation bundle is strong enough that ordinary coding no longer requires re-auditing the entire source dump for basic module orientation.

---

## 5. Coverage inventory by layer

## 5.1 Base resources and category definitions

These modules form the structural floor of the Albanian grammar. The architecture and category-reference docs already treat `ResSqi` and `CatSqi` as central sources of truth, while `MorphoSqi` and `ParadigmsSqi` are recognized as the morphology/pattern layers above them.

### `albanian/ResSqi.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** already treated as foundational in architecture, category, dependency, and lexical/functional documentation. Shared internal types and low-level constructor vocabulary are already explicit in the documentation set.

### `albanian/CatSqi.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** already treated as category authority, with explicit lincat shape coverage and central role in anti-drift reasoning.

### `albanian/MorphoSqi.gf`

**Coverage:** `PARTIALLY_EXTRACTED`
**Why:** the architecture docs recognize it as the largest Albanian module and as the morphology realization layer, but the current bundle does not yet extract it in the same detailed way as `ResSqi`/`CatSqi`. A future focused extraction should document which parts of `MorphoSqi` are operationally relevant to coding outside morphology itself.

### `albanian/ParadigmsSqi.gf`

**Coverage:** `PARTIALLY_EXTRACTED`
**Why:** architecture and dependency docs recognize it as the lexical-pattern layer, and many modules depend on it, but the language-wide docs do not yet fully classify its paradigm families by grammatical area. It needs more explicit extraction of the high-value constructor patterns used in public or structural modules.

---

## 5.2 Core concrete syntax modules

The architecture docs already define the core grammar center as `GrammarSqi` plus modules such as `NounSqi`, `AdjectiveSqi`, `VerbSqi`, `SentenceSqi`, `QuestionSqi`, `RelativeSqi`, `ConjunctionSqi`, `PhraseSqi`, `IdiomSqi`, and `TextSqi`. The open design-debt notes specifically identified a subset of these as still likely missing full extraction.

### `albanian/NounSqi.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** repeatedly used in architecture, category, syntax, and pattern discussions as a primary source of nominal constructor patterns. It is one of the clearest documented core modules.

### `albanian/AdjectiveSqi.gf`

**Coverage:** `PENDING_TARGETED_EXTRACTION`
**Why:** explicitly named in the design-debt/open-question list as a likely still-under-extracted module. It is clearly architecturally important, but the current docs still do not appear to document its full constructor and agreement-preservation patterns at the same depth as `NounSqi`.

### `albanian/VerbSqi.gf`

**Coverage:** `PENDING_TARGETED_EXTRACTION`
**Why:** explicitly named in the still-missing-extraction list. Architecture coverage exists, but not enough detailed extraction to make it a no-re-audit coding target.

### `albanian/SentenceSqi.gf`

**Coverage:** `PENDING_TARGETED_EXTRACTION`
**Why:** explicitly named in the still-missing-extraction list. Important because it mediates clause/sentence assembly and interacts with Albanian’s stringy higher categories.

### `albanian/QuestionSqi.gf`

**Coverage:** `PENDING_TARGETED_EXTRACTION`
**Why:** explicitly named in the still-missing-extraction list. Important because current documentation often references clause/question simplification but does not yet fully extract the question module itself.

### `albanian/RelativeSqi.gf`

**Coverage:** `PENDING_TARGETED_EXTRACTION`
**Why:** explicitly named in the still-missing-extraction list. It should receive a focused extraction because it sits near rich/string boundary behavior and subordinate attachment patterns.

### `albanian/ConjunctionSqi.gf`

**Coverage:** `PENDING_TARGETED_EXTRACTION`
**Why:** explicitly named in the still-missing-extraction list. This module is especially important because list categories, coordination, and items like `DConj` have already proven to be drift-prone.

### `albanian/PhraseSqi.gf`

**Coverage:** `PENDING_TARGETED_EXTRACTION`
**Why:** explicitly named in the still-missing-extraction list. It is structurally thin, but still important because utterance assembly and outer-layer packaging are easy places for AI systems to overgeneralize from simplified categories.

### `albanian/AdverbSqi.gf`

**Coverage:** `PARTIALLY_EXTRACTED`
**Why:** this module already appears in architecture, category/reference, and lexical/functional reasoning, especially around prepositions and adverbial behavior, but it is not yet fully extracted as a standalone constructor/producer document.

### `albanian/NumeralSqi.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** the dependency and architecture docs place it correctly in the core grammar, but the docs do not yet give it the same pattern-level extraction depth as noun/adjective work.

### `albanian/IdiomSqi.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** the architecture docs recognize it as a core module and also warn that it may contain useful fallbacks that should not be mistaken for architectural gold standards. That is good architectural coverage, but not yet full pattern extraction.

### `albanian/ConstructionSqi.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** recognized as a useful fallback-bearing module, but not yet extracted deeply as a primary constructor source. It matters, but it is not yet documented at a pattern-by-pattern level.

### `albanian/TextSqi.gf`

**Coverage:** `THIN_WRAPPER / LOW_EXTRACTION_PRIORITY`
**Why:** the architecture docs already characterize `TextSqi` as minimal punctuation/text composition, which is enough for current orientation.

### `albanian/DocumentationSqi.gf`

**Coverage:** `THIN_WRAPPER / LOW_EXTRACTION_PRIORITY`
**Why:** important as support, but not a primary grammatical extraction target for anti-drift coding work. It belongs in the module map, but not in the first wave of deep extraction. The architecture/dependency docs already place it appropriately.

---

## 5.3 Structural vocabulary resources

The dependency docs already define a structural path:
`ResSqi/CatSqi -> StructuralSqiRes / StructuralSqiNominal / StructuralSqiVerbal / StructuralSqiClause -> StructuralSqi -> SyntaxSqi`. That path is already good architecture coverage, but the individual structural submodules are not yet uniformly extracted to the same depth.

### `albanian/StructuralSqiRes.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** placed correctly in the dependency map, but not yet deeply extracted as its own pattern document.

### `albanian/StructuralSqiNominal.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** structurally mapped and tied into the nominal structural path, but still not deeply extracted module-by-module.

### `albanian/StructuralSqiVerbal.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** structurally mapped and tied into the verbal structural path, but still not yet extracted deeply in the documentation suite.

### `albanian/StructuralSqiClause.gf`

**Coverage:** `PARTIALLY_EXTRACTED`
**Why:** it now has much better documentation coverage because the recent `DConj`/constructor-availability lesson forced explicit treatment of clause-level structural items. But that does not yet mean the whole module is fully extracted. It still deserves a focused future pass because it is a known high-risk structural-functional zone.

### `albanian/StructuralSqi.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** the docs clearly identify it as a structural aggregator/join point, which is enough for its architectural role. It does not need deep extraction equal to a rich producer module, but it should continue to be documented as a thin aggregator.

---

## 5.4 Extension and override layer

The `ExtendSqi` layer is one of the best-covered parts of the current docs bundle. It has dedicated architecture, target, matrix, and subsystem documents, and the current source tree shows the companion split already exists. This is one of the clearest examples of “covered in depth” at the documentation level even though implementation work remains active.

### `albanian/ExtendSqi.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** governed by dedicated architecture, final-target, override-matrix, and policy docs.

### `albanian/ExtendSqiScaffolding.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** explicitly sequenced and owned in the `ExtendSqi` architecture docs.

### `albanian/ExtendSqiHelpers.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** helper policy and helper naming are already central in the `ExtendSqi` control docs, even though a future global helper registry is still recommended.

### `albanian/ExtendSqiAPCN.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** explicitly owned by the APCN subsystem docs and override matrix.

### `albanian/ExtendSqiExistential.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** explicitly owned by the existential subsystem docs and override matrix.

### `albanian/ExtendSqiVPBridge.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** explicitly owned by the VP-bridge subsystem docs and override matrix.

### `albanian/ExtendSqiRNP.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** explicitly governed as a coherent family and one of the most documented risky override areas.

### `albanian/ExtendSqiFocusPrep.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** explicitly owned by the focus/preposition subsystem docs and already used as one of the key anti-drift lessons.

### `albanian/ExtendSqiLexicon.gf`

**Coverage:** `COVERED_IN_DEPTH`
**Why:** explicitly assigned to the lexical tail in the `ExtendSqi` architecture docs.

### `albanian/ExtraSqi.gf`

**Coverage:** `PARTIALLY_EXTRACTED`
**Why:** it is already recognized in architecture and source anchors as a shared extension module, but it still deserves more explicit extraction because it participates in high-risk extension/support behavior outside the core grammar.

### `albanian/ExtraSqiAbs.gf`

**Coverage:** `THIN_WRAPPER / LOW_EXTRACTION_PRIORITY`
**Why:** small abstract-support companion; should remain indexed but does not need a deep standalone grammar narrative. 

---

## 5.5 Aggregators and exposed language modules

These modules are already placed clearly in the architecture docs and module graph. Their extraction burden is lighter because most of them aggregate other modules rather than define rich new behavior.

### `albanian/GrammarSqi.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** architecture and dependency docs already explain its role as the stable core grammar aggregator.

### `albanian/LangSqi.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** clearly placed as the exposed language wrapper over `GrammarSqi` and `LexiconSqi`.

### `albanian/AllSqi.gf`

**Coverage:** `THIN_WRAPPER / LOW_EXTRACTION_PRIORITY`
**Why:** aggregation/package surface only. Indexing and architecture placement are enough. 

### `albanian/AllSqiAbs.gf`

**Coverage:** `THIN_WRAPPER / LOW_EXTRACTION_PRIORITY`
**Why:** abstract/support package layer only. 

---

## 5.6 API wrappers and user-facing convenience layers

The architecture docs already say that `SyntaxSqi` is the practical public API and that user-facing work should prefer its constructor surface over direct low-level record rebuilding. That is strong architectural coverage, but not all wrapper modules need equally deep extraction.

### `SyntaxSqi.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** very well positioned in architecture docs as the practical API layer. A deeper constructor-by-constructor extraction would still be useful later, but current architectural extraction is already strong.

### `ConstructorsSqi.gf`

**Coverage:** `THIN_WRAPPER / LOW_EXTRACTION_PRIORITY`
**Why:** thin constructor packaging layer; should be indexed and named, but does not need the same narrative depth as core grammar modules.

### `TrySqi.gf`

**Coverage:** `THIN_WRAPPER / LOW_EXTRACTION_PRIORITY`
**Why:** convenience/testing wrapper; architecture placement is enough for now.

### `SymbolicSqi.gf`

**Coverage:** `THIN_WRAPPER / LOW_EXTRACTION_PRIORITY`
**Why:** symbolic/packaging wrapper, not a high-priority grammatical extraction target. 

---

## 5.7 Lexical/support/test/tooling modules

These modules still belong in the coverage map, but most are not immediate first-wave extraction priorities unless they become relevant to a specific debugging or extension task. Their role is mostly support, lexical packaging, or testing.

### `albanian/LexiconSqi.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** clear role in top-level packaging and dependency graph, but not yet a deep extraction target.

### `albanian/NamesSqi.gf`

**Coverage:** `THIN_WRAPPER / LOW_EXTRACTION_PRIORITY`
**Why:** lexical support module with limited structural burden. 

### `albanian/IrregSqi.gf`

**Coverage:** `THIN_WRAPPER / LOW_EXTRACTION_PRIORITY`
**Why:** small irregular-lexical support module. 

### `albanian/SymbolSqi.gf`

**Coverage:** `COVERED_STRUCTURALLY`
**Why:** dependency-map coverage exists, but not yet a deep grammar extraction target.

### `albanian/TestAbs.gf`

**Coverage:** `OUT_OF_SCOPE_SUPPORT`
**Why:** test-only support. 

### `albanian/TestSqi.gf`

**Coverage:** `OUT_OF_SCOPE_SUPPORT`
**Why:** test-only support. 

### `albanian/gf_dryrun_patch.py`

**Coverage:** `OUT_OF_SCOPE_SUPPORT`
**Why:** tooling support, not a grammar module. 

---

## 6. Recommended immediate extraction targets

The following modules should be treated as the **first remaining wave** of targeted language-wide extraction:

1. `albanian/AdjectiveSqi.gf`
2. `albanian/VerbSqi.gf`
3. `albanian/SentenceSqi.gf`
4. `albanian/QuestionSqi.gf`
5. `albanian/RelativeSqi.gf`
6. `albanian/ConjunctionSqi.gf`
7. `albanian/PhraseSqi.gf`

These are not random. They are exactly the set already identified as still-likely-missing extraction candidates in the documentation debt notes.

### Why these first

* They belong to the stable core grammar center, not just the extension layer.
* They carry important category or constructor behavior that AI systems are likely to misuse if only architectural summaries are available.
* Several of them sit close to the rich-vs-string boundary that is already known to be one of Albanian’s main drift sources.

---

## 7. Second-wave extraction targets

After the seven explicit pending modules above, the next extraction wave should focus on modules that are already partially or structurally covered but still lack deep implementation guidance:

* `albanian/MorphoSqi.gf`
* `albanian/ParadigmsSqi.gf`
* `albanian/AdverbSqi.gf`
* `albanian/NumeralSqi.gf`
* `albanian/IdiomSqi.gf`
* `albanian/ConstructionSqi.gf`
* `albanian/StructuralSqiRes.gf`
* `albanian/StructuralSqiNominal.gf`
* `albanian/StructuralSqiVerbal.gf`
* `albanian/StructuralSqiClause.gf`
* `albanian/ExtraSqi.gf`
* `SyntaxSqi.gf` (deeper constructor-surface extraction, not just architecture coverage)

These are the modules most likely to improve the documentation set’s ability to support coding without full source re-audit once the first wave is done.

---

## 8. What each extraction pass must include

A future extraction pass for any `PENDING_TARGETED_EXTRACTION` or `PARTIALLY_EXTRACTED` module must record at least:

1. **Role**

   * why the module exists,
   * which layer it belongs to.

2. **Dependencies**

   * what it opens/imports,
   * what it depends on structurally.

3. **Key category responsibilities**

   * which categories it produces or transforms,
   * whether those categories are rich or shallow.

4. **Preferred constructor paths**

   * inherited/default path,
   * Albanian-native producer path,
   * any known verified local constructor forms.

5. **Drift risks**

   * flattening risk,
   * helper-type confusion risk,
   * module-context constructor risk,
   * stale-comment risk if relevant.

6. **Representative examples**

   * at least one safe pattern,
   * at least one anti-pattern if the module is drift-prone.

7. **Maturity status**

   * stable core,
   * simplified/fallback,
   * active override,
   * warning-state,
   * or support-only.

These requirements follow directly from the newer constructor, override, and anti-drift docs: documentation must support coding decisions at the level of exact category and constructor discipline, not only module naming.

---

## 9. Relationship to the existing documentation suite

This file does not replace the existing docs. It sits above them as a coverage control file.

Use it with these roles:

* `ALBANIAN_LANGUAGE_ARCHITECTURE.md`
  tells you where a module sits in the system.

* `ALBANIAN_MODULE_DEPENDENCY_MAP.md`
  tells you what depends on what. 

* `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
  tells you the actual current category shapes and the shape/construction cautions. 

* `ALBANIAN_IMPLEMENTATION_PATTERNS.md` and `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
  tell you how to implement without drifting.

* `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
  covers function-word and helper-heavy zones that often cut across modules.

* `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
  tells you how to resolve override vs inheritance questions once a module is documented enough to reason concretely. 

This file answers a different question:
**is the module already documented deeply enough, or does it still need extraction work?**

---

## 10. Current recommended summary

### Already well extracted

* `albanian/ResSqi.gf`
* `albanian/CatSqi.gf`
* `albanian/NounSqi.gf`
* `albanian/ExtendSqi.gf`
* `albanian/ExtendSqiScaffolding.gf`
* `albanian/ExtendSqiHelpers.gf`
* `albanian/ExtendSqiAPCN.gf`
* `albanian/ExtendSqiExistential.gf`
* `albanian/ExtendSqiVPBridge.gf`
* `albanian/ExtendSqiRNP.gf`
* `albanian/ExtendSqiFocusPrep.gf`
* `albanian/ExtendSqiLexicon.gf`

### Still need targeted extraction

* `albanian/AdjectiveSqi.gf`
* `albanian/VerbSqi.gf`
* `albanian/SentenceSqi.gf`
* `albanian/QuestionSqi.gf`
* `albanian/RelativeSqi.gf`
* `albanian/ConjunctionSqi.gf`
* `albanian/PhraseSqi.gf`

### Next-tier partials to strengthen after that

* `albanian/MorphoSqi.gf`
* `albanian/ParadigmsSqi.gf`
* `albanian/AdverbSqi.gf`
* `albanian/NumeralSqi.gf`
* `albanian/IdiomSqi.gf`
* `albanian/ConstructionSqi.gf`
* `albanian/StructuralSqiRes.gf`
* `albanian/StructuralSqiNominal.gf`
* `albanian/StructuralSqiVerbal.gf`
* `albanian/StructuralSqiClause.gf`
* `albanian/ExtraSqi.gf`
* `SyntaxSqi.gf`

### Thin/support modules that should remain indexed but do not need first-wave deep extraction

* `albanian/TextSqi.gf`
* `albanian/DocumentationSqi.gf`
* `albanian/GrammarSqi.gf`
* `albanian/LangSqi.gf`
* `albanian/AllSqi.gf`
* `albanian/AllSqiAbs.gf`
* `ConstructorsSqi.gf`
* `TrySqi.gf`
* `SymbolicSqi.gf`
* `albanian/LexiconSqi.gf`
* `albanian/NamesSqi.gf`
* `albanian/IrregSqi.gf`
* `albanian/SymbolSqi.gf`
* `albanian/TestAbs.gf`
* `albanian/TestSqi.gf`
* `albanian/gf_dryrun_patch.py`

---

## 11. Maintenance rule

Whenever a previously `PENDING_TARGETED_EXTRACTION` or `PARTIALLY_EXTRACTED` module gets a dedicated language-wide documentation pass, this file must be updated:

* change the coverage status,
* note which document now carries the deep extraction,
* and remove the module from the open extraction queue if appropriate.

If a module is promoted to `COVERED_IN_DEPTH`, that promotion must be justified by real documentation content, not just by a chat conclusion.

---

## 12. Final closure target

This file reaches its intended final state when:

* no core grammar module remains undocumented at the “pending targeted extraction” level,
* structural and lexical-functional cross-cutting modules are at least `PARTIALLY_EXTRACTED`,
* the documentation bundle is strong enough that future Albanian coding work can usually begin from docs plus exact targeted source lookup rather than from a whole-tree re-audit,
* and the original open question “which Albanian modules are still missing extraction into the language-wide documentation set?” no longer needs to be asked as an unresolved design-debt item.

