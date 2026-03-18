# ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES

Status: working specification for GF Albanian concrete syntaxes, with priority on constructor discipline, category-shape preservation, and anti-drift rules for implementation.

Scope:
- primary target: `GF/lib/src/albanian/*`
- especially relevant to: `CatSqi.gf`, `NounSqi.gf`, `AdjectiveSqi.gf`, `AdverbSqi.gf`, `SentenceSqi.gf`, `QuestionSqi.gf`, `SyntaxSqi.gf`, `ConjunctionSqi.gf`, `ExtraSqi.gf`, `StructuralSqi*.gf`, `ExtendSqi.gf`
- intended use: guide new implementations, override decisions, and bug-fixing without drifting away from the actual Albanian category system

---

## 1. Core principle

Albanian concrete syntax must be implemented by preserving the real category shape of the target lincat.

Do not treat GF constructors as string templates unless the target category is genuinely string-like.

In practice this means:
- if the target is `NP`, return an Albanian `NP`
- if the target is `CN`, preserve the noun table and gender
- if the target is `AP`, preserve the adjective table and agreement dimensions
- if the target is `Adv`, `Comp`, `Cl`, `S`, `QS`, etc., use the inherited constructor path when one exists

The default bias is:
1. abstract signature first
2. inherited `ExtendFunctor` / grammar constructor path second
3. Albanian lincat shape third
4. model-language analogy only after those three

---

## 2. Category-shape preservation rules

### 2.1 CN

A common Albanian noun phrase head is not a flat string.

Implementation rule:
- preserve noun inflection tables and gender unless the abstract function clearly returns a string-like category

Allowed pattern:
- `lin CN { s = \spec,c,n => ... ; g = ... }`

Forbidden pattern:
- using `cnStr` and then pretending the result is still a `CN`

Use `cnStr` only when the target category is actually string-like.

### 2.2 AP

Albanian APs are agreement-sensitive.

Implementation rule:
- preserve species, case, gender, and number dimensions for AP-returning functions

Allowed pattern:
- `lin AP { s = \spec,c,g,n => ... }`

Forbidden pattern:
- flattening an AP to one nominative masculine singular form and then returning it as AP

Use `apStr` only when the target category is actually string-like.

### 2.3 NP

Albanian NP is case-sensitive and carries agreement.

Implementation rule:
- preserve `s : Case => Str`
- preserve or recompute `a : Agr`

Allowed pattern:
- `lin NP { s = \c => ... ; a = ... }`

Forbidden pattern:
- returning `{s = ...}` with one string where an NP is required

### 2.4 RNP and RNPList

When inherited from `ExtendFunctor`, treat:
- `RNP` as `NP`
- `RNPList` as `ListNP`

Implementation rule:
- if using inherited strategy, all `RNP` functions must behave as NP/ListNP constructors
- do not mix string-based `RNP` values with inherited `NP`-based ones

### 2.5 String-like categories

Only these should be implemented by direct string concatenation without further structural fields:
- explicitly string-based local helper categories
- simple adverbial/complement-like records known to be `{s : Str}`
- local list helper categories already defined as `{s : Str}` in the module

Even here, use inherited constructors when available, because they preserve interaction with the broader grammar.

---

## 3. Constructor strategy hierarchy

For every function, use this decision order.

### 3.1 First choice: inherited grammar path

If the inherited grammar already gives a constructor path, use it.

Examples of preferred style:
- use `CompAP` instead of flattening AP yourself
- use `CompCN` instead of flattening CN yourself
- use `PrepNP` with the appropriate NP constructor instead of inventing a parallel prepositional encoding
- use `ExistNP`, `ExistIP`, `UseCl`, `UseQCl`, `QuestCl`, `PredVP`, `UseComp`, `CompAdv`, `AdvVP` when those match the abstract signature

### 3.2 Second choice: Albanian-preserving local construction

If there is no inherited constructor path, construct a full Albanian value of the target category.

Examples:
- full `lin CN`
- full `lin AP`
- full `lin NP`
- full `lin ListNP`

### 3.3 Third choice: model-language-guided custom implementation

Only if neither of the above is enough:
- inspect the same function family in Bulgarian or German
- copy structure, not language-specific morphology

---

## 4. Rules by constructor family

### 4.1 Existential family

Functions:
- `ExistS`
- `ExistNPQS`
- `ExistIPQS`
- `ExistCN`
- `ExistMassCN`
- `ExistPluralCN`
- `ExistsNP`

Rule:
- these are clausal/question constructors, not string wrappers
- prefer `ExistNP`, `ExistIP`, `UseCl`, `UseQCl`, `QuestCl`, and ordinary NP constructors

Do not:
- implement them as `{s = ...}` by concatenating tense/polarity/question material manually unless the inherited path is impossible

### 4.2 AP/CN conversion family

Functions:
- `ICompAP`
- `CompBareCN`
- `AdjAsCN`
- `AdjAsNP`
- `PredAPVP`
- `AdvIsNPAP`
- `CompoundAP`
- `CardCNCard`
- `N2VPSlash`

Rule:
- this is the highest-risk family for category drift
- preserve target category shape
- avoid helper-driven flattening (`apStr`, `cnStr`, `apConst`, `cnConst`) unless the target is really string-like

Preferred style:
- `CompAP`, `CompCN`, `UseComp`, `PredVP`, `AdvVP`, ordinary CN/NP builders

Do not:
- return a CN where the abstract says `Card`
- return a string-like complement by manufacturing a CN/AP record
- treat these functions as lexical paraphrases only

### 4.3 Preposition family

Functions include:
- `PrepCN`
- any local `PrepNP`-like usage
- preposition-bearing adverb/AP/NP constructors

Rule:
- follow Albanian preposition behavior already established in core modules
- when possible, build through `PrepNP`
- if a CN is used under a preposition, prefer the inherited path or a bare/mass NP strategy rather than inventing a fake noun category

### 4.4 Reflexive NP family

Functions:
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

Rule:
- treat as one subsystem
- do not redesign only one member in isolation
- if inherited `RNP = NP` and `RNPList = ListNP` are used, all members must follow that representation coherently

### 4.5 Participle and nominalization family

Functions:
- `PresPartAP`
- `PastPartAP`
- `PastPartAgentAP`
- `NominalizeVPSlashNP`
- `GerundCN`
- `GerundNP`
- `GerundAdv`

Rule:
- choose one target category and fully realize it
- if producing AP, preserve AP shape
- if producing NP/CN, preserve those shapes
- do not reuse one string constant across multiple structurally different outputs unless the abstract meaning genuinely licenses it

---

## 5. Albanian-specific syntactic rules

### 5.1 Case-sensitive NP realization

When a constructor returns `NP`, the implementation must usually expose a case function.

Rule:
- use `np.s ! c` style consistently
- if the implementation hardcodes one case, only do so when the abstract function semantically fixes that case

### 5.2 CN realization

Rule:
- noun realization typically depends on `Species`, `Case`, and `Number`
- gender remains a property of the noun record, not a realized output dimension

### 5.3 AP realization

Rule:
- AP realization depends on `Species`, `Case`, `Gender`, and `Number`
- any AP constructor that ignores one of these must have a strong reason

### 5.4 Agreement propagation

Rule:
- if an output record has agreement metadata, compute it from the controlling noun/pronoun/NP
- do not reuse arbitrary default agreement if the input already determines it

Safe default only when unavoidable:
- masculine singular third-person agreement for semantically default nominalizations or neutralized outputs

### 5.5 Preposition government

Rule:
- follow the Albanian core behavior for case selection after prepositions
- if core Albanian code already enforces a case after `Prep`, mirror that behavior instead of introducing a new one locally

### 5.6 Relative and subordinate attachment

Rule:
- when attaching relative or subordinate material to NP/CN/AP structures, preserve the host category and append the subordinate material in the category’s realization space
- do not convert the host to a string unless the target category is string-like

---

## 6. Local helper policy

Helpers such as `cnStr`, `apStr`, `npConst`, `cnConst`, `apConst`, and similar are permitted, but under strict conditions.

### 6.1 Safe use of flattening helpers

Allowed:
- deriving a string for a function whose target is truly `{s : Str}`
- temporary debugging and probing
- clearly documented fallback implementations

Forbidden:
- using flattening helpers as the main implementation path for AP/CN/NP-returning constructors
- creating category-shaped outputs from flattened strings if the category carries more structure or lock fields

### 6.2 Safe use of constant record builders

Allowed:
- genuinely invariant lexical objects
- emergency placeholder implementations that are clearly marked as such

Forbidden:
- long-term implementations of high-level syntax constructors when inherited or Albanian-native category constructors exist

---

## 7. Lock-field discipline

If the compiler warns about `lock_AP`, `lock_CN`, or similar hidden fields, treat it as a structural warning, not a cosmetic one.

Rule:
- a lock warning usually means a function is manufacturing an incomplete category record
- the preferred repair is not “add one more field manually”, but “rebuild through the right constructor path or use the full category shape already used in Albanian core modules” 

Interpretation rule:
- repeated lock warnings across a family indicate category drift
- one-off lock warnings in a `variants {}` area may still be acceptable temporarily, but they should remain tracked in the open-questions file

---

## 8. Override rules for `ExtendSqi`

### 8.1 When to override

Override only if one of these is true:
- `ExtendFunctor` leaves the function as `variants {}`
- Albanian word order/case behavior requires a real language-specific change
- inherited composition exists but yields the wrong Albanian structure or meaning

### 8.2 When not to override

Do not override if the only reason is:
- it is easy to write with strings
- the inherited path looks verbose
- a model language has a custom override but Albanian does not need one

### 8.3 What every override must state

For each override, document:
- abstract signature
- target category
- inherited/default path if known
- why Albanian needs the override
- what category shape is being preserved

---

## 9. Model-language use rules

### 9.1 Bulgarian

Use Bulgarian as the primary structural reference for:
- minimal coordinated subsystems
- especially the `RNP` family

Why:
- Bulgarian often gives a smaller structural pattern than German while still treating subsystems coherently

### 9.2 German

Use German as a secondary structural reference for:
- rich customized override families
- category-preserving architecture when a subsystem truly needs a custom record shape

Do not:
- copy German field inventory into Albanian unless Albanian lincats require it

### 9.3 Cross-language comparison rule

When inspecting a model language:
- copy the category strategy
- do not copy the morphology
- do not copy language-specific agreement/case features without Albanian evidence

---

## 10. Forbidden implementation patterns

The following are anti-patterns and should be rejected during review.

1. Returning `CN` when the abstract signature returns `Adv`, `Comp`, `Card`, or other non-CN categories.
2. Returning `{s : Str}` where the target category is `NP`, `CN`, `AP`, `ListNP`, or any structured category.
3. Flattening AP/CN to one form and then rebuilding them as if no information was lost.
4. Mixing inherited `NP/ListNP`-based `RNP` functions with raw string-based ones.
5. Ignoring agreement metadata when the input already determines it.
6. Copying a model-language override solely by name.
7. Treating compiler lock warnings as harmless if they recur across a family.
8. Using a custom override when `ExtendFunctor` already provides a compositionally correct constructor path.

---

## 11. Review checklist for any new constructor implementation

Before accepting an implementation, verify all of the following:

1. The abstract signature is recorded.
2. The target category is correct.
3. The result preserves the real Albanian lincat shape.
4. If `ExtendFunctor` has a constructor path, that path was considered first.
5. If a model language was used, the copied element is structural, not lexical.
6. No AP/CN/NP value was flattened unnecessarily.
7. Agreement and case behavior match Albanian core rules.
8. No lock-field warning is introduced, or if one remains, it is documented as temporary and justified.

---

## 12. Minimal resolution strategy when debugging

When a constructor fails, use this order:

1. read the exact abstract signature
2. inspect inherited `ExtendFunctor` composition if present
3. inspect Albanian lincat shape in core modules
4. inspect same constructor family in Bulgarian, then German if needed
5. implement the least invasive category-correct fix
6. recompile
7. resolve lock warnings before moving to unrelated functions

---

## 13. Final rule

The Albanian syntax implementation is considered healthy only when:
- constructors follow abstract signatures exactly
- outputs preserve Albanian category shapes
- inherited grammar paths are used whenever available
- local overrides are coherent by family
- compiler warnings no longer indicate structural drift

This file is normative for constructor design. If code and this file disagree, update the code or record an explicit decision in `ALBANIAN_DECISION_LOG.md`.
