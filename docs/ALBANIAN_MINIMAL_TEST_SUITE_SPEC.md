# ALBANIAN_MINIMAL_TEST_SUITE_SPEC

## Status

Normative minimum test specification for the Albanian GF concrete syntax.

This document defines the **minimum required test suite** for the Albanian grammar as it currently exists in the codedump and documentation bundle.

It is designed to be:

- small enough to run often,
- strong enough to catch the most expensive Albanian regressions,
- explicit enough that AI-assisted maintenance cannot quietly redefine “done” around a single passing compile,
- and tightly aligned with the rest of the Albanian documentation system.

This file is not a benchmark suite, not a gold corpus, and not a future-ideal test manifesto.  
It is the **minimum enforcement layer** required to prevent known Albanian drift.

It must be read together with:

- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_LANGUAGE_ARCHITECTURE.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`

---

## 1. Purpose

This document defines the **minimum required test suite** for the Albanian GF concrete syntax.
Its purpose is to prevent regressions, reduce implementation drift, and ensure that changes made in one module do not silently break assumptions in another.

This is a **language-wide** test specification, but it is especially shaped by the failure modes observed in the Albanian codedump and compile runs:

- category-shape mismatches between `Str` and full GF records,
- misuse of flattened helpers where full AP/CN/NP values are required,
- hidden record-field loss (`lock_AP`, `lock_CN`),
- structurally relevant preposition warnings such as `lock_Prep`,
- incorrect handling of inherited `ExtendFunctor` defaults,
- subsystem inconsistency in `RNP` / `RNPList`,
- existential and complement builders implemented as surface strings instead of category-correct values,
- exact helper-type mismatches such as using an `A` helper on an `AP` value,
- constructor/module-context mismatches such as assuming `lin Cat { ... }` is valid because a category looks surface-like in documentation,
- importer/downstream failures that are really caused by a direct failure in the changed module,
- stale comment or stale documentation assumptions treated as more authoritative than the current codedump and compiler,
- uncontrolled use of compatibility wrappers as if they were canonical rich-category constructors,
- and family-level breakage where one member is “fixed” but the rest of the subsystem is left incoherent.

The suite is intentionally **minimal**:
it should be cheap enough to run often, but strong enough to catch the most expensive classes of Albanian breakage.

---

## 2. Normative status

This file is normative for Albanian testing.

A change to Albanian GF code is **not complete** unless:

1. the directly changed module compiles,
2. the relevant family-specific tests in this document pass,
3. no new `lock_AP` / `lock_CN` warnings are introduced,
4. no new unreviewed `lock_Prep` warnings are introduced in touched modules,
5. no category-flattening regression is introduced,
6. no constructor-availability regression is introduced,
7. no exact-helper-type regression is introduced,
8. subsystem-level invariants in this document are preserved,
9. downstream importer cleanliness is rechecked when the edited module is publicly re-exported or façade-visible,
10. any touched warning-state symbol remains consistent with `ALBANIAN_SYMBOL_STATUS_LEDGER.md`,
11. any touched stale-comment zone is checked against `ALBANIAN_STALE_COMMENT_TRACKER.md`,
12. and any newly introduced helper or helper-like builder is classifiable under `ALBANIAN_HELPER_REGISTRY.md`.

A local “compiles for me” result is not sufficient.

---

## 3. Source alignment

This test suite is aligned to the Albanian codedump, the uploaded reference material, the current support docs, and the observed compile/audit runs.

### 3.1 Albanian category facts that tests must respect

The suite assumes the following Albanian category facts:

- `Prep = Compl`
- `CN = Noun`
- `N = Noun`
- `N2 = Noun ** {c2 : Compl}`
- `NP = {s : Case => Str ; a : Agr}`
- `Pron = {s : Case => Str ; acc_clit, dat_clit : Str ; a : Agr}`
- `AP` is not a flat string category; its `s` field is indexed by species, case, gender, and number
- many sentence/clause/question categories in the current Albanian snapshot are string-shaped
- `Comp = {s : Str}`
- `Card = {s : Str}`
- `Predet = {s : Str}`
- Albanian `PrepNP` uses the preposition surface plus NP after-preposition form, with accusative selected after a preposition
- `A` and `AP` are distinct Albanian categories and must not be treated as helper-interchangeable unless the helper signature matches exactly
- a documented simple category shape does not by itself guarantee that `lin Cat { ... }` is available in every module context; constructor availability must be checked in the current module and codedump
- list categories such as `ListNP`, `ListCN`, and `ListAP` must preserve their own concrete shapes and must not be silently collapsed into singular-category or flat-string approximations

### 3.2 Extend-specific alignment assumptions

The suite also assumes:

- inherited `ExtendFunctor` defaults must be preferred whenever they exist and are category-correct,
- functions left as `variants {}` in `ExtendFunctor` require language-specific implementations and therefore need stronger tests,
- `RNP = Grammar.NP` and `RNPList = Grammar.ListNP` is the default inherited strategy unless explicitly replaced by a coherent Albanian subsystem,
- `ExtendSqi.gf` is a thin coordinator and must not become a second grammar core,
- the VPS/VPI/VPS2/VPI2/list-wrapper family remains inherited in the current cycle unless architecture docs explicitly reopen it.

### 3.3 Evidence and authority assumptions

When multiple evidence sources disagree, the suite uses this order for implementation truth:

1. current compiler error and current source dump,
2. exact abstract signature,
3. current Albanian lincat and core constructor path,
4. architecture and implementation docs,
5. model-language comparison,
6. comments last.

A stale code comment or stale earlier note is **not** sufficient evidence to override current compile reality.

### 3.4 Support-doc integration assumptions

This suite assumes the support docs now exist and are authoritative in their own narrow scopes:

- `ALBANIAN_HELPER_REGISTRY.md` for helper exact-type and maturity classification,
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md` for shallow-category constructor safety,
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md` for fragile symbol status,
- `ALBANIAN_STALE_COMMENT_TRACKER.md` for comment-authority enforcement,
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md` for coverage awareness when a change touches under-extracted modules.

A test plan that ignores these companion docs is incomplete.

---

## 4. Test philosophy

The Albanian minimum suite is built on nine layers.

### 4.1 Compile-shape tests

These verify that the module type-checks and that concrete categories preserve their required shape.

### 4.2 Family tests

These verify that each fragile subsystem remains internally coherent.

### 4.3 Constructor-path tests

These verify that implementations use category-correct constructor paths rather than ad-hoc string concatenation.

### 4.4 Exact-helper-type tests

These verify that a helper is only reused when its exact category signature matches the use site.

### 4.5 Constructor-availability tests

These verify that shallow-looking categories are only constructed in module contexts where the constructor pattern is actually valid.

### 4.6 Warning-cluster tests

These verify that warnings like `lock_AP`, `lock_CN`, and `lock_Prep` are not silently reintroduced or expanded.

### 4.7 Downstream importer tests

These verify that the changed module’s importers/facades still compile and that a failure is not misclassified as “downstream only” when the direct cause is local.

### 4.8 Comment-authority tests

These verify that touched files are not using stale comments as stronger evidence than current source and current compile behavior.

### 4.9 Status-ledger tests

These verify that known fragile items remain consistent with the symbol ledger and that blocked symbols are not silently treated as stable.

---

## 5. Minimum run modes

The Albanian suite has three minimum run modes.

### 5.1 Mode A — touched module minimum

Run whenever a single file is edited.

Required:
- compile the touched module,
- check hard type errors,
- check warnings,
- run the family-specific tests for that module,
- run the nearest importer compile if the module is publicly re-exported or façade-visible,
- recheck any symbol-ledger entries touched by the change.

### 5.2 Mode B — subsystem minimum

Run whenever a whole family or companion layer is edited.

Required:
- compile every file in the affected family,
- run all family-internal regression cases,
- run the coordinator or structural façade that owns the family,
- rerun warning clusters related to that family,
- rerun exact helper-type checks and constructor-availability checks for that family.

### 5.3 Mode C — cycle validation minimum

Run before calling a repair cycle complete.

Required:
- compile all Albanian files,
- confirm targeted fragile regression set passes,
- confirm no newly expanded warning clusters,
- confirm façade modules still behave as thin façades/aggregators,
- confirm no blocked symbol from the ledger was silently promoted to stable use,
- confirm changed comments and docs do not contradict compile reality.

---

## 6. Required global checks

Every meaningful Albanian repair must pass the following global checks.

### 6.1 Direct compile check

The touched file must compile.

### 6.2 Nearest importer compile check

If the file is owned by or re-exported through a façade, compile the nearest importer/façade as well.

Examples:
- `ExtendSqiFocusPrep.gf` → `ExtendSqi.gf`
- `StructuralSqiClause.gf` → `StructuralSqi.gf`
- structural producer module → `StructuralSqi.gf`
- structural façade → `SyntaxSqi.gf` if user-facing behavior is implicated

### 6.3 Warning review check

Review:
- `lock_AP`
- `lock_CN`
- `lock_Prep`
- any new lock-like or shape-loss warnings

No new warning is accepted silently.

### 6.4 Exact-helper-type check

If a helper was introduced, reused, renamed, or touched:
- confirm exact helper type,
- confirm target category compatibility,
- confirm helper maturity/status if it appears in the helper registry,
- confirm the change does not upgrade a fallback helper into canonical rich-category usage.

### 6.5 Constructor-availability check

If a category is shallow-looking or built through a local `lin Cat { ... }` pattern:
- confirm the category is in scope in the current module,
- confirm the record fields are valid for the current module context,
- confirm the constructor path is already accepted or compile-proven,
- confirm that a safer producer/paradigm/core-module path was not bypassed.

### 6.6 Comment-authority check

If the touched file has explanatory comments:
- verify that current code and compile behavior still agree with them,
- otherwise update the comment or register the stale-comment issue.

### 6.7 Symbol-status check

If the touched symbol or pattern appears in `ALBANIAN_SYMBOL_STATUS_LEDGER.md`:
- obey the current status,
- do not silently promote `warning`, `temporary`, `fallback`, `incomplete`, or `blocked by compile reality` to “stable by use”.

---

## 7. Required test families

The minimum Albanian suite must contain all of these families.

## 7.1 Family A — category-shape preservation

Used to catch:
- `Str` used where a rich category is required,
- lost agreement fields,
- lost case tables,
- lost gender/species dimensions,
- partial record fabrication,
- dropped list-category structure.

Must cover at least:
- `CN`
- `AP`
- `NP`
- `Pron`
- `ListNP`
- `ListCN`
- `ListAP`

Required checks:
- no direct flattening of rich return categories,
- no replacement of list categories with singular categories,
- no hidden loss of agreement or lock-sensitive structure,
- no fake reconstruction from one surface cell.

## 7.2 Family B — inheritance/default alignment

Used to catch:
- replacing a valid inherited `ExtendFunctor` path with an unjustified local override,
- ignoring `variants {}` boundaries,
- reintroducing unsupported inherited families into local extension code.

Must cover:
- inherited `ExtendFunctor` defaults where they exist,
- `variants {}` functions that require local Albanian implementations,
- “do not create `ExtendSqiVPS.gf` / do not localize the VPS-family in this cycle” policy.

Required checks:
- default path preferred when category-correct,
- unsupported inherited families remain inherited,
- local override justifications exist where needed.

## 7.3 Family C — exact helper-type compatibility

Used to catch:
- `A` helper reused for `AP`,
- `N` or `CN` helper reused for `NP`,
- list helper reused for non-list categories,
- compatibility wrappers treated as final builders,
- near-type helper reuse by family resemblance.

Must cover:
- helper lookup against `ALBANIAN_HELPER_REGISTRY.md`,
- exact input/output category match,
- helper status classification,
- “presentation-only” vs “final rich-category constructor” distinction.

Required named checks:
- `FocusAP` exact-helper-type compatibility,
- at least one `CN`/`NP` distinction case,
- at least one list-vs-non-list distinction case,
- at least one compatibility-wrapper misuse case.

## 7.4 Family D — constructor/module-context availability

Used to catch:
- assuming `lin Cat { ... }` is safe because a category looks shallow in docs,
- borrowing a constructor pattern from one module into another,
- missing in-scope category availability,
- incorrect field assumptions for local constructor patterns.

Must cover:
- `DConj`
- `CAdv`
- shallow structural categories
- `Utt`-level builders
- any touched local structural constructor

Required checks:
- the constructor pattern is accepted in the actual current module,
- a safer producer/paradigm path is not bypassed,
- module-local opens/imports/aliases have been accounted for.

## 7.5 Family E — warning clusters

Used to catch:
- `lock_AP`
- `lock_CN`
- `lock_Prep`
- analogous structural warning clusters

Must cover:
- all touched files,
- all touched nearest importers,
- known high-risk zones such as prep/government, AP/CN conversions, and structural lexical items.

Required checks:
- warning count does not silently increase,
- old warning clusters are not spread to new files,
- lock warnings are treated as structural signals, not style noise.

## 7.6 Family F — façade / downstream cleanliness

Used to catch:
- direct failure masked as importer failure,
- façade breakage after a local change,
- false confidence from only compiling the leaf module.

Must cover:
- changed module,
- nearest importer,
- public façade if touched by the change,
- coordinator modules for `ExtendSqi`,
- structural façade for `StructuralSqi`.

Required checks:
- identify the direct cause,
- distinguish direct vs downstream failure,
- do not misclassify a direct type mismatch as an importer-only problem.

## 7.7 Family G — stale comment and stale doc discipline

Used to catch:
- stale comments relied on during implementation,
- documentation claims that no longer match current codedump,
- historical defaults treated as current truth.

Must cover:
- touched file if it contains explanatory comments,
- known stale-comment tracker entries when touched,
- at least one explicit comment-vs-current-code verification step.

Required checks:
- comments are not used as stronger evidence than current code/compiler,
- stale comment cases are updated or tracked,
- changes do not introduce new misleading explanatory text.

## 7.8 Family H — symbol-status compliance

Used to catch:
- using `warning` or `blocked` symbols as if they were settled,
- ignoring exit criteria for tracked fragile items,
- silently promoting temporary/fallback patterns into canonical usage.

Must cover:
- any touched symbol listed in `ALBANIAN_SYMBOL_STATUS_LEDGER.md`,
- any touched grouped warning zone,
- any façade file blocked by a tracked owner symbol.

Required checks:
- status label respected,
- exit criteria checked before calling item “resolved”,
- downstream effects documented when relevant.

## 7.9 Family I — module extraction awareness

Used to catch:
- overconfidence when touching under-extracted modules,
- assuming docs already fully define a module that is still coverage-incomplete.

Must cover:
- touched module against `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`,
- special caution path for `PENDING_TARGETED_EXTRACTION` and `PARTIALLY_EXTRACTED` modules.

Required checks:
- under-extracted modules trigger stricter source recheck,
- docs are not treated as deeper than they really are for those modules.

---

## 8. Required subsystem suites

The Albanian minimum test suite must include the following subsystem suites.

## 8.1 AP / CN / predicate conversion suite

Used to cover:
- `ICompAP`
- `PredAPVP`
- `AdjAsCN`
- `AdjAsNP`
- `CompoundAP`
- `CompBareCN`
- `CompIQuant`
- `AdvIsNPAP`
- any AP/CN reduction path that risks flattening rich categories too early

Must verify:
- exact target category preservation,
- no one-cell AP or CN reconstruction treated as full-category final output,
- helper compatibility where helper reuse is involved,
- lock warnings absent or explicitly reviewed.

## 8.2 Existential suite

Used to cover:
- `ExistS`
- `ExistNPQS`
- `ExistIPQS`
- `ExistsNP`
- `ExistCN`
- `ExistMassCN`
- `ExistPluralCN`

Must verify:
- family coherence,
- clause/question constructor path where expected,
- no silent string-only shortcuts where clause/category builders are expected,
- agreement with inherited/default existential strategy where applicable.

## 8.3 RNP suite

Used to cover:
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

Must verify:
- coherent use of the inherited `NP` / `ListNP` strategy unless a different coherent design is explicitly adopted,
- list-category preservation,
- no member left behind on a different representation,
- no ad hoc string-only list replacement.

## 8.4 Prepositional government suite

Used to cover:
- `PrepNP`
- `PrepCN`
- `AdvRNP`
- `AdvRVP`
- `AdvRAP`
- structural preposition items where relevant

Must verify:
- current Albanian after-preposition accusative behavior where appropriate,
- no invented case policy without evidence,
- no lock-warning expansion in touched prep zones,
- no mismatch between local behavior and structural export path.

## 8.5 Noun/adjective conversion suite

Used to cover:
- `AdjAsCN`
- `AdjAsNP`
- `CompoundAP`
- `N2VPSlash`
- and any category-border function that is likely to confuse family-neighbor categories

Must verify:
- category border is explicit,
- exact target preserved,
- no borrowed helper from a neighbor category without proof.

## 8.6 Focus/AP helper discipline suite

Used to cover:
- `FocusAP`
- any AP-surface helper used in `Utt`-returning functions
- exact `A` vs `AP` helper compatibility

Must verify:
- a shallow `Utt` target may use surface realization only if the helper/extractor is truly AP-compatible,
- an `A` helper must not be substituted by family resemblance,
- local AP extractors and helper-registry entries agree.

## 8.7 Structural closed-class constructor availability suite

Used to cover:
- `both7and_DConj`
- `either7or_DConj`
- `StructuralSqiClause`
- `StructuralSqi`
- other shallow structural lexical items when touched

Must verify:
- module-context constructor availability,
- no inferred `lin Cat { ... }` from lincat shape alone,
- structural façade compiles after clause/nominal/verbal structural edits.

## 8.8 Downstream importer cleanliness suite

Used to cover:
- direct changed module compile,
- nearest importer compile,
- identification of direct vs downstream failure source

Must verify:
- the test report names the first failing file,
- downstream failures are not misdiagnosed as primary when the root cause is local.

## 8.9 Comment-vs-code discipline suite

Used to cover:
- one touched file with explanatory comments,
- confirmation that current codedump and compiler are treated as authoritative when comments disagree,
- known stale-comment entries when touched.

Must verify:
- no stale comment drives constructor choice,
- touched comment hazards are updated or tracked,
- new comments added by a repair do not overstate certainty.

---

## 9. Required regression set

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
- `above_Prep`
- `after_Prep`
- `before_Prep`
- `behind_Prep`
- `between_Prep`
- `by8agent_Prep`
- `by8means_Prep`

### Regression set C — helper-type and module-context failures

- `FocusAP` used with an exact AP-compatible helper path
- `both7and_DConj`
- `either7or_DConj`
- `StructuralSqiClause` compile
- `StructuralSqi` compile

### Regression set D — status-ledger anchored items

- `must_VV`
- `fp_FocusAP`
- `mkDConj`
- any helper-family entry marked `warning`, `fallback`, `temporary`, or `blocked by compile reality`

### Regression set E — stale-comment anchored items

- currently tracked stale-comment entries in `ALBANIAN_STALE_COMMENT_TRACKER.md`
- at minimum, the already tracked `ConjunctionSqi.gf` / `DAP` comment hazard if touched

These are permanent regression checks because Albanian recently failed on:

- exact helper-type mismatch (`A` vs `AP`),
- constructor availability assumptions that were not valid in the actual module context,
- prep-related warning clusters that reflect structurally weak constructor handling,
- and stale explanatory assumptions treated as stronger than the current code.

Any future change touching any of these must rerun the full Albanian minimal suite.

---

## 10. Model-language comparison requirement

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

A model language must **not** be used to justify:

- copying foreign field inventories blindly,
- copying word order without Albanian evidence,
- copying rich hidden structure into Albanian categories that do not support it,
- or ignoring a current Albanian compile failure.

### Comparison-triggered test obligation

If a model-language comparison influenced the chosen Albanian implementation, the relevant subsystem test must record that comparison explicitly in its rationale or notes.

---

## 11. Minimum touched-file matrix

When a file is changed, the following minimum matrix applies.

### 11.1 If the touched file is a rich-category producer
Examples:
- `NounSqi.gf`
- `AdjectiveSqi.gf`
- `VerbSqi.gf`
- `ConjunctionSqi.gf`

Required:
- direct compile,
- category-shape preservation checks,
- warning review,
- nearest importer compile,
- helper registry review if helpers changed,
- stale-comment check if comments touched.

### 11.2 If the touched file is an `ExtendSqi` companion module
Examples:
- `ExtendSqiAPCN.gf`
- `ExtendSqiExistential.gf`
- `ExtendSqiRNP.gf`
- `ExtendSqiFocusPrep.gf`
- `ExtendSqiVPBridge.gf`
- `ExtendSqiLexicon.gf`
- `ExtendSqiScaffolding.gf`
- `ExtendSqiHelpers.gf`

Required:
- direct compile,
- family suite for the companion,
- nearest importer compile through `ExtendSqi.gf`,
- warning review,
- exact helper-type review if helpers are touched,
- symbol-ledger review if the companion owns a tracked fragile symbol.

### 11.3 If the touched file is a structural subresource
Examples:
- `StructuralSqiClause.gf`
- `StructuralSqiNominal.gf`
- `StructuralSqiVerbal.gf`
- `StructuralSqiRes.gf`

Required:
- direct compile,
- structural closed-class or relevant family suite,
- nearest importer compile through `StructuralSqi.gf`,
- façade compile through `SyntaxSqi.gf` if user-facing structural behavior is implicated,
- constructor-availability check for shallow structural categories,
- stale-comment tracker review if applicable.

### 11.4 If the touched file is a façade/aggregator
Examples:
- `ExtendSqi.gf`
- `StructuralSqi.gf`
- `GrammarSqi.gf`
- `SyntaxSqi.gf`

Required:
- direct compile,
- owned-submodule compile sanity,
- no new local logic that violates thin-façade rules,
- downstream cleanliness check,
- no reintroduction of blocked or out-of-cycle families.

### 11.5 If the touched file is under-extracted
As classified by `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`:
- `PENDING_TARGETED_EXTRACTION`
- `PARTIALLY_EXTRACTED`

Required:
- stricter source audit before implementation,
- do not rely on docs alone,
- explicit cite/trace of the exact current module source,
- and full family review if the module is category-critical.

---

## 12. Pass / fail criteria

A test run is a **pass** only if:

- touched files compile,
- required importers compile,
- required subsystem suite passes,
- required regression set passes,
- no new unreviewed warnings appear,
- no exact-helper-type mismatch remains,
- no constructor-availability mismatch remains,
- no known blocked symbol is silently used as if stable,
- no touched stale-comment hazard is ignored.

A test run is a **fail** if any of the following occurs:

- hard compile error,
- downstream importer failure whose root cause is local,
- new `lock_AP` / `lock_CN` / `lock_Prep` cluster without explicit review,
- exact helper-type mismatch,
- constructor-context mismatch,
- family incoherence,
- stale comment used as implementation authority,
- touched blocked symbol used without satisfying exit criteria.

### 12.1 Provisional pass

A provisional pass is allowed only when:
- the implementation is explicitly marked `temporary` or `fallback`,
- the ledger/doc status agrees,
- the suite names the remaining limitation,
- and no false claim of finality is made.

---

## 13. Reporting format

Every Albanian test run that matters should report at least:

1. touched file(s),
2. direct compile result,
3. nearest importer result,
4. warnings introduced / warnings unchanged,
5. subsystem suites run,
6. regression sets run,
7. fragile symbols touched,
8. stale-comment zones touched,
9. whether the result is final, provisional, or failed.

### 13.1 Root-cause discipline

If multiple files fail:
- identify the first direct failure,
- identify which failures are downstream,
- do not count a downstream façade failure as an independent primary defect if it is caused by a direct owner-module failure.

---

## 14. What this suite is not allowed to ignore

This suite must never ignore:

- exact helper-type mismatch,
- constructor/module-context mismatch,
- rich-category flattening,
- lock warnings in touched high-risk zones,
- family incoherence,
- stale comments treated as authority,
- façade breakage after local changes,
- blocked symbols reused without exit criteria,
- under-extracted module risk when a change is made there.

---

## 15. Minimum maintenance obligations

Whenever a new Albanian failure class is discovered, update:

- this test suite,
- the decision log,
- the symbol status ledger,
- the stale-comment tracker if applicable,
- and whichever constructor/helper/category docs are affected.

Whenever a symbol status changes materially, reflect that in the regression expectations here.

Whenever a helper family changes, update the helper-registry assumptions used by the exact-helper-type tests.

Whenever a shallow-category constructor path is changed, update the constructor-availability assumptions used by the structural closed-class tests.

---

## 16. Final maintainer note

This document is intentionally strict for a “minimal” suite.

The Albanian grammar is at a stage where the expensive failures are not random; they are patterned:

- rich categories are flattened too early,
- helpers are reused across nearby but non-identical categories,
- shallow-looking categories invite unsafe local constructor guesses,
- comments can lag behind live code,
- and façades can fail only because an owned submodule was repaired unsafely.

So the Albanian minimum test suite must remain narrow in runtime cost, but broad in **structural vigilance**.

The right question is not:
- “does it compile once?”

The right question is:
- “does it preserve Albanian category truth, constructor truth, helper truth, and subsystem truth without silently breaking its neighbors?”