# ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE

## Scope

This document records the **current Albanian category and lincat shapes** as evidenced by the uploaded codedump and audit artifacts. It is a **reference for implementation work**, not a redesign proposal.

Two rules govern its use:

1. Treat the **current codedump** as the source of truth for Albanian concrete shapes.
2. Distinguish between:
   - **abstract categories** from the RGL API,
   - **current Albanian concrete shapes** in `CatSqi.gf`,
   - **resource-level implementation types** in `ResSqi.gf`, and
   - **producer-owned list/helper categories** defined outside `CatSqi.gf`.

When coding, preserve the full concrete shape of the target category. Do not flatten categories to `Str` unless the current Albanian lincat really is string-shaped.

---

## Source hierarchy for this reference

1. `albanian/CatSqi.gf` — authoritative current lincat definitions.
2. `albanian/ResSqi.gf` — authoritative internal resource types used by `CatSqi.gf`.
3. Producer modules such as `NounSqi.gf`, `AdjectiveSqi.gf`, `VerbSqi.gf`, `SentenceSqi.gf`, `QuestionSqi.gf`, `ConjunctionSqi.gf`, `AdverbSqi.gf` — authoritative usage patterns for each category.
4. Compiled `CatSqi.gfo` and audit logs — confirmation and diagnostics.

---

## 1. Resource-level parameters and internal types (`ResSqi.gf`)

These are not all abstract categories, but they define the shapes that Albanian concrete categories reuse.

### Parameters

- `Species = Indef | Def`
- `Case = Nom | Acc | Dat | Ablat`
- `Gender = Masc | Fem`
- `GenNum = GSg Gender | GPl`
- `Tense = Pres | Past | Imperfect | Aorist`

### Agreement

- `Agr = {gn : GenNum ; p : Person}`
- Helper: `agrgP3 : Gender -> Number -> Agr`

### Core internal implementation types

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

### Practical consequences

- Albanian noun phrases are **case-sensitive**.
- Albanian common nouns (`CN`) are **not strings**; they are backed by `Noun` and therefore preserve `Species`, `Case`, `Number`, and `Gender`.
- Albanian adjective phrases (`AP`) are agreement tables, not strings.
- Albanian prepositions are currently **surface-string complements** via `Compl = {s : Str}`.

---

## 2. Base category reference (`CatSqi.gf`)

The table below records the current concrete Albanian lincats.

### 2.1 Noun-family and lexical categories

| Abstract category | Current Albanian lincat | Notes |
|---|---|---|
| `N` | `Noun` | Full noun table with `Species`, `Case`, `Number`, plus `g : Gender`. |
| `N2` | `Noun ** {c2 : Compl}` | Noun plus one complement slot. |
| `N3` | `Noun ** {c2,c3 : Compl}` | Noun plus two complement slots. |
| `CN` | `Noun` | Same shape as `N`. |
| `NP` | `{s : Case => Str ; a : Agr}` | Case-sensitive noun phrase with agreement. |
| `Pron` | `{s : Case => Str ; acc_clit, dat_clit : Str ; a : Agr}` | Pronoun with clitic fields. |
| `Det` | `{s : Case => Gender => Str ; spec : Species ; n : Number}` | Determiner is case- and gender-sensitive. |
| `Quant` | `{s : Case => Gender => Number => Str ; spec : Species}` | Quantifier is case/gender/number-sensitive. |
| `Num` | `{s : Str ; n : Number}` | Reduced numeral record in current Albanian. |
| `Card` | `{s : Str}` | Surface-string cardinal. |
| `ACard` | `{s : Str}` | Surface-string adjectival cardinal. |
| `Ord` | `{s : Str}` | Surface-string ordinal in current `CatSqi`. |
| `Predet` | `{s : Str}` | Surface-string predeterminer. |
| `DAP` | `{s : Str}` | Current Albanian snapshot keeps DAP string-shaped. |
| `GN` | `{s : Str}` | String-shaped. |
| `LN` | `{s : Str}` | String-shaped. |
| `PN` | `{s : Str}` | Proper name is surface string in current snapshot. |
| `SN` | `{s : Str}` | String-shaped. |

### 2.2 Adjective-family categories

| Abstract category | Current Albanian lincat | Notes |
|---|---|---|
| `A` | `Adj` | Resource-level adjective: `Case => Gender => Number => Str`, plus `clit : Bool`. |
| `A2` | `Adj ** {c2 : Compl}` | Adjective with complement. |
| `AP` | `{s : Species => Case => Gender => Number => Str}` | Full agreement table; preserve all four dimensions. |

### 2.3 Verb-family categories

| Abstract category | Current Albanian lincat | Notes |
|---|---|---|
| `V`, `VA`, `VV`, `VS`, `VQ` | `Verb` | Full resource-level verb record. |
| `V2`, `V2S`, `V2Q` | `Verb ** {c2 : Compl}` | One complement slot. |
| `V3`, `V2A`, `V2V` | `Verb ** {c2,c3 : Compl}` | Two complement slots. |
| `VP` | `{s : Str}` | Current Albanian snapshot flattens VP to surface string. |
| `VPSlash` | `{s : Str}` | Current Albanian snapshot flattens VPSlash to surface string. |
| `Comp` | `{s : Str}` | Complement phrase is surface-string shaped at category level. |

### 2.4 Clause, sentence, question, relative categories

| Abstract category | Current Albanian lincat | Notes |
|---|---|---|
| `S` | `{s : Str}` | Flattened in current `CatSqi`. |
| `QS` | `{s : Str}` | Flattened. |
| `RS` | `{s : Str}` | Flattened. |
| `SSlash` | `{s : Str}` | Flattened. |
| `Cl` | `{s : Str}` | Flattened. |
| `QCl` | `{s : Str}` | Flattened. |
| `RCl` | `{s : Str}` | Flattened. |
| `RP` | `{s : Str}` | Flattened. |
| `ClSlash` | `{s : Str}` | Flattened. |
| `IComp` | `{s : Str}` | Flattened interrogative complement. |
| `IP` | `{s : Str}` | Flattened interrogative phrase. |
| `IDet` | `{s : Str}` | Flattened interrogative determiner. |
| `IQuant` | `{s : Str}` | Flattened interrogative quantifier. |
| `Subj` | `{s : Str}` | Surface string. |
| `Conj` | `{s : Str}` | Surface string. |
| `DConj` | `{s : Str}` | Surface string. |
| `Imp` | `{s : Str}` | Flattened imperative. |

### 2.5 Adverbial and prepositional categories

| Abstract category | Current Albanian lincat | Notes |
|---|---|---|
| `Prep` | `Compl` | And `Compl = {s : Str}` in `ResSqi`. |
| `Adv` | inherited producer category, surface-used as `{s : Str}` in current modules | Check producer modules; most current Albanian code treats it stringwise. |
| `AdV` | inherited producer category, surface-used as `{s : Str}` in current modules | Same practical treatment in current code. |
| `IAdv` | inherited producer category, surface-used as `{s : Str}` in current modules | Same practical treatment in current code. |

### 2.6 Numeral categories

| Abstract category | Current Albanian lincat | Notes |
|---|---|---|
| `Numeral` | `{s : Str}` | Flattened numeral category. |
| `Digits` | `{s : Str ; n : Number ; tail : DTail}` | Carries number and digit-tail state. |
| `Decimal` | `{s : Str ; n : Number ; hasDot : Bool}` | Carries number and dot state. |

---

## 3. Producer-owned auxiliary and list categories

These are not declared in `CatSqi.gf`, but they are structurally important and must be documented because other modules rely on them.

### 3.1 Conjunction-owned list categories (`ConjunctionSqi.gf`)

| Category | Concrete shape | Notes |
|---|---|---|
| `ListS` | `{init : Str ; last : Str}` | String list. |
| `ListNP` | `{init : Case => Str ; last : Case => Str ; a : Agr}` | Case-sensitive NP list; preserves agreement. |
| `ListCN` | `{init : Species => Case => Number => Str ; last : Species => Case => Number => Str ; g : Gender}` | Preserves full CN table and gender. |
| `ListAP` | `{init : Species => Case => Gender => Number => Str ; last : Species => Case => Gender => Number => Str}` | Preserves full AP table. |
| `ListAdv` | `{init : Str ; last : Str}` | String list. |
| `ListAdV` | `{init : Str ; last : Str}` | String list. |
| `ListIAdv` | `{init : Str ; last : Str}` | String list. |
| `ListRS` | `{init : Str ; last : Str}` | String list. |
| `ListDAP` | `{init : Str ; last : Str ; spec : Species ; n : Number}` | Custom because current `DAP` is string-shaped. |

### 3.2 Question-owned auxiliary categories (`QuestionSqi.gf`)

| Category | Concrete shape | Notes |
|---|---|---|
| `QVP` | `{s : Str}` | Defined locally in `QuestionSqi.gf`; not in `CatSqi.gf`. |

### 3.3 Extend-owned auxiliary categories (current debugging context)

The current Albanian `ExtendSqi.gf` introduces additional local categories such as `VPS`, `VPI`, `VPS2`, `VPI2`, `X`, and several list-like helper categories. These are **module-local extension categories** and should not be treated as base Albanian category facts unless the extension layer is being documented separately.

---

## 4. Category usage patterns by producer module

This section records how the current Albanian implementation actually consumes and produces the shapes above.

### 4.1 `NounSqi.gf`

Key evidence:

- `DetCN det cn = { s = \\c => det.s ! c ! cn.g ++ cn.s ! det.spec ! c ! det.n ; a = agrgP3 cn.g det.n }`
- `AdjCN ap cn = { s = \\spec,c,n => cn.s ! spec ! c ! n ++ ap.s ! spec ! c ! cn.g ! n ; g = cn.g }`
- `UseN n = n`
- `UsePron p = p`

Consequences:

- `CN` preserves full noun morphology.
- `NP` is always case-sensitive and carries agreement.
- `AP -> CN -> CN` composition must preserve `Species`, `Case`, `Number`, and `Gender`.

### 4.2 `AdjectiveSqi.gf`

Key evidence:

- `PositA` returns an `AP` whose `s` field depends on `Species`, `Case`, `Gender`, `Number`.
- `ComplA2` keeps the AP table and appends the complement.
- `SentAP` also preserves AP shape: sentence complement is appended inside the AP table.

Consequences:

- Albanian `AP` is not safely reducible to `Str` unless the target category explicitly wants a string-shaped complement.
- `AdjOrd` and `SentAP` patterns show the adjective producer module is the right reference for AP-preserving composition.

### 4.3 `VerbSqi.gf`

Key evidence:

- `CompNP np = {s = npNom np}`
- `CompAP ap = {s = apPred ap}`
- `CompCN cn = {s = cnPred cn}`
- `CompAdv adv = {s = adv.s}`
- `UseComp c = {s = join copula c.s}`

Consequences:

- In current Albanian, `Comp` is the canonical place where AP/CN/NP/Adv are reduced to a predicate-like string.
- If a function returns `Comp`, flattening to `Str` is expected.
- If a function returns `AP` or `CN`, flattening is usually wrong.

### 4.4 `SentenceSqi.gf`

Key evidence:

- `PredVP np vp = {s = np.s ! Nom ++ sep ++ vp.s}`
- `UseCl temp pol cl = {s = cl.s}`
- `EmbedVP vp = {s = vp.s}`

Consequences:

- In the current snapshot, clause and sentence layers are heavily string-flattened.
- This is a **current Albanian design fact**, not necessarily an ideal RGL shape.
- When debugging, honor the actual Albanian lincat first, then decide whether a redesign is needed.

### 4.5 `AdverbSqi.gf`

Key evidence:

- `PrepNP p np = {s = p.s ++ npAfterPrep p np}`
- `npAfterPrep : Prep -> NP -> Str = \_,np -> np.s ! Acc`

Consequences:

- Albanian `Prep` is string-like.
- NP after preposition is structurally realized via `Acc` in current Albanian code.
- Any prep-based extension should check this default before inventing a new case policy.

---

## 5. Category preservation rules

These are the practical anti-drift rules implied by the current Albanian shapes.

### 5.1 Safe reductions to `Str`

Usually safe only when the target category itself is string-shaped:

- `Comp`
- `S`, `QS`, `RS`, `Cl`, `QCl`, `RCl`, `ClSlash`, `SSlash`
- `IComp`, `IP`, `IDet`, `IQuant`
- `Card`, `Ord`, `Predet`, many structural categories

### 5.2 Categories that must usually preserve internal tables

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

### 5.3 Complement-bearing lexical categories

Preserve complement slots:

- `N2`, `N3`
- `A2`
- `V2`, `V2S`, `V2Q`
- `V3`, `V2A`, `V2V`

### 5.4 Current Albanian simplification boundary

The current Albanian snapshot uses a strong simplification line:

- lexical/morphological categories (`Noun`, `Adj`, `Verb`, `NP`, `Det`, `Quant`) keep rich structure;
- many clause-, sentence-, and interrogative-level categories are flattened to `{s : Str}`.

This boundary is the single most important fact to preserve during maintenance.

---

## 6. High-risk categories for coding and debugging

### `CN`

Current shape:
- `Species => Case => Number => Str`
- plus `g : Gender`

Common mistake:
- returning `{s : Str}` or a partial record where full noun morphology is expected.

### `AP`

Current shape:
- `Species => Case => Gender => Number => Str`

Common mistake:
- using only nominative masculine singular as if it were the whole category.

### `NP`

Current shape:
- `Case => Str`
- `a : Agr`

Common mistake:
- dropping agreement or hard-coding nominative where the function should preserve case.

### `Prep`

Current shape:
- `Compl = {s : Str}`

Common mistake:
- assuming rich prep metadata exists at runtime in Albanian.

### `Comp`

Current shape:
- `{s : Str}`

Common mistake:
- over-preserving AP/CN shape when the target category is actually already reduced.

---

## 7. Snapshot caveats

This document records the **current codedump**, which includes simplifications and local approximations.

Examples:

- Many sentence/question categories are flattened to `{s : Str}`.
- `DAP` is string-shaped in the current snapshot.
- `QVP` is defined locally in `QuestionSqi.gf`, not globally in `CatSqi.gf`.

Therefore:

- use this document as **current implementation truth**;
- do not treat every Albanian lincat here as an ideal long-term RGL design;
- when redesigning, record the change in the decision log and update this reference.

---

## 8. Minimal lookup sheet

### If the target category is...

- `CN` → preserve noun table + `g`
- `AP` → preserve species/case/gender/number table
- `NP` → preserve case table + agreement
- `Comp` → string reduction is expected
- `Prep` → surface string only
- `ListNP` → preserve case table + agreement
- `ListCN` → preserve noun table + gender
- `ListAP` → preserve AP table

### If a function takes...

- `Prep` + `NP` → current Albanian default after prep is accusative
- `A2` / `N2` / `V2*` → preserve `c2`
- `V3` / `N3` / `V2A` / `V2V` → preserve `c2`/`c3`

---

## 9. Recommended documentation cross-links

This file should be read together with:

- `ALBANIAN_LANGUAGE_ARCHITECTURE.md`
- `ALBANIAN_MORPHOLOGY_SPEC.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_MODULE_DEPENDENCY_MAP.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`

---

## 10. Evidence used

Primary codedump and audit sources used for this reference:

- `albanian/CatSqi.gf`
- `albanian/ResSqi.gf`
- `albanian/NounSqi.gf`
- `albanian/AdjectiveSqi.gf`
- `albanian/VerbSqi.gf`
- `albanian/SentenceSqi.gf`
- `albanian/AdverbSqi.gf`
- `albanian/ConjunctionSqi.gf`
- `albanian/QuestionSqi.gf`
- compiled artifact references such as `raw/artifacts/gfo/CatSqi.gfo`

