# ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE

## Scope

This document records the **current Albanian category and lincat shapes** as evidenced by the uploaded codedump and audit artifacts. It is a **reference for implementation work**, not a redesign proposal.

Five rules govern its use:

1. Treat the **current codedump** as the source of truth for Albanian concrete shapes.
2. Distinguish between:
   - **abstract categories** from the RGL API,
   - **current Albanian concrete shapes** in `CatSqi.gf`,
   - **resource-level implementation types** in `ResSqi.gf`,
   - and **producer-owned list/helper categories** defined outside `CatSqi.gf`.
3. Preserve the full concrete shape of the target category. Do not flatten categories to `Str` unless the current Albanian lincat really is string-shaped.
4. Distinguish between:
   - **category shape knowledge** (“what the current Albanian lincat looks like”), and
   - **constructor availability** (“what can actually be built with `lin Cat { ... }`, helper constructors, or paradigm constructors in the current module context”).
5. Treat **comments and older notes as secondary evidence only**. If current code, current docs, and compile behavior disagree with a comment, the comment is stale until updated.

A documented lincat shape is **necessary evidence**, but it is **not by itself sufficient** to justify a concrete constructor pattern in every module.

This reference is authoritative for:
- category-shape questions,
- lincat-preservation questions,
- rich-vs-shallow boundary questions,
- and “what kind of thing is this category right now?” questions.

It is **not** by itself sufficient for:
- deciding whether a local `lin Cat { ... }` is valid in a given module,
- deciding whether a helper may be reused across nearby categories,
- or deciding whether a current implementation pattern is final.

For those questions, read this file together with:
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`

---

## Source hierarchy for this reference

1. `albanian/CatSqi.gf` — authoritative current lincat definitions.
2. `albanian/ResSqi.gf` — authoritative internal resource types used by `CatSqi.gf`.
3. Producer modules such as `NounSqi.gf`, `AdjectiveSqi.gf`, `VerbSqi.gf`, `SentenceSqi.gf`, `QuestionSqi.gf`, `ConjunctionSqi.gf`, `AdverbSqi.gf` — authoritative usage patterns for each category.
4. Compiled `.gfo` artifacts and audit logs — confirmation and diagnostics.
5. Current module context and actual compiler behavior — decisive when a category shape appears simple but a constructor pattern does not resolve.
6. GFCodex / exact signature lookup — used to disambiguate abstract signatures and overload intent, not to override the current Albanian codedump.

When these disagree, use this discipline:

- first confirm the **current module’s exact compile context**,
- then confirm the **category shape**,
- then choose a constructor path that is actually available in the current codebase.

This means:

- a category can be documented as shallow but still have **conditional or blocked constructor availability** in a given module,
- a category can be rich even if one current function uses a single surface cell of it for a shallow target,
- and a helper can look semantically similar while still being type-incompatible.

---

## 1. Resource-level parameters and internal types (`ResSqi.gf`)

These are not all abstract categories, but they define the shapes that Albanian concrete categories reuse.

### 1.1 Parameters

- `Species = Indef | Def`
- `Case = Nom | Acc | Dat | Ablat`
- `Gender = Masc | Fem`
- `GenNum = GSg Gender | GPl`
- `Tense = Pres | Past | Imperfect | Aorist`

### 1.2 Agreement

- `Agr = {gn : GenNum ; p : Person}`
- Helper: `agrgP3 : Gender -> Number -> Agr`

### 1.3 Core internal implementation types

- `Compl = {s : Str}`
- `Prep = Compl`
- `Noun = {s : Species => Case => Number => Str ; g : Gender}`
- `Adj = {s : Case => Gender => Number => Str ; clit : Bool}`
- `Verb = {
    Indicative : Tense => Number => Person => Str ;
    Imperative : Number => Str ;
    participle : Str ;
    pres_optative : Number => Person => Str ;
    perf_optative : Number => Person => Str ;
    pres_admirative : Number => Person => Str ;
    imperf_admirative : Number => Person => Str
  }`
- `Pron = {s : Case => Str ; acc_clit, dat_clit : Str ; a : Agr}`
- `Quant = {s : Case => Gender => Number => Str ; spec : Species}`
- `Det = {s : Case => Gender => Str ; n : Number ; spec : Species}`

### 1.4 Practical consequences

- Albanian noun phrases are **case-sensitive**.
- Albanian common nouns (`CN`) are **not strings**; they are backed by `Noun` and therefore preserve `Species`, `Case`, `Number`, and `Gender`.
- Albanian adjective phrases (`AP`) are agreement tables, not strings.
- Albanian prepositions are currently **surface-string complements** via `Compl = {s : Str}`.
- A simple-looking shape such as `{s : Str}` does **not** automatically imply that `lin Cat {s = ...}` is available or correct in every resource/module.
- Agreement is not optional in `NP`/`Pron` work. If the category carries `a : Agr`, that field is part of the implementation contract.
- Complement-bearing categories remain structurally richer even when their visible surface looks simple.

### 1.5 Morphology-facing reminder

This file is a category and lincat reference, not the full morphology document.

For morphology-heavy work, also check:
- `ALBANIAN_MORPHOLOGY_SPEC.md`
- `albanian/MorphoSqi.gf`
- `albanian/ParadigmsSqi.gf`

This matters because some category-shape questions that look “syntactic” are actually driven by morphology-aware internal records.

---

## 2. Base category reference (`CatSqi.gf`)

The tables below record the current concrete Albanian lincats.

## 2.1 Noun-family and lexical categories

| Abstract category | Current Albanian lincat | Constructor-availability note | Notes |
|---|---|---|---|
| `N` | `Noun` | Use noun producers/paradigms or exact noun records. | Full noun table with `Species`, `Case`, `Number`, plus `g : Gender`. |
| `N2` | `Noun ** {c2 : Compl}` | Preserve `c2`; do not flatten to `N`. | Noun plus one complement slot. |
| `N3` | `Noun ** {c2,c3 : Compl}` | Preserve `c2`/`c3`. | Noun plus two complement slots. |
| `CN` | `Noun` | Use noun-preserving constructors. | Same shape as `N`. |
| `NP` | `{s : Case => Str ; a : Agr}` | Preserve case and agreement; do not reduce to one string. | Case-sensitive noun phrase with agreement. |
| `Pron` | `{s : Case => Str ; acc_clit, dat_clit : Str ; a : Agr}` | Preserve pronoun-specific clitic fields. | Pronoun with clitic fields. |
| `Det` | `{s : Case => Gender => Str ; spec : Species ; n : Number}` | Preserve `spec` and `n`. | Determiner is case- and gender-sensitive. |
| `Quant` | `{s : Case => Gender => Number => Str ; spec : Species}` | Preserve number and species. | Quantifier is case/gender/number-sensitive. |
| `Num` | `{s : Str ; n : Number}` | String-safe only because current lincat is reduced. | Reduced numeral record in current Albanian. |
| `Card` | `{s : Str}` | String-safe. | Surface-string cardinal. |
| `ACard` | `{s : Str}` | String-safe. | Surface-string adjectival cardinal. |
| `Ord` | `{s : Str}` | String-safe in current snapshot. | Surface-string ordinal. |
| `Predet` | `{s : Str}` | String-safe. | Surface-string predeterminer. |
| `DAP` | `{s : Str}` | String-safe at shape level, but category-specific helpers still need exact-type matching. | Current Albanian snapshot keeps DAP string-shaped. |
| `GN` | `{s : Str}` | String-safe. | String-shaped. |
| `LN` | `{s : Str}` | String-safe. | String-shaped. |
| `PN` | `{s : Str}` | String-safe. | Proper name is surface string in current snapshot. |
| `SN` | `{s : Str}` | String-safe. | String-shaped. |

### Notes

- `CN` and `N` share the same underlying `Noun` shape in the current Albanian snapshot.
- `NP` and `Pron` are both case-sensitive, but `Pron` has extra clitic fields. Do not erase that difference in implementation reasoning.
- `DAP` is currently explicit and shallow. That does **not** mean it can be freely treated as `NP`, `Det`, or `Num`.
- Surface-safe does not mean constructor-safe. A shallow category can still be **warning**, **conditional**, or **blocked** in the shallow-constructor matrix.

## 2.2 Adjective-family categories

| Abstract category | Current Albanian lincat | Constructor-availability note | Notes |
|---|---|---|---|
| `A` | `Adj` | Do not confuse with `AP`. | Resource-level adjective: `Case => Gender => Number => Str`, plus `clit : Bool`. |
| `A2` | `Adj ** {c2 : Compl}` | Preserve `c2`; helper reuse must still match `A2` or compatible projection. | Adjective with complement. |
| `AP` | `{s : Species => Case => Gender => Number => Str}` | Must preserve all four dimensions unless the **target** category is already shallow. | Full agreement table. |

### Notes

- `A` and `AP` belong to the same broad family, but they are **not** interchangeable. This distinction is now a permanent anti-drift rule.
- If a function takes `AP`, an `A -> Str` helper is not enough.
- `A2` adds a complement slot; do not project it down to plain `A` unless the target and constructor path explicitly justify that step.

## 2.3 Verb-family categories

| Abstract category | Current Albanian lincat | Constructor-availability note | Notes |
|---|---|---|---|
| `V`, `VA`, `VV`, `VS`, `VQ` | `Verb` | Use verb producers/paradigms. | Full resource-level verb record. |
| `V2`, `V2S`, `V2Q` | `Verb ** {c2 : Compl}` | Preserve `c2`. | One complement slot. |
| `V3`, `V2A`, `V2V` | `Verb ** {c2,c3 : Compl}` | Preserve `c2`/`c3`. | Two complement slots. |
| `VP` | `{s : Str}` | String-safe at category level. | Current Albanian snapshot flattens VP to surface string. |
| `VPSlash` | `{s : Str}` | String-safe at category level. | Current Albanian snapshot flattens VPSlash to surface string. |
| `Comp` | `{s : Str}` | String-safe at category level. | Complement phrase is surface-string shaped at category level. |

### Notes

- Verb-lexeme categories are rich.
- `VP`-level categories are currently surface-flattened in Albanian.
- The main reduction boundary is often `Comp`: AP/CN/NP/Adv are reduced there, not arbitrarily elsewhere.
- A function returning `Comp` is not under the same preservation rule as a function returning `AP` or `CN`.

## 2.4 Clause, sentence, question, and relative categories

| Abstract category | Current Albanian lincat | Constructor-availability note | Notes |
|---|---|---|---|
| `S` | `{s : Str}` | String-safe at category level. | Flattened in current `CatSqi`. |
| `QS` | `{s : Str}` | String-safe. | Flattened. |
| `RS` | `{s : Str}` | String-safe. | Flattened. |
| `SSlash` | `{s : Str}` | String-safe. | Flattened. |
| `Cl` | `{s : Str}` | String-safe. | Flattened. |
| `QCl` | `{s : Str}` | String-safe. | Flattened. |
| `RCl` | `{s : Str}` | String-safe. | Flattened. |
| `RP` | `{s : Str}` | String-safe at shape level, but use relative-owner constructors first. | Relative connector/result-like item. |
| `ClSlash` | `{s : Str}` | String-safe. | Flattened. |
| `IComp` | `{s : Str}` | String-safe. | Flattened interrogative complement. |
| `IP` | `{s : Str}` | String-safe. | Flattened interrogative phrase. |
| `IDet` | `{s : Str}` | String-safe. | Flattened interrogative determiner. |
| `IQuant` | `{s : Str}` | String-safe. | Flattened interrogative quantifier. |
| `Subj` | `{s : Str}` | Usually built by paradigm constructors, not arbitrary local `lin`. | Surface string. |
| `Conj` | `{s : Str}` | Usually built by paradigm constructors, not arbitrary local `lin`. | Surface string. |
| `PConj` | `{s : Str}` or paradigm-owned equivalent in use sites | Verify actual constructor path in module context. | Surface-like discourse connector. |
| `DConj` | `{s : Str}` | **Do not conclude from shape alone that `lin DConj { ... }` is valid in every module.** | Surface string at current lincat level. |
| `Imp` | `{s : Str}` | String-safe. | Flattened imperative. |
| `Utt` | `{s : Str}` in current practical use | Shallow target, but constructor path still depends on module context. | Surface utterance result. |
| `Voc` | surface-use category | Usually paradigm-constructed in producer modules. | Vocative/result-like structural item. |

### Notes

- Many upper-layer categories are flattened in the current Albanian grammar.
- That flattening is a **current implementation fact**, not a universal license to fabricate them locally without checking module context.
- `DConj` is the canonical warning case: shallow documented shape, but constructor availability is still module-sensitive.
- `Utt` is broadly shallow, but shallow target permission does not cancel input-category discipline.

## 2.5 Adverbial and prepositional categories

| Abstract category | Current Albanian lincat | Constructor-availability note | Notes |
|---|---|---|---|
| `Prep` | `Compl` | Current runtime behavior is string-like; producer modules should still be preferred when available. | And `Compl = {s : Str}` in `ResSqi`. |
| `Adv` | inherited producer category, surface-used as `{s : Str}` in current modules | Check producer modules before inventing a local record. | Most current Albanian code treats it stringwise. |
| `AdV` | inherited producer category, surface-used as `{s : Str}` in current modules | Same practical treatment in current code. | Same practical treatment in current code. |
| `AdA` | surface-used as `{s : Str}` in current modules | Check producer modules. | Same practical treatment in current code. |
| `AdN` | surface-used as `{s : Str}` in current modules | Check producer modules. | Same practical treatment in current code. |
| `IAdv` | inherited producer category, surface-used as `{s : Str}` in current modules | Same practical treatment in current code. | Same practical treatment in current code. |
| `CAdv` | surface-use category with local record behavior in current code | Verify availability and field assumptions in module context. | Comparative adverbial category. |

### Notes

- `Prep` is shallow in current runtime behavior, but still **producer-owned**.
- The safe current path for structural prepositions is:
  - lexical introduction through `ResSqi.mkPrep`,
  - compositional use through `AdverbSqi.PrepNP`.
- Do not invent a new preposition case policy from surface strings alone.

## 2.6 Numeral and digit categories

| Abstract category | Current Albanian lincat | Constructor-availability note | Notes |
|---|---|---|---|
| `Numeral` | `{s : Str}` | String-safe at shape level, but numeral grammar still owns behavior. | Flattened numeral category in current practical use. |
| `Digits` | `{s : Str ; n : Number ; tail : DTail}` | Preserve `n` and `tail`. | Carries number and digit-tail state. |
| `Decimal` | `{s : Str ; n : Number ; hasDot : Bool}` | Preserve `n` and `hasDot`. | Carries number and dot state. |

### Notes

- `Numeral` is shallow enough to tempt free fabrication; that is not the right default.
- Use numeral-producer paths first.
- Do not confuse `DAP`, `Digits`, and numeral categories just because they are all surface-oriented.

---

## 3. Producer-owned auxiliary and list categories

These are not declared in `CatSqi.gf`, but they are structurally important and must be documented because other modules rely on them.

## 3.1 Conjunction-owned list categories (`ConjunctionSqi.gf`)

| Category | Concrete shape | Constructor-availability note | Notes |
|---|---|---|---|
| `ListS` | `{init : Str ; last : Str}` | String-safe list. | String list. |
| `ListNP` | `{init : Case => Str ; last : Case => Str ; a : Agr}` | Preserve case and agreement; do not replace with plain `NP`. | Case-sensitive NP list; preserves agreement. |
| `ListCN` | `{init : Species => Case => Number => Str ; last : Species => Case => Number => Str ; g : Gender}` | Preserve full CN table and gender. | Preserves full CN table and gender. |
| `ListAP` | `{init : Species => Case => Gender => Number => Str ; last : Species => Case => Gender => Number => Str}` | Preserve full AP table. | Preserves full AP table. |
| `ListAdv` | `{init : Str ; last : Str}` | String-safe list. | String list. |
| `ListAdV` | `{init : Str ; last : Str}` | String-safe list. | String list. |
| `ListIAdv` | `{init : Str ; last : Str}` | String-safe list. | String list. |
| `ListRS` | `{init : Str ; last : Str}` | String-safe list. | String list. |
| `ListDAP` | `{init : Str ; last : Str ; spec : Species ; n : Number}` | Custom helper/list category; do not infer from generic list families. | Custom because current `DAP` is string-shaped. |

### Notes

- Rich list categories are not ordinary strings.
- Do not collapse `ListNP`, `ListCN`, or `ListAP` to a single surface string when the family expects a real list category.
- Do not assume all list categories behave symmetrically.

## 3.2 Question-owned auxiliary categories (`QuestionSqi.gf`)

| Category | Concrete shape | Constructor-availability note | Notes |
|---|---|---|---|
| `QVP` | `{s : Str}` | Local to question layer; do not treat as a global `CatSqi` fact. | Defined locally in `QuestionSqi.gf`; not in `CatSqi.gf`. |

### Notes

- `QVP` is a good example of why “what exists in one module” is not the same as “what is a base Albanian category fact.”
- Local helper categories must stay clearly separated from base lincat truth.

## 3.3 Extend-owned auxiliary categories

The Albanian extension layer may introduce additional local categories such as `VPS`, `VPI`, `VPS2`, `VPI2`, `X`, and several list-like helper categories.

Operational rule:
- treat these as **module-local extension categories**,
- do not treat them as base Albanian category facts,
- and do not infer general Albanian category architecture from them unless the extension layer is being documented separately.

### Notes

- The current cycle keeps the VPS/VPI/VPS2/VPI2/list-wrapper family inherited rather than re-opening it as a new Albanian extension subsystem.
- Extension-local shapes can be important for implementation, but they do not automatically belong in the base category story.

## 3.4 Operational warning about local categories

A category can be:

- documented as a current Albanian lincat shape,
- defined only locally in a producer/helper/resource module,
- or available only through certain opens/imports.

So before using a constructor pattern such as `lin Cat { ... }`, verify that:

1. the category is actually available in the current module context,
2. the record fields assumed by the constructor really match the current concrete category,
3. the chosen pattern is already supported somewhere in the current codedump, or is otherwise validated by compilation.

---

## 4. Category usage patterns by producer module

This section records how the current Albanian implementation actually consumes and produces the shapes above.

## 4.1 `NounSqi.gf`

Key evidence pattern:

- `DetCN det cn = { s = \\c => det.s ! c ! cn.g ++ cn.s ! det.spec ! c ! det.n ; a = agrgP3 cn.g det.n }`
- `AdjCN ap cn = { s = \\spec,c,n => cn.s ! spec ! c ! n ++ ap.s ! spec ! c ! cn.g ! n ; g = cn.g }`
- `UseN n = n`
- `UsePron p = p`

Consequences:

- `CN` preserves full noun morphology.
- `NP` is always case-sensitive and carries agreement.
- `AP -> CN -> CN` composition must preserve `Species`, `Case`, `Number`, and `Gender`.

## 4.2 `AdjectiveSqi.gf`

Key evidence pattern:

- `PositA` returns an `AP` whose `s` field depends on `Species`, `Case`, `Gender`, `Number`.
- `ComplA2` keeps the AP table and appends the complement.
- `SentAP` preserves AP shape rather than collapsing to one string form.

Consequences:

- Albanian `AP` is not safely reducible to `Str` unless the **target category** explicitly wants a string-shaped result.
- The adjective producer module is the right reference for AP-preserving composition.
- A helper written for `A` is **not automatically valid** for `AP`, even if both are adjective-family categories.

## 4.3 `VerbSqi.gf`

Key evidence pattern:

- `CompNP np = {s = npNom np}`
- `CompAP ap = {s = apPred ap}`
- `CompCN cn = {s = cnPred cn}`
- `CompAdv adv = {s = adv.s}`
- `UseComp c = {s = join copula c.s}`

Consequences:

- In current Albanian, `Comp` is the canonical place where AP/CN/NP/Adv are reduced to a predicate-like string.
- If a function returns `Comp`, flattening to `Str` is expected.
- If a function returns `AP` or `CN`, flattening is usually wrong.

## 4.4 `SentenceSqi.gf`

Key evidence pattern:

- `PredVP np vp = {s = np.s ! Nom ++ sep ++ vp.s}`
- `UseCl ... = ... s`
- `UseQCl ... = ... s`

Consequences:

- Many sentential and clausal targets are string-shaped in the current Albanian grammar.
- This is why some utterance/clause-level functions are allowed to use surface extraction without violating category safety.
- The sentence layer is one of the strongest reminders that current Albanian implementation truth may differ from idealized RGL expectations.

## 4.5 `AdverbSqi.gf`

Key evidence pattern:

- `PrepNP p np = {s = p.s ++ npAfterPrep p np}`
- `npAfterPrep : Prep -> NP -> Str = \_,np -> np.s ! Acc`

Consequences:

- Albanian `Prep` is string-like in current runtime behavior.
- NP after preposition is structurally realized via `Acc` in current Albanian code.
- Any prep-based extension should check this default before inventing a new case policy.

## 4.6 `ConjunctionSqi.gf`

Key evidence pattern:

- rich list categories are defined for `ListNP`, `ListCN`, `ListAP`,
- surface-only list categories are defined for already-stringy categories.

Consequences:

- do not collapse `ListNP` to a surface string when a real list category is required,
- do not infer that all list categories are symmetric,
- and do not infer that comments about older default behavior override the current explicit lincats.

## 4.7 `QuestionSqi.gf`

Key evidence pattern:

- `QVP` is locally defined,
- interrogative phrase categories in `CatSqi.gf` are mostly flattened.

Consequences:

- current question-layer code is a mix of local helper categories and flattened public categories,
- so availability must be checked per module rather than inferred from one global category summary.

## 4.8 `StructuralSqiClause.gf`

Key evidence pattern:

- structural closed-class items are grouped here,
- prepositions are introduced through `ResSqi.mkPrep`,
- conjunction-like and discourse items can look surface-simple,
- but constructor availability still depends on module context.

Consequences:

- `DConj`, `CAdv`, `Utt`, `Voc`, `PConj`, `Subj`, and similar structural items must not be collapsed into one blanket “shallow category” reasoning style.
- `DConj` is the warning case: documented shape is shallow, but direct `lin DConj { ... }` is not automatically certified in every module.
- Structural clause vocabulary belongs to structural ownership, not ad hoc extension-local recreation.

## 4.9 `ExtendSqiHelpers.gf`

Key evidence pattern:

- the helper inventory already distinguishes:
  - neutral utilities,
  - exact-type surface helpers,
  - category-preserving builders,
  - temporary compatibility helpers.

Consequences:

- helper selection is now a category-reference concern, not just an implementation-style concern.
- `adjSurfaceNomMascSg : A -> Str` and `apSurfaceNomMascSg : AP -> Str` must be treated as separate tools.
- compatibility wrappers such as `mkCompatAPFromStr`, `mkCompatCNFromStr`, `mkCompatNPFromStr` are not proof that flattening is acceptable for rich categories in general.

---

## 5. Category preservation rules

These are the practical anti-drift rules implied by the current Albanian shapes.

## 5.1 Safe reductions to `Str`

Usually safe only when the **target category itself** is string-shaped:

- `Comp`
- `S`, `QS`, `RS`, `Cl`, `QCl`, `RCl`, `ClSlash`, `SSlash`
- `IComp`, `IP`, `IDet`, `IQuant`
- `Card`, `Ord`, `Predet`
- many surface structural categories such as `Subj`, `Conj`, `PConj`, and some utterance-level outputs
- shallow discourse outputs like `Utt` when the module context and input discipline are both correct

## 5.2 Categories that must usually preserve internal tables

Do **not** collapse these to plain strings when returning them:

- `CN`
- `AP`
- `NP`
- `Pron`
- `Det`
- `Quant`
- `ListNP`
- `ListCN`
- `ListAP`

## 5.3 Complement-bearing lexical categories

Preserve complement slots:

- `N2`, `N3`
- `A2`
- `V2`, `V2S`, `V2Q`
- `V3`, `V2A`, `V2V`

## 5.4 Current Albanian simplification boundary

The current Albanian snapshot uses a strong simplification line:

- lexical/morphological categories (`Noun`, `Adj`, `Verb`, `NP`, `Det`, `Quant`) keep rich structure;
- many clause-, sentence-, and interrogative-level categories are flattened to `{s : Str}`.

This boundary is the single most important fact to preserve during maintenance.

## 5.5 Constructor-availability rule

A documented lincat shape tells you what the category looks like when it is available. It does **not** by itself prove that a local constructor pattern is valid.

Before writing `lin Cat { ... }` or reusing a helper constructor, verify:

1. the category is in scope in the current module,
2. the fields assumed by the code match the current Albanian concrete category,
3. the constructor path is supported by the current codebase or compile-tested,
4. no existing Albanian producer/helper constructor should be preferred.

## 5.6 Exact helper-type rule

Helper reuse requires **exact category compatibility**.

Examples of what to check:

- `A` helper vs `AP` input
- `N` / `CN` helper vs `NP` input
- `Pron` helper vs generic `NP` input
- list helper for `ListNP` vs plain `NP`

Belonging to the same family is **not enough**. Match the actual concrete type.

## 5.7 Comment-authority rule

A comment may explain an older state, a local workaround, or a historical default. It is **not** authoritative over:

- the current codedump,
- the current compiled artifacts,
- the current module context,
- or the current compiler behavior.

If comment and code disagree, the comment must be treated as stale until updated.

---

## 6. High-risk categories for coding and debugging

### `CN`

Current shape:
- `Species => Case => Number => Str`
- plus `g : Gender`

Common mistakes:
- returning `{s : Str}` or a partial record where full noun morphology is expected,
- rebuilding `CN` from one extracted surface form.

### `AP`

Current shape:
- `Species => Case => Gender => Number => Str`

Common mistakes:
- using only nominative masculine singular as if it were the whole category,
- reusing an `A`-only helper on an `AP`.

### `NP`

Current shape:
- `Case => Str`
- `a : Agr`

Common mistakes:
- dropping agreement,
- hard-coding nominative where the function should preserve case,
- replacing `Pron`-specific or list-specific structures with generic NP assumptions.

### `Prep`

Current shape:
- `Compl = {s : Str}`

Common mistakes:
- assuming rich prep metadata exists at runtime in Albanian,
- inventing a new case policy without checking the existing `PrepNP` path.

### `Comp`

Current shape:
- `{s : Str}`

Common mistakes:
- over-preserving AP/CN shape when the target category is actually already reduced.

### `DConj`

Current shape:
- `{s : Str}`

Common mistake:
- assuming that because the current shape is surface-only, `lin DConj {s = ...}` is automatically valid in any resource/module without first checking scope and compile context.

### `DAP`

Current shape:
- `{s : Str}`

Common mistakes:
- confusing DAP’s current string shape with a license to reuse arbitrary NP/Det helpers,
- treating old comments about default insertion as stronger evidence than the current explicit lincat.

### `ListNP`, `ListCN`, `ListAP`

Current shapes:
- structurally richer than plain strings,
- producer-owned in `ConjunctionSqi.gf`.

Common mistakes:
- collapsing them to surface strings,
- substituting one list family for another,
- or treating them as if they were interchangeable with the singular category.

### `Digits`, `Numeral`

Current shapes:
- surface-oriented, but still system-owned by numeral grammar.

Common mistakes:
- treating them as generic string helpers outside numeral ownership,
- confusing them with `DAP`,
- mixing them into richer nominal outputs without an explicit target-category reason.

---

## 7. Snapshot caveats

This document records the **current codedump**, which includes simplifications and local approximations.

Examples:

- Many sentence/question categories are flattened to `{s : Str}`.
- `DAP` is string-shaped in the current snapshot.
- `QVP` is defined locally in `QuestionSqi.gf`, not globally in `CatSqi.gf`.
- Some categories look surface-only in the reference, but their local constructor availability still depends on module scope and compilation context.
- Structural shallow categories do not all share the same safe construction policy.
- Compatibility wrappers exist in the extension layer and must not be mistaken for proof that a rich-category reduction is canonical.

Therefore:

- use this document as **current implementation truth**;
- do not treat every Albanian lincat here as an ideal long-term RGL design;
- do not infer constructor availability from shape alone;
- do not infer helper compatibility from family resemblance alone;
- when redesigning, record the change in the decision log and update this reference.

---

## 8. Minimal lookup sheet

## 8.1 If the target category is...

- `CN` → preserve noun table + `g`
- `AP` → preserve species/case/gender/number table
- `NP` → preserve case table + agreement
- `Pron` → preserve case table + agreement + clitic fields
- `Comp` → string reduction is expected
- `Prep` → surface-string runtime behavior, but use `mkPrep` / `PrepNP`
- `ListNP` → preserve case table + agreement
- `ListCN` → preserve noun table + gender
- `ListAP` → preserve AP table
- `Utt` → shallow result may allow surface composition, but input-category discipline still applies
- `DConj` → stop and verify constructor availability in the current module before using local `lin`
- `DAP` → treat as explicit shallow category, but do not reuse arbitrary NP/Det helpers on it

## 8.2 If a function takes...

- `Prep` + `NP` → current Albanian default after prep is accusative
- `A2` / `N2` / `V2*` → preserve `c2`
- `V3` / `N3` / `V2A` / `V2V` → preserve `c2`/`c3`
- `Pron` → remember pronoun-specific clitic fields
- `ListNP` / `ListCN` / `ListAP` → keep family-specific list shape, do not project down to the singular category

## 8.3 Before using a helper or `lin` pattern...

- confirm the exact category, not just the family
- confirm the category is actually constructible in the current module
- confirm the fields used by the pattern match the current Albanian shape
- prefer an existing Albanian constructor path when one already exists
- check the helper registry if the helper is shared or compatibility-based
- check the shallow-constructor matrix if the category is surface-oriented
- check the stale-comment tracker if an older comment is influencing the choice

---

## 9. Related control documents

This file is now part of a larger anti-drift control system.

Use it together with:

- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`  
  for exact constructor and helper discipline.

- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`  
  for allowed/forbidden implementation patterns.

- `ALBANIAN_HELPER_REGISTRY.md`  
  for exact helper inventory and status.

- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`  
  for shallow-category constructor availability.

- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`  
  for fragile, blocked, warning, provisional, or stable symbols.

- `ALBANIAN_STALE_COMMENT_TRACKER.md`  
  for known stale explanatory comments and their resolution status.

- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`  
  for inheritance-first and override-justification rules.

- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`  
  for regression coverage on category-shape and constructor-availability issues.

- `ALBANIAN_DECISION_LOG.md`  
  for accepted lessons that changed coding method.

---

## 10. Maintenance obligations

Update this file when any of the following changes:

- a lincat in `CatSqi.gf`,
- a base internal type in `ResSqi.gf`,
- a producer module establishes a new canonical constructor pattern,
- a shallow category turns out to be module-sensitive in constructor availability,
- a helper-type distinction becomes operationally important,
- a previously local category is promoted into wider documentation scope,
- or a compile failure changes the interpretation of a category family.

If a new failure changes the coding method rather than only one function, it must also be recorded in:
- `ALBANIAN_DECISION_LOG.md`,
- and, if relevant, the constructor/helper policy documents.

---

## 11. Compact summary

The current Albanian category story is:

- rich lexical and nominal/adjectival categories preserve real structure,
- many clause/sentence/question categories are flattened,
- `Prep` is shallow in runtime behavior but still producer-owned,
- `DAP` is explicitly shallow in the current snapshot,
- list categories split into rich and shallow families depending on ownership,
- `A` is not `AP`,
- shallow shape does not equal constructor license,
- and comments are secondary evidence only.

For coding, the shortest safe discipline is:

1. identify the exact target category,
2. identify whether that category is rich or shallow,
3. identify whether the category is base, producer-owned, or local,
4. verify constructor availability in the current module,
5. verify helper compatibility exactly,
6. preserve the full shape unless the target category is truly shallow.