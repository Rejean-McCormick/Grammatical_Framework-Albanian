# ALBANIAN_LANGUAGE_ARCHITECTURE

## Purpose

This document describes the architectural structure of the Albanian GF resource grammar in the uploaded code snapshot. It is intended to be the top-level map for how the Albanian concrete syntax is organized, which modules define core category shapes, which modules build syntax compositionally, which modules are best treated as higher-risk override zones, and how new work should align with the existing grammar rather than drift into ad-hoc local rewrites.

## Scope

The architecture described here is based on the uploaded Albanian source dump under `GF/lib/src/albanian`, together with the visible root-level resources `SyntaxSqi`, `ConstructorsSqi`, `TrySqi`, and the current extension/debugging context around `ExtendSqi`. It also uses `ExtendFunctor.gf`, `Extend.gf`, and the Bulgarian/German reference materials only as architectural comparison points, not as primary sources for Albanian facts.

## 1. Top-level system shape

The Albanian grammar follows the standard RGL layering pattern: the usable language entry points sit at the top (`LangSqi`, `GrammarSqi`, `SyntaxSqi`, `ConstructorsSqi`, `TrySqi`), while the concrete syntactic work is distributed across the core category modules such as `NounSqi`, `AdjectiveSqi`, `VerbSqi`, `SentenceSqi`, `QuestionSqi`, `RelativeSqi`, `ConjunctionSqi`, `PhraseSqi`, `IdiomSqi`, `TextSqi`, and the language-specific resource module `ResSqi`. The dump’s file index shows this whole module set under `albanian/`, and `GrammarSqi` explicitly composes the main syntactic modules into the language grammar. fileciteturn55file0 fileciteturn56file1

At the API layer, `SyntaxSqi` opens `CatSqi`, `ResSqi`, `NounSqi`, `AdjectiveSqi`, `PhraseSqi`, and `StructuralSqi`, then exposes convenience constructors such as `mkCN`, `mkAP`, `mkDet`, `mkNP`, `mkUtt`, and `mkPhr`. That means the practical programming surface for Albanian is intentionally narrower than the full module graph: most user-facing composition should go through `SyntaxSqi`, not by directly rebuilding records from scratch. fileciteturn55file0

## 2. Architectural layers

### 2.1 Resource and parameter layer

`ResSqi` is the foundational language resource. `CatSqi` opens `ResSqi`, and most syntactic modules open it as well. In the current architecture, `ResSqi` is where Albanian-specific shared types and operations live: inflectional parameters, agreement machinery, noun/adjective/verb record structures, complements/prepositions, and support operations such as linking clitics and lexical constructors. The architecture should therefore treat `ResSqi` as the central source of truth for low-level Albanian shape decisions. fileciteturn55file1

`MorphoSqi` and `ParadigmsSqi` sit just above this layer. The dump shows `MorphoSqi.gf` as by far the largest Albanian module and `ParadigmsSqi.gf` as the lexical-pattern layer; both compile independently in the audit logs. The intended architecture is therefore: `ResSqi` defines the shared record and parameter vocabulary, `MorphoSqi` realizes the morphological system, and `ParadigmsSqi` packages recurring lexical constructors for practical use. fileciteturn55file1 fileciteturn57file5turn57file8turn57file9

### 2.2 Category layer

`CatSqi` is the architectural hinge between the abstract RGL categories and Albanian concrete representations. It defines which categories are rich inflectional records and which are intentionally simplified `{s : Str}` records. In the current snapshot, `CN` is `Noun`, `AP` is a four-dimensional agreement table over `Species`, `Case`, `Gender`, and `Number`, `NP` is `{s : Case => Str; a : Agr}`, `Pron` carries both case forms and clitic forms, `Prep = Compl`, and many clause-level or phrase-level categories are simplified to `{s : Str}`. This division is the single most important architectural fact about the language. fileciteturn55file1

Because `CatSqi` makes some categories rich and others stringy, Albanian code must preserve category shape exactly. A `CN` or `AP` implementation is not just a string; a `Cl`, `S`, or `VP` often is. This asymmetry is intentional and should be documented as a language-wide rule, because many later bugs in `ExtendSqi` arise precisely when rich categories are accidentally flattened to strings or rebuilt with partial records. fileciteturn55file1

### 2.3 Core syntax layer

The core Albanian syntax is assembled in `GrammarSqi`, which combines `NounSqi`, `AdjectiveSqi`, `NumeralSqi`, `VerbSqi`, `SentenceSqi`, `QuestionSqi`, `RelativeSqi`, `ConjunctionSqi`, `IdiomSqi`, `TextSqi`, and `PhraseSqi`. This means the stable architectural center of the language is not `ExtendSqi`; it is `GrammarSqi` plus these core modules. `ExtendSqi` is an additional override layer on top of that core, not the foundation. fileciteturn56file1

Inside that core layer, modules divide roughly by grammatical domain: `NounSqi` handles determiners, noun phrases, and adjectival modification of common nouns; `AdjectiveSqi` handles adjective phrases and A2 complements; `VerbSqi` handles verbal predication and verbal complements; `SentenceSqi` handles clause-to-sentence assembly; `ConjunctionSqi` handles list categories and coordination; `IdiomSqi` packages existential and cleft-like idioms; and `PhraseSqi`/`TextSqi` handle utterance and text assembly. This distribution is visible both in module names and in the concrete definitions shown in the dump. fileciteturn55file1turn56file1

### 2.4 Extension and debugging layer

`ExtendSqi` is an override-heavy module instantiated as `CatSqi ** ExtendFunctor - [...] with (Grammar = GrammarSqi)`. Architecturally, that means Albanian extension work starts from the inherited default implementations in `ExtendFunctor` and then replaces selected families. This is a different layer from the core grammar: it should be treated as a controlled override surface, not as a place to redefine category theory. fileciteturn55file1turn58file1turn58file9

The German reference confirms this architectural reading. `ExtendGer` also starts from `CatGer ** ExtendFunctor - [...]` and then removes families of default implementations in coordinated blocks, such as `RNP`, `RNPList`, and related reflexive functions. The architectural lesson is not “copy German fields,” but “override by subsystem, not by isolated function.” fileciteturn58file2

## 3. Core data model

### 3.1 Nouns and noun phrases

In Albanian, `CN = Noun`, and `Noun` is used throughout the grammar as a non-flat nominal record. `NounSqi` shows the intended usage: `DetCN` combines a determiner and a noun by reading `det.s ! c ! cn.g` and `cn.s ! det.spec ! c ! det.n`, while `AdjCN` preserves the noun table and noun gender and adds the AP after the noun string. This means the architectural center of nominal syntax is the `CN/Noun` table, not `NP`. fileciteturn54file0 fileciteturn55file1

`NP` is structurally lighter than `CN`: it contains a case-indexed string and agreement record, and it is what sentence and verbal modules usually consume. The architecture therefore has a consistent noun pipeline: lexical noun or noun-like material builds `CN`; determination converts `CN` to `NP`; sentential modules consume `NP`. `SyntaxSqi` encodes this same pipeline in its convenience API. fileciteturn55file0turn55file1

### 3.2 Adjectives and adjective phrases

`AP` is a rich agreement table over `Species`, `Case`, `Gender`, and `Number`. `AdjectiveSqi` shows the expected architecture: `PositA`, `ComparA`, `ComplA2`, `AdAP`, `AdvAP`, `CAdvAP`, and `SentAP` all preserve full AP shape by returning functions over those four indices. The linking clitic behavior is also centralized here: when an adjective has `clit = True`, the AP realizes `link_clitic` before the adjective form. fileciteturn55file1

This makes AP one of the language’s structurally sensitive categories. Architectural rule: if a function returns `AP`, it should normally preserve the full AP table and any associated behavior, not collapse to a single string form unless the target category is explicitly stringy. The current `ExtendSqi` debugging history reinforces this. fileciteturn55file1turn54file4turn54file9

### 3.3 Verbs and predication

`VerbSqi` exposes a pragmatic verbal architecture. It relies on `Verb` records from the resource layer, but many high-level verbal outputs are string-valued, since `VP` and `VPSlash` are stringy in `CatSqi`. The module defines helpers such as `vPred`, `npNom`, `npAcc`, and `apPred`, indicating that Albanian predication is currently implemented mostly by selecting surface forms and concatenating them. This is consistent with `SentenceSqi`, where `PredVP` is simply `np.s ! Nom ++ sep ++ vp.s` and `UseCl`/`UseQCl` pass clause strings through. fileciteturn56file9turn54file5

The architecture is therefore mixed: nominal and adjectival categories are structurally rich, while many sentential and verbal categories are simplified. This is a valid design, but it means extension code must know exactly which side of the boundary it is operating on. fileciteturn55file1turn54file5

## 4. Composition pattern across modules

The Albanian grammar composes upward in a fairly regular path: `ResSqi` and the morphology/paradigm layer define the raw materials; `CatSqi` assigns concrete shapes to abstract categories; domain modules like `NounSqi`, `AdjectiveSqi`, `VerbSqi`, `SentenceSqi`, and `ConjunctionSqi` implement the ordinary grammar; `GrammarSqi` aggregates those modules; and `SyntaxSqi` re-exports a simpler constructor-style API. This is the architectural “happy path” for the language. fileciteturn55file0turn56file1

`TrySqi` and `ConstructorsSqi` sit on top of that path as ergonomic shells. `TrySqi` reuses `SyntaxSqi`, `LexiconSqi`, and `ParadigmsSqi`, and adds overloaded helpers like `mkAdv` and `mkAdN`. Architecturally, that means the grammar already has a designed outer shell for experimentation; new language logic should not be encoded there. fileciteturn55file0

## 5. Coordination and list architecture

`ConjunctionSqi` is the model for how nontrivial list categories should be handled in Albanian. It gives explicit `lincat` for `[NP]`, `[CN]`, `[AP]`, `[Adv]`, `[S]`, and others, preserving the relevant internal structure of each coordinated category. For instance, `ListNP` stores `init`, `last`, and `a`; `ListCN` stores table-shaped `init` and `last` plus `g`; and `ListAP` stores full AP tables. This is a strong architectural signal that list categories should preserve the shape of the coordinated object, not be collapsed to plain strings when richer information matters. fileciteturn55file1

This same module also reveals a practical maintenance reality: when a category is missing or implicitly defaulted, Albanian sometimes falls back to a stringy implementation, as in the comments around `DAP` and `ListDAP`. That is acceptable as a documented fallback, but it should be called out explicitly in architecture docs so AI edits do not mistake it for the preferred pattern everywhere. fileciteturn55file1

## 6. Idiom, question, and utterance architecture

`IdiomSqi` is where Albanian packages existential, cleft, imperative-person, progressive, and self-related idioms. It uses straightforward Albanian lexical items such as `është`, `që`, `ka`, `po`, `le të`, and `vetë`, and its outputs are mostly stringy clause-level objects. Since `GrammarSqi` includes `IdiomSqi`, these idiomatic constructions are part of the core grammar, not an external addon. fileciteturn56file1

This matters for architecture because some constructions that look like “extension features” actually belong to the idiom layer of the base grammar. The `Idiom.gfo` artifact also confirms the abstract idiom family includes `ExistIP`, `ExistNP`, `ImpersCl`, `ImpP3`, `ProgrVP`, and related operations. Albanian’s current idiom architecture is therefore the right place for existential and impersonal defaults unless `ExtendSqi` has a compelling language-specific reason to override them. fileciteturn56file0turn56file1

`PhraseSqi` and `TextSqi` occupy the outer utterance/text layer. `TextSqi` is minimal punctuation composition, and the compile logs show that `PhraseSqi` compiles cleanly even though some utterance functions remain unimplemented. Architecturally, these outer layers should stay thin wrappers over already-formed clauses, NPs, APs, and imperatives. fileciteturn56file5turn57file2turn57file3

## 7. Structural simplification policy

The Albanian grammar makes a deliberate simplification choice: many higher-level categories are `{s : Str}` even when richer structures are possible in other languages. `S`, `QS`, `RS`, `Cl`, `QCl`, `RCl`, `VP`, `VPSlash`, `Comp`, `IP`, `IComp`, and several others are string-based in `CatSqi`. By contrast, `CN`, `AP`, `NP`, `Pron`, and list categories preserve structured agreement or case information. Architecture work must respect this boundary instead of trying to normalize everything in one direction. fileciteturn55file1

This policy partly explains why Albanian compiles many core modules cleanly despite having unresolved warnings in higher modules: the core grammar is intentionally lightweight in many sentential areas. But it also explains why `ExtendSqi` is fragile: overrides there often cross the boundary between rich and stringy categories and can accidentally flatten a rich category or expect structure where Albanian has already simplified. fileciteturn56file3turn58file6turn54file9

## 8. Extension architecture and risk zones

`ExtendSqi` should be treated as a high-risk architectural zone. It is not part of the compact, already-working `GrammarSqi` core; it is a large override module instantiated from `ExtendFunctor`. The current debugging history shows that failures in `PrepCN`, `ReflPoss`, the `RNPList` constructors, `PredAPVP`, and several AP/CN-related functions all occurred there rather than in the core grammar. That pattern is architectural, not accidental. fileciteturn58file6turn54file7turn54file8turn54file9

The right architecture rule for `ExtendSqi` is therefore: override by subsystem and only with exact signature/context evidence. `GFCodex` explicitly warns that inheritance restrictions and module composition can cause subtle problems if definitions are removed or reintroduced without respecting the original module structure. For Albanian, this means any change in `ExtendSqi` should be traced against the abstract `Extend` signature, the inherited `ExtendFunctor` behavior, the local Albanian category shapes from `CatSqi`, and where relevant the Albanian core module that already handles similar constructions. fileciteturn58file9turn58file1

The German and Bulgarian materials are useful as model-language references only at the subsystem level. German shows that large extension modules remove and replace coordinated families such as `RNP` together, and Bulgarian shows that reflexive NP families can be implemented as coherent structured subsystems. Neither should be copied blindly into Albanian, but both confirm that subsystem coherence is architecturally more important than one-line local fixes. fileciteturn58file2turn54file6turn56file8

## 9. Current implementation maturity

The uploaded audits show that the Albanian grammar core compiles surprisingly well, but many warnings remain. `GrammarSqi`, `ParadigmsSqi`, `MorphoSqi`, `PhraseSqi`, and other core modules compile cleanly in the logs, while warnings cluster around missing lock fields in some modules, incomplete linearizations in `NounSqi`, `PhraseSqi`, and `DocumentationSqi`, and the still-active `ExtendSqi` work. This suggests an architecture that is already usable but not yet uniform in discipline. fileciteturn56file6turn57file5turn58file6turn58file7

For documentation purposes, the architecture should therefore distinguish between three maturity levels: stable core modules that define the language baseline, fallback modules that compile but contain deliberate simplifications, and active override modules where type- and shape-discipline are still being repaired. In the current snapshot, `GrammarSqi` and its constituent core modules are closer to the first two levels, while `ExtendSqi` belongs to the third. fileciteturn56file1turn58file6turn54file9

## 10. Architectural rules for future work

First, the category authority is `CatSqi`. Any code that returns `CN`, `AP`, `NP`, `Pron`, or a list category must preserve the concrete shape defined there or in the relevant list module. Any code that returns a stringy category should use the simplest correct composition rather than inventing richer local records. fileciteturn55file1

Second, core syntactic logic belongs in the core grammar modules and should be reused through `GrammarSqi` and `SyntaxSqi` whenever possible. `SyntaxSqi` already provides canonical constructor paths for everyday composition, and the architecture should prefer those paths over direct manipulation of low-level fields unless the module’s purpose is precisely to define such manipulation. fileciteturn55file0turn56file1

Third, extension work must start from the inherited design. The `ExtendFunctor` artifact shows that several extension functions are intended to be built compositionally through existing grammar constructors, and `GFCodex` warns that careless inheritance surgery creates subtle later failures. Therefore, override only when Albanian genuinely needs it, and document the entire overridden family together. fileciteturn58file1turn58file9

Fourth, when a fallback uses a stringy approximation for a rich grammatical concept, document it as a fallback rather than treating it as a canonical design. `ConstructionSqi`, `AdverbSqi`, `IdiomSqi`, and parts of `ExtendSqi` all contain useful fallbacks, but they are not all architectural gold standards. The architecture document should label them accordingly. fileciteturn55file1turn56file1

## 11. Recommended reading order for maintainers and AI systems

To understand the Albanian language architecture correctly, the recommended reading order is: `CatSqi.gf` for category shapes, `ResSqi.gf` for shared resource structures, `NounSqi.gf` / `AdjectiveSqi.gf` / `VerbSqi.gf` / `SentenceSqi.gf` / `ConjunctionSqi.gf` / `IdiomSqi.gf` for core implementation patterns, `GrammarSqi.gf` for aggregation, `SyntaxSqi.gf` for public composition, and only then `ExtendSqi.gf` for extension work. This order follows the actual dependency logic of the grammar and reduces drift. fileciteturn55file1turn56file1turn55file0

## 12. Summary

The Albanian GF resource grammar is architecturally a layered RGL concrete syntax with a strong resource/category foundation, a compact but effective core grammar, a constructor-oriented public API, and a large extension surface that is currently the main source of instability. Its key design choice is a split between rich nominal/adjectival categories and simplified string-level clausal categories. Future work should preserve that split, rely on the core modules before inventing local rewrites, and treat `ExtendSqi` as a carefully documented subsystem override area rather than as a free-form patch file. fileciteturn55file1turn56file1turn54file9turn58file9
