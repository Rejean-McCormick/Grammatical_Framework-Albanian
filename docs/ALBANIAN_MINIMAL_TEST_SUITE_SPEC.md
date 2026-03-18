# ALBANIAN_MINIMAL_TEST_SUITE_SPEC

## 1. Purpose

This document defines the **minimum required test suite** for the Albanian GF concrete syntax.
Its purpose is to prevent regressions, reduce implementation drift, and ensure that changes made in one module do not silently break assumptions in another.

This is a **language-wide** test specification, but it is especially shaped by the failure modes observed in the Albanian codedump and compile runs:

- category-shape mismatches between `Str` and full GF records,
- misuse of flattened helpers where full AP/CN/NP values are required,
- hidden record-field loss (`lock_AP`, `lock_CN`),
- incorrect handling of inherited `ExtendFunctor` defaults,
- subsystem inconsistency in `RNP`/`RNPList`,
- existential and complement builders implemented as surface strings instead of category-correct values.

The suite is intentionally **minimal**: it should be cheap enough to run often, but strong enough to catch the most expensive classes of Albanian breakage.

---

## 2. Normative status

This file is normative for Albanian testing.

A change to Albanian GF code is **not complete** unless:

1. the relevant module compiles,
2. the relevant family-specific tests in this document pass,
3. no new `lock_AP` / `lock_CN` warnings are introduced,
4. no category-flattening regression is introduced,
5. subsystem-level invariants in this document are preserved.

---

## 3. Source alignment

This test suite is aligned to the Albanian codedump and the uploaded reference material.

### 3.1 Albanian category facts that tests must respect

The suite assumes the following Albanian category facts:

- `Prep = Compl`
- `CN = Noun`
- `N = Noun`
- `N2 = Noun ** {c2 : Compl}`
- `NP = {s : Case => Str; a : Agr}`
- `AP` is not a flat string category; its `s` field is indexed by species, case, gender, and number
- `IComp = {s : Str}`
- `Card = {s : Str}`
- `Predet = {s : Str}`
- Albanian `PrepNP` uses the preposition surface plus NP after-preposition form, with accusative selected after a preposition

### 3.2 Extend-specific alignment assumptions

The suite also assumes:

- inherited `ExtendFunctor` defaults must be preferred whenever they exist and are category-correct,
- functions left as `variants {}` in `ExtendFunctor` require language-specific implementations and therefore need stronger tests,
- `RNP = Grammar.NP` and `RNPList = Grammar.ListNP` is the default inherited strategy unless explicitly replaced by a coherent Albanian subsystem.

---

## 4. Test philosophy

The Albanian suite is built on four layers.

### 4.1 Compile-shape tests
These verify that the module type-checks and that concrete categories preserve their required shape.

### 4.2 Family tests
These verify that each fragile subsystem remains internally coherent.

### 4.3 Constructor-path tests
These verify that implementations use category-correct constructor paths rather than ad-hoc string concatenation.

### 4.4 Regression tests
These verify previously failing Albanian cases such as `PrepCN`, `ReflPoss`, `Base_rr_RNP`, `PredAPVP`, `ExistS`, and `CardCNCard`.

---

## 5. Required test environments

At minimum, Albanian changes must be checked in these environments:

1. **Direct compile test**
   - compile the changed Albanian module directly.

2. **Whole Albanian compile smoke test**
   - compile all Albanian modules required for `LangSqi` / `AllSqi`.

3. **Cross-reference structural comparison**
   - inspect the corresponding function family in at least one model language when the Albanian change touches a `variants {}` gap.

---

## 6. Mandatory compile gates

Every Albanian change must pass these compile gates.

### Gate A — hard compile success

The target module must compile with no hard type errors.

### Gate B — no new shape warnings

The change must not introduce any new warnings of these forms:

- `missing lock field lock_AP`
- `missing lock field lock_CN`
- `record type expected in type checking instead of ...`
- `expected: {s : Str} | inferred: ... CN/AP/NP record`
- `table type expected for table instead of Str`

### Gate C — no category downgrade

No function may be changed from returning a full category to returning a string-like record unless the abstract signature and Albanian lincat truly allow it.

Examples of forbidden downgrade patterns that tests must catch:

- AP or CN collapsed to a single string where a full AP/CN is expected,
- NP-like outputs turned into `{s : Str}` stand-ins,
- adverbial outputs incorrectly rebuilt as noun records,
- complement outputs incorrectly rebuilt as noun/adjective records.

---

## 7. Minimal warning budget

The target state for Albanian is:

- **0 hard type errors**
- **0 `lock_AP` warnings**
- **0 `lock_CN` warnings**

Warnings such as `function AdjOrd is not in abstract`, `function SentAP is not in abstract`, or similar local-extension warnings may be tolerated only if they are intentional and documented in:

- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_OPEN_QUESTIONS.md`

No type-shape warning is acceptable as part of a “passing” state.

---

## 8. Test families

### 8.1 Category-shape preservation family

#### Goal
Catch AP/CN/NP flattening regressions.

#### Target functions
- `ICompAP`
- `CompBareCN`
- `FocusAP`
- `PredAPVP`
- `AdjAsCN`
- `AdjAsNP`
- `AdvIsNPAP`
- `N2VPSlash`
- `CompoundAP`
- `CardCNCard`

#### Required checks
For each of the functions above:

1. verify that the output category matches the abstract signature,
2. verify that no hidden-field warnings appear,
3. verify that helper paths do not reduce AP/CN to `Str` unless the target category is truly string-like,
4. verify that the implementation preserves Albanian category shape or delegates to a known-correct inherited constructor path.

#### Regression triggers
This family must be rerun whenever any of these change:

- `CatSqi.gf`
- `ResSqi.gf`
- `NounSqi.gf`
- `AdjectiveSqi.gf`
- `ExtendSqi.gf`

---

### 8.2 Existential family

#### Goal
Catch wrong clause/question construction in existential forms.

#### Target functions
- `ExistS`
- `ExistNPQS`
- `ExistIPQS`
- `ExistCN`
- `ExistMassCN`
- `ExistPluralCN`
- `ExistsNP`

#### Required checks
1. `ExistS` must build a clause-level output, not a raw surface string wrapper.
2. `ExistNPQS` must build a question/clause output, not a raw NP-to-string wrapper.
3. `ExistIPQS` must build a question/clause output, not a raw IP-to-string wrapper.
4. `ExistCN` / `ExistMassCN` / `ExistPluralCN` must not lose CN lock fields through illicit flattening.
5. inherited `ExtendFunctor` paths should be used wherever category-correct.

#### Minimal example coverage
Test singular count noun, plural noun, mass noun, and explicit NP existential cases.

---

### 8.3 Prep and adverb family

#### Goal
Catch preposition-government and complement-category regressions.

#### Target functions
- `PrepCN`
- `PrepNP`
- `AdvIsNP`
- `AdvIsNPAP`
- `AdvRNP`
- `AdvRVP`
- `AdvRAP`

#### Required checks
1. Albanian preposition behavior must stay aligned with accusative after prepositions.
2. `PrepCN` must return the category required by the abstract function, not an improvised noun-like output.
3. any change that touches `Prep`, `Compl`, or NP-after-prep behavior must rerun this family.

#### Minimal example coverage
- preposition + NP
- preposition + bare noun / mass noun
- adverbial predication with NP
- AP/VP/RNP prepositional modification

---

### 8.4 RNP subsystem family

#### Goal
Ensure the reflexive noun phrase subsystem remains coherent.

#### Target functions
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
- `Base_rr_RNP`
- `Base_nr_RNP`
- `Base_rn_RNP`
- `Cons_rr_RNP`
- `Cons_nr_RNP`
- `Cons_rn_RNP`

#### Required checks
1. the whole family must share one coherent concrete strategy,
2. `RNP` and `RNPList` must not be partially stringified,
3. list constructors must return actual `ListNP`-compatible values if Albanian inherits `RNPList = ListNP`,
4. no function in the family may be “fixed in isolation” if the change alters representation assumptions.

#### Minimal example coverage
- bare reflexive pronoun
- reflexive possessive with singular and plural nouns
- predeterminer + reflexive NP
- coordinated reflexive NP list
- one AP-consuming and one VP-consuming reflexive case

---

### 8.5 AP/CN conversion family

#### Goal
Ensure transitions between adjectives, noun phrases, and complements preserve category shape.

#### Target functions
- `ICompAP`
- `AdjAsCN`
- `AdjAsNP`
- `PredAPVP`
- `CompoundAP`
- `SentAP`

#### Required checks
1. AP values must preserve Albanian AP shape and hidden fields,
2. CN values must preserve Albanian noun table shape and gender,
3. conversions must be documented as either inherited-constructor-based or explicitly Albanian-specific.

#### Minimal example coverage
- adjective used predicatively,
- adjective nominalized as CN,
- adjective nominalized as NP,
- adjective compounded with noun material,
- AP plus sentence complement.

---

### 8.6 Slash, participle, and nominalization family

#### Goal
Catch shape regressions in VP/VPSlash-derived outputs.

#### Target functions
- `PastPartAP`
- `PastPartAgentAP`
- `PassVPSlash`
- `PassAgentVPSlash`
- `NominalizeVPSlashNP`
- `ProgrVPSlash`
- `A2VPSlash`
- `N2VPSlash`
- `ComplSlashPartLast`

#### Required checks
1. AP-producing functions must preserve AP shape,
2. NP-producing functions must preserve NP shape,
3. slash/verb complement outputs must not be forced into noun-like or adjective-like records unless justified by the abstract signature.

---

## 9. Minimal example matrix

Every test run must cover at least one example for each of the following semantic patterns.

### 9.1 Count noun vs mass noun vs plural noun
Used to cover:
- `ExistCN`
- `ExistMassCN`
- `ExistPluralCN`
- `PrepCN`
- `CardCNCard`

### 9.2 AP predication
Used to cover:
- `ICompAP`
- `PredAPVP`
- `AdvIsNPAP`
- `SentAP`

### 9.3 Reflexive possession
Used to cover:
- `ReflPoss`
- `PossPronRNP`
- `PredetRNP`
- `ConjRNP`

### 9.4 Prepositional government
Used to cover:
- `PrepNP`
- `PrepCN`
- `AdvRNP`
- `AdvRVP`
- `AdvRAP`

### 9.5 Noun/adjective conversions
Used to cover:
- `AdjAsCN`
- `AdjAsNP`
- `CompoundAP`
- `N2VPSlash`

---

## 10. Required regression set

The following previously observed Albanian failure sites are **permanent regression tests**.

### Regression set A — direct failures previously observed
- `PrepCN`
- `ReflPoss`
- `Base_rr_RNP`
- `Base_nr_RNP`
- `Base_rn_RNP`
- `PredAPVP`
- `ExistS`
- `ExistNPQS`
- `ExistIPQS`
- `CardCNCard`

### Regression set B — warning clusters previously observed
- `ICompAP`
- `FocusAP`
- `N2VPSlash`
- `ExistCN`
- `ExistMassCN`
- `ExistPluralCN`
- `CompoundAP`
- `CompBareCN`
- `AdvIsNPAP`
- `AdjAsCN`
- `AdjAsNP`

Any future change touching any of these must rerun the full Albanian minimal suite.

---

## 11. Model-language comparison requirement

For any Albanian function that is left as `variants {}` in `ExtendFunctor` or otherwise lacks a safe inherited default, at least one model-language comparison is required before finalizing the implementation.

### Preferred comparison policy

- **Bulgarian first** for minimal structural comparison, especially for `RNP`-family behavior.
- **German second** when a richer structural subsystem is needed for comparison.

### Comparison rule

A model language may be used to understand:
- subsystem boundaries,
- category representation strategy,
- constructor grouping,
- coordination/list behavior,
- reflexive subsystem design.

A model language may **not** be copied blindly when:
- its category inventory is richer than Albanian,
- it carries extra fields not present in Albanian core categories,
- its agreement or case system differs materially from Albanian.

---

## 12. Required evidence per test failure

When a test fails, the repair note must record:

1. failing function name,
2. abstract signature,
3. target concrete category,
4. Albanian lincat involved,
5. whether `ExtendFunctor` has a default constructor path or `variants {}` gap,
6. Albanian module dependencies touched,
7. if applicable, the model language consulted,
8. whether the failure was:
   - hard type error,
   - lock-field warning,
   - category downgrade,
   - subsystem inconsistency,
   - surface-order bug.

---

## 13. Test execution order

The minimal Albanian suite should be run in this order.

### Phase 1 — compile and shape
1. compile `ExtendSqi.gf`
2. fail immediately on any hard type error
3. record all lock-field warnings

### Phase 2 — family triage
Run family checks in this order:

1. existential family
2. AP/CN conversion family
3. prep and adverb family
4. RNP subsystem family
5. slash/participle/nominalization family

This order is chosen because existential and AP/CN shape errors tend to produce the most misleading downstream failures.

### Phase 3 — whole-language smoke test
Compile Albanian language aggregation modules.

### Phase 4 — regression replay
Replay permanent regression set A and B.

---

## 14. Pass criteria

An Albanian change passes the minimal suite only if all of the following hold:

1. target module compiles,
2. no direct type errors remain,
3. no `lock_AP` warnings remain,
4. no `lock_CN` warnings remain,
5. no regression target reappears,
6. no function in a coherent subsystem is left in a mixed representation state,
7. all new overrides are documented in the decision log.

---

## 15. Failure triage rules

### Rule 1
If a function fails with a category-shape mismatch, first check whether `ExtendFunctor` already provides a constructor path.

### Rule 2
If the function belongs to a subsystem (`RNP`, existentials, AP/CN conversion), inspect the whole subsystem before patching a single member.

### Rule 3
If the error mentions `lock_AP` or `lock_CN`, assume the implementation is category-wrong until proven otherwise.

### Rule 4
If the implementation uses `apStr`, `cnStr`, `apConst`, or `cnConst`, verify that the target category is truly string-like or minimal; otherwise treat it as suspect.

### Rule 5
If Bulgarian and German disagree, Albanian should prefer the simplest structure compatible with Albanian lincats and inherited defaults.

---

## 16. Minimal suite maintenance rules

This document must be updated whenever any of the following happens:

- Albanian lincat shapes change,
- `ExtendSqi.gf` override set changes,
- a new fragile subsystem is discovered,
- a previous warning class is resolved or reintroduced,
- a new model-language dependency becomes preferred.

Any newly discovered Albanian failure mode must be added to:

- Section 10 (regression set), and
- the relevant family section in Section 8.

---

## 17. Immediate priority tests for the current Albanian state

Given the observed Albanian runs, the highest-priority minimal suite checks right now are:

1. `PredAPVP` category-shape test
2. `ExistS` / `ExistNPQS` / `ExistIPQS` existential tests
3. `CardCNCard` output-category test
4. `ICompAP` / `AdjAsCN` / `AdjAsNP` AP/CN conversion tests
5. `N2VPSlash` and `CompoundAP` shape-preservation tests
6. full `RNP` subsystem coherence test

These are the tests most likely to catch the next real Albanian blocker.

