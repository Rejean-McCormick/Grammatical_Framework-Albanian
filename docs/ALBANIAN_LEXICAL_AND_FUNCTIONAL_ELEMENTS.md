# ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS

## Purpose

This document defines how **lexical and functional elements** are organized in the Albanian GF grammar, with emphasis on elements that are not ordinary open-class lexical items: pronouns, determiners, quantifiers, articles, predeterminers, interrogative items, conjunctions, subordinators, prepositions, adverbials, utterance particles, and helper constructor resources.

The goal is to give AI coding agents a stable map of:

- where these elements live,
- how they are represented,
- which modules own them,
- which ones are safe to extend mechanically,
- and which ones must preserve full Albanian category shape.

This document is aligned with the uploaded Albanian codedump and uses best-practice guidance where the codedump is silent.

## Source basis

Primary Albanian sources used for this document:

- `ConstructorsSqi.gf`
- `SyntaxSqi.gf`
- `albanian/CatSqi.gf`
- `albanian/NounSqi.gf`
- `albanian/AdverbSqi.gf`
- `albanian/StructuralSqi.gf`
- `albanian/StructuralSqiClause.gf`
- `albanian/StructuralSqiNominal.gf`
- `albanian/StructuralSqiVerbal.gf`
- `albanian/ResSqi.gf`
- `albanian/NamesSqi.gf`

Supporting source basis:

- `Extend.gf`
- `ExtendFunctor.gf`
- GF codex routing / API lookup guidance
- compile/run logs showing active lock-field and category-shape constraints

## 1. Architectural overview

### 1.1 Two major layers

The Albanian grammar separates lexical/functional behavior into two broad layers:

1. **Core category and morphology layer**
   - category shapes and record fields are defined in `CatSqi.gf` and `ResSqi.gf`
   - morphological realization is handled by modules such as `MorphoSqi.gf`, `NounSqi.gf`, `AdjectiveSqi.gf`, `VerbSqi.gf`, and `ParadigmsSqi.gf`

2. **Structural and constructor layer**
   - closed-class and functional vocabulary is exposed through `StructuralSqi.gf`
   - this layer delegates heavily to specialized structural resources:
     - `StructuralSqiClause.gf`
     - `StructuralSqiNominal.gf`
     - `StructuralSqiVerbal.gf`
   - user-facing helper constructors live in `SyntaxSqi.gf`, `ConstructorsSqi.gf`, and `TrySqi.gf`

### 1.2 High-level ownership of functional elements

- **Nominal functional elements** are primarily owned by `StructuralSqiNominal.gf`
  - pronouns
  - determiners
  - quantifiers
  - predeterminers
  - interrogative determiners / interrogative pronouns
  - indefinite negative NPs like `somebody_NP`, `nobody_NP`, `nothing_NP`

- **Clause and discourse functional elements** are primarily owned by `StructuralSqiClause.gf`
  - conjunctions and paired conjunctions
  - subordinators
  - prepositions
  - adverbs and interrogative adverbs
  - utterances and vocatives
  - comparative adverbs

- **Verbal helper items** are primarily owned by `StructuralSqiVerbal.gf`
  - modal / auxiliary-like verbs and high-frequency verbal function words such as `can_VV`, `want_VV`, `have_V2`
  - note: `must_VV` is currently present as an intended item but still lacks a linearization in the current state of the codedump and run logs

- **Public façade module**: `StructuralSqi.gf`
  - re-exports many functional items from nominal (`SN`), clause (`SC`), and verbal (`SV`) subresources instead of defining them inline

## 2. Category-level representation of lexical and functional elements

This section lists the category shapes most relevant to functional vocabulary.

### 2.1 Surface-only categories

The Albanian grammar uses several function-word categories that are essentially surface records with an `s : Str` field.

Observed in `CatSqi.gf`:

- `Subj  = {s : Str}`
- `Conj  = {s : Str}`
- `DConj = {s : Str}`
- `Card  = {s : Str}`
- `ACard = {s : Str}`
- `Predet = {s : Str}`
- `Ord = {s : Str}`
- `IComp = {s : Str}`
- `IP = {s : Str}`

Practical consequence:

- these categories are often safe to build from simple constructor helpers like `mkConj`, `mkPConj`, `mkAdv`, `mkSubj`, `mkVoc`, or direct `{s = ...}`-style wrappers **if** the target category truly is surface-only
- do not generalize this rule to categories like `Pron`, `Quant`, `Det`, `NP`, `AP`, or `CN`

### 2.2 Prepositions

`CatSqi.gf` defines:

- `Prep = Compl`

The Albanian resource layer treats `Compl` / `Prep` as preposition-like surface material. The codebase repeatedly uses `mkPrep` to create such values, and the logs show that these values also carry a lock field (`lock_Prep`) that must be preserved in well-shaped implementations.

Practical consequence:

- prepositions are semantically simple, but structurally not just raw strings once compiled
- when adding new prepositions, use the established preposition constructors rather than ad-hoc record literals

### 2.3 Pronouns

Pronouns are **not** surface-only.

Observed shape from the codedump and logs:

- `Pron` includes at least:
  - `s : Case => Str`
  - `acc_clit : Str`
  - `dat_clit : Str`
  - `a : Agr`

Practical consequence:

- Albanian pronouns simultaneously encode:
  - case forms,
  - clitic forms,
  - agreement information
- never treat a pronoun as just `{s : Str}`
- if a new pronoun is added, it must define the full case and clitic behavior expected by the Albanian grammar

### 2.4 Quantifiers and determiners

Observed from the codedump and `NounSqi.gf`:

- `Quant` includes a table over case, gender, and number, plus `spec : Species`
- `Det` is formed by combining a `Quant` and a `Num`
- `DefArt` and `IndefArt` are realized in `NounSqi.gf`

Important Albanian behavior:

- `DefArt` contributes no overt string in the current implementation and sets `spec = Def`
- `IndefArt` contributes `"një"` in singular and `[]` in plural, and sets `spec = Indef`
- `DetCN` computes NP realization by combining determiner material with noun realization using the noun’s gender and the determiner’s `spec` and number

Practical consequence:

- articles are not free particles bolted on after the fact
- they are encoded through `Quant`/`Det` composition and the noun system

## 3. Public structural inventory

### 3.1 Public façade: `StructuralSqi.gf`

`StructuralSqi.gf` acts mainly as a hub that re-exports items from dedicated structural resources.

Observed exports include:

- conjunctional items such as `or_Conj`, `if_Subj`, `if_then_Conj`, `that_Subj`, `therefore_PConj`
- adverbs and adverbials such as `always_AdV`, `here_Adv`, `there_Adv`, `where_IAdv`, `why_IAdv`, `how_IAdv`, `how8much_IAdv`, `quite_Adv`, `too_AdA`, `very_AdA`
- utterances and vocatives such as `yes_Utt`, `no_Utt`, `please_Voc`
- determiners and quantifiers such as `every_Det`, `few_Det`, `many_Det`, `someSg_Det`, `somePl_Det`, `this_Quant`, `that_Quant`, `which_IQuant`, `no_Quant`, `all_Predet`, `not_Predet`
- pronouns and NP-like closed-class items such as `i_Pron`, `he_Pron`, `she_Pron`, `it_Pron`, `we_Pron`, `they_Pron`, `youSg_Pron`, `youPl_Pron`, `youPol_Pron`, `whoSg_IP`, `whoPl_IP`, `whatSg_IP`, `whatPl_IP`, `somebody_NP`, `something_NP`, `nobody_NP`, `nothing_NP`
- high-frequency verbal function items such as `can_VV`, `can8know_VV`, `want_VV`, `have_V2`

### 3.2 Clause-side structural inventory

Evidence from `StructuralSqiClause.gf` and compiled artifacts shows that this module owns items such as:

- conjunctions and subordinators:
  - `or_Conj`
  - `if_Subj`
  - `if_then_Conj`
  - `that_Subj`
  - `therefore_PConj`
  - `otherwise_PConj`
  - `when_Subj`

- adverbials:
  - `here_Adv`, `here7to_Adv`, `here7from_Adv`
  - `there_Adv`, `there7to_Adv`, `there7from_Adv`
  - `where_IAdv`, `when_IAdv`, `why_IAdv`, `how_IAdv`, `how8much_IAdv`
  - `quite_Adv`, `so_AdA`, `too_AdA`, `very_AdA`
  - `less_CAdv`, `more_CAdv`, `as_CAdv`
  - `at_least_AdN`, `at_most_AdN`

- utterances / discourse particles:
  - `yes_Utt`
  - `no_Utt`
  - `please_Voc`

- prepositions including examples evidenced in logs / compiled output:
  - `above_Prep`
  - `after_Prep`
  - `before_Prep`
  - `behind_Prep`
  - `between_Prep`
  - `by8agent_Prep`
  - `by8means_Prep`
  - `part_Prep`
  - `possess_Prep`
  - `through_Prep`
  - `to_Prep`

### 3.3 Nominal-side structural inventory

Evidence from `StructuralSqiNominal.gf` and compiled artifacts shows that this module owns items such as:

- personal pronouns and polite forms:
  - `i_Pron`
  - `he_Pron`
  - `she_Pron`
  - `it_Pron`
  - `we_Pron`
  - `they_Pron`
  - `youSg_Pron`
  - `youPl_Pron`
  - `youPol_Pron`

- indefinite/negative NP items:
  - `somebody_NP`
  - `something_NP`
  - `nobody_NP`
  - `nothing_NP`
  - `everybody_NP`
  - `everything_NP`

- interrogative items:
  - `whoSg_IP`
  - `whoPl_IP`
  - `whatSg_IP`
  - `whatPl_IP`
  - `how8many_IDet`
  - `which_IQuant`

- quantifiers and determiners:
  - `this_Quant`
  - `that_Quant`
  - `no_Quant`
  - `every_Det`
  - `few_Det`
  - `many_Det`
  - `much_Det`
  - `someSg_Det`
  - `somePl_Det`
  - `all_Predet`
  - `most_Predet`
  - `only_Predet`
  - `not_Predet`

### 3.4 Verbal-side structural inventory

Evidence from `StructuralSqiVerbal.gf` and façade exports shows that this module currently provides at least:

- `can_VV`
- `can8know_VV`
- `want_VV`
- `have_V2`

And current run logs show:

- `must_VV` is still missing a linearization in `StructuralSqi.gf`

## 4. Constructor layer and public helper API

### 4.1 `SyntaxSqi.gf`

`SyntaxSqi.gf` is the public constructor layer for simple user-facing composition.

Observed helpers include:

- `mkCN : N -> CN = UseN`
- `mkCN : AP -> CN -> CN = AdjCN`
- `mkCN : A -> CN -> CN = \a,cn -> AdjCN (PositA a) cn`
- `mkAP : A -> AP = PositA`
- `mkDet : Quant -> Num -> Det = DetQuant`
- `mkNP : Det -> CN -> NP = DetCN`
- `mkNP : Pron -> NP = UsePron`
- quantifier-based `mkNP` overloads

Observed helper determiners:

- `the_Det = DetQuant DefArt NumSg`
- `a_Det = DetQuant IndefArt NumSg`
- `this_Det = DetQuant this_Quant NumSg`
- `these_Det = DetQuant this_Quant NumPl`
- `that_Det = DetQuant that_Quant NumSg`
- `those_Det = DetQuant that_Quant NumPl`

Practical consequence:

- the public API already exposes canonical determiner construction
- new high-level examples and tests should prefer `SyntaxSqi` helpers over low-level record manipulation

### 4.2 `ConstructorsSqi.gf`

`ConstructorsSqi.gf` is based on `SyntaxSqi` but intentionally removes some highly language-specific structural items from the generic constructor surface.

Observed exclusions:

- personal pronouns:
  - `i_Pron`, `youSg_Pron`, `he_Pron`, `she_Pron`, `it_Pron`, `we_Pron`, `youPl_Pron`, `they_Pron`
- demonstrative quantifiers:
  - `this_Quant`, `that_Quant`

Interpretation:

- constructor resources should remain generic and compositional
- closed-class Albanian-specific forms stay in `StructuralSqi` / `SyntaxSqi`, not in the most abstract constructor façade

### 4.3 `TrySqi.gf`

`TrySqi.gf` combines:

- `SyntaxSqi`
- `LexiconSqi`
- `ParadigmsSqi`

and provides convenient overloads for exploratory grammar use, including:

- `mkAdv : Str -> Adv`
- `mkAdN : Str -> AdN`
- `mkAdN : CAdv -> AdN`

Practical consequence:

- `TrySqi` is a convenience/testing surface, not the authoritative structural specification

## 5. Representation rules by element type

### 5.1 Pronouns

Rules:

- define pronouns with full case behavior
- preserve clitic slots (`acc_clit`, `dat_clit`)
- preserve agreement (`a : Agr`)
- do not downgrade a pronoun to an NP or a raw string unless a specific constructor requires it

Recommended extension pattern:

- follow the same full-record strategy used by Albanian `Pron`
- when a pronoun is made visible as an NP, use `UsePron`

### 5.2 Quantifiers and determiners

Rules:

- create new articles / quantifiers at the `Quant` layer when they are article-like or determiner-like
- combine them with `Num` through `DetQuant`
- do not hardcode article strings at the NP level if the meaning is really determiner-level

Observed Albanian determiner behavior:

- definiteness is represented through `spec = Def` / `spec = Indef`
- indefinite singular article is overt (`një`), plural indefinite article is empty in the current implementation

### 5.3 Predeterminers and cardinal-like surface items

Categories like `Predet`, `Card`, `Ord`, and many interrogative/adverbial function words are surface-only.

Rules:

- safe to implement through established paradigm constructors
- keep them in structural submodules
- do not force them into richer categories unnecessarily

### 5.4 Prepositions

Rules:

- use `mkPrep` / established prep constructors rather than raw ad-hoc records
- preserve whatever lock field the category expects in compiled form
- rely on Albanian downstream behavior for case after preposition, rather than branching on preposition strings at runtime

Observed Albanian adverb/preposition behavior:

- `AdverbSqi.gf` explicitly chooses accusative after a preposition for `PrepNP`
- this is a language-wide policy and should be treated as the structural default unless a dedicated exception is implemented in the grammar

### 5.5 Subordinators and conjunctions

Rules:

- use dedicated constructors like `mkConj`, `mkPConj`, `mkSubj`
- keep discourse connective inventory centralized in `StructuralSqiClause.gf`
- avoid scattering subordinators across unrelated modules

### 5.6 High-frequency verbal function items

Rules:

- keep modal/auxiliary-like lexical items in `StructuralSqiVerbal.gf`
- record incomplete or intentionally disabled items explicitly

Current codedump state:

- `must_VV` exists as an intended item but is still disabled / unlinearized in the current Albanian structural layer

## 6. Best-practice extension policy

### 6.1 Where to add a new item

Add a new lexical/functional element according to this decision order:

1. **Is it open-class lexical content?**
   - put it in lexicon / paradigms / names resources, not in structural modules

2. **Is it a closed-class or grammaticalized item?**
   - put it in one of the structural modules

3. **Is it nominal?**
   - `StructuralSqiNominal.gf`

4. **Is it clausal / connective / discourse / adverbial / prepositional?**
   - `StructuralSqiClause.gf`

5. **Is it a modal / helper / verbal function word?**
   - `StructuralSqiVerbal.gf`

6. **Should it be publicly available to normal syntax users?**
   - export it from `StructuralSqi.gf`

7. **Should it be part of the generic constructor API?**
   - only then expose it through `SyntaxSqi` or `ConstructorsSqi`

### 6.2 Preferred constructor discipline

Preferred order of implementation:

1. use a paradigm/helper constructor that already matches the category
2. use structural composition from existing Albanian modules
3. only then build a record manually

Manual record construction is acceptable only when:

- the category shape is fully known,
- all required fields are preserved,
- and the value is truly local / exceptional.

### 6.3 Anti-drift rules for lexical and functional elements

Do not:

- create a pronoun with only `s : Str`
- create a determiner directly as an NP-level string hack
- create a preposition as a naked string if the grammar expects a full prep record with lock fields
- place the same functional element in multiple ownership modules
- expose language-specific closed-class items through `ConstructorsSqi` unless that is explicitly intended
- infer category shape from surface behavior alone

## 7. Current known issues relevant to this document

These are not all fatal, but they matter for documentation and future coding discipline.

### 7.1 `must_VV`

Current run logs still report:

- `Warning: no linearization of must_VV`

Policy:

- keep this item documented as **planned but incomplete** until a real Albanian implementation is accepted
- do not silently treat it as supported

### 7.2 Preposition lock warnings

Multiple run logs report warnings in `StructuralSqiClause.gf` for operations such as:

- `above_Prep`
- `after_Prep`
- `before_Prep`
- `behind_Prep`
- `between_Prep`
- `by8agent_Prep`
- `by8means_Prep`

with `missing lock field lock_Prep`.

Interpretation:

- prepositions are structurally richer than a plain `{s : Str}` interpretation in compiled form
- future cleanup should regularize preposition constructors so they preserve the expected prep shape without warnings

### 7.3 Constructor vs implementation mismatch risk

Earlier Albanian `ExtendSqi` work exposed a recurring risk:

- returning a richer category where the abstract signature expects surface-only output
- or flattening a rich category to string when the target category expects full record shape

This matters for lexical/functional elements because they often look string-like even when they are not. Prepositions, pronouns, quantifiers, and article-bearing items are the main danger zone.

## 8. Documentation obligations for future additions

Whenever a new lexical or functional element is added, the implementation must record:

- owning module
- target category
- whether the category is surface-only or record-rich
- paradigm/helper used
- whether it is exported from `StructuralSqi.gf`
- whether it is surfaced in `SyntaxSqi` / `ConstructorsSqi` / `TrySqi`
- whether it has any special case, clitic, definiteness, or agreement behavior

## 9. Minimal checklist for AI coding agents

Before adding or editing a lexical/functional element, check:

1. What is the exact category in `CatSqi.gf`?
2. Is that category surface-only, or does it carry morphology / lock fields?
3. Which structural submodule owns this class of element?
4. Is there already a helper constructor in `ParadigmsSqi` or `ResSqi`?
5. Should the item be exported publicly through `StructuralSqi.gf`?
6. Should it appear in `SyntaxSqi` or be intentionally hidden from `ConstructorsSqi`?
7. Does the item interact with case, definiteness, clitics, or agreement?
8. Is there already a nearby Albanian pattern in the codedump that should be copied exactly?

## 10. Recommended future refinement

This document should later be expanded with a machine-readable inventory table containing one row per functional element, with columns such as:

- name
- category
- owner module
- export path
- constructor origin
- surface form
- morphosyntactic notes
- status (`stable`, `warning`, `incomplete`)

That table would make this document directly usable by automated tooling and future AI patch agents.
