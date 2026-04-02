# ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES

Status: working specification for GF Albanian concrete syntaxes, with priority on constructor discipline, category-shape preservation, module-context verification, and anti-drift rules for implementation.

Scope:
- primary target: `GF/lib/src/albanian/*`
- especially relevant to: `CatSqi.gf`, `NounSqi.gf`, `AdjectiveSqi.gf`, `AdverbSqi.gf`, `SentenceSqi.gf`, `QuestionSqi.gf`, `SyntaxSqi.gf`, `ConjunctionSqi.gf`, `ExtraSqi.gf`, `StructuralSqi*.gf`, `ExtendSqi*.gf`
- intended use: guide new implementations, override decisions, and bug-fixing without drifting away from the actual Albanian category system
- companion references:
  - `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
  - `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
  - `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
  - `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
  - `ALBANIAN_DECISION_LOG.md`
  - `ALBANIAN_HELPER_REGISTRY.md`
  - `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
  - `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
  - `ALBANIAN_STALE_COMMENT_TRACKER.md`
  - `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`

---

## 1. Core principle

Albanian concrete syntax must be implemented by preserving the real category shape of the target lincat.

Do not treat GF constructors as string templates unless the target category is genuinely string-like.

In practice this means:
- if the target is `NP`, return an Albanian `NP`
- if the target is `CN`, preserve the noun table and gender
- if the target is `AP`, preserve the adjective table and agreement dimensions
- if the target is `ListNP`, preserve list shape and agreement behavior
- if the target is `Adv`, `Comp`, `Cl`, `S`, `QS`, `Utt`, etc., use the inherited constructor path when one exists

The default bias is:
1. abstract signature first
2. current compile result second
3. current Albanian source dump third
4. inherited `ExtendFunctor` / grammar constructor path fourth
5. current Albanian lincat shape fifth
6. current Albanian core-module constructor path sixth
7. model-language analogy only after those six
8. comments and historical notes last

This bias is deliberate. Albanian has enough rich-category and helper-boundary traps that “looks plausible” is not a safe implementation strategy.

### 1.1 Shape does not automatically license a constructor

Knowing the documented or inferred shape of a category is necessary evidence, but it is not sufficient by itself to justify a concrete constructor.

In particular:
- knowing that a category is shallow or surface-shaped does **not** automatically mean `lin Cat { ... }` is valid in every module
- category shape and constructor availability are separate questions
- a category may be simple in documentation but still unavailable, shadowed, or unusable in a given module context
- if the current compiler/module context rejects a constructor form, that compile reality overrides a guessed constructor pattern
- availability must be checked after actual `open`, aliasing, and module scope are taken into account
- “I saw the same-looking category elsewhere” is not a constructor proof

If the category is listed in `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`, treat that matrix as the first follow-up check for actual constructibility. If the category is not yet in that matrix, do not assume permissive direct construction. Document the gap first.

### 1.2 Exact-type rule for helper reuse

A helper may be reused only if its input and output categories match the current function need exactly.

In particular:
- an `A -> Str` helper is not automatically valid for `AP -> Str`
- a `CN -> Str` helper is not automatically valid for `NP -> Str`
- a surface extractor for one category family must not be reused for another just because the intended wording is similar
- a helper name that “looks right” is not evidence
- exact type beats semantic resemblance
- subsystem proximity does not relax type matching
- fallback/compatibility helpers are not silently promoted into structural builders

When in doubt, consult `ALBANIAN_HELPER_REGISTRY.md`. If the helper is not registered there with a compatible category profile, treat the helper as unverified.

### 1.3 Current failure anchors

The following are canonical examples of what this file forbids:

- `fp_FocusAP`-type mistake:
  - extracting an `AP` surface with a helper typed for `A`
  - lesson: similarity of purpose is irrelevant; exact helper category is mandatory

- `StructuralSqiClause.mkDConj`-type mistake:
  - assuming `DConj = {s : Str}` in a category reference implies `lin DConj { ... }` is constructible in the current resource
  - lesson: lincat shape is not constructor availability; module context must still be verified

- stale-comment authority mistake:
  - trusting a code comment describing an older category/constructor state over the current source dump or compiler behavior
  - lesson: comments are secondary evidence and must be tracked explicitly if stale

These anchors must be treated as anti-regression examples in future reviews and reflected in:
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`

### 1.4 Evidence precedence and comment authority

When evidence conflicts, use this precedence:

1. abstract signature
2. current compiler behavior
3. current Albanian source dump
4. current Albanian architecture and policy docs
5. current helper registry / constructor matrix / status ledger support docs
6. model-language comparison
7. comments, historical notes, and inferred intentions

Comments are explanatory only. They are never authoritative over current code and compiler output.

If a comment is known stale, record it in `ALBANIAN_STALE_COMMENT_TRACKER.md`. Do not keep the inconsistency only in memory or chat.

### 1.5 Fully developed documentation requirement

A syntax/construction rule is not considered fully documented unless it is backed by at least one of:
- a live Albanian constructor pattern,
- an explicit entry in the helper registry,
- an explicit entry in the shallow-category constructor matrix,
- an explicit symbol status in the symbol status ledger,
- or a decision-log note explaining why the case remains provisional.

This requirement exists so AI systems do not invent missing links between high-level policy and low-level implementation.

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

Additional rule:
- if the implementation touches `CN` but the supporting noun builder is not documented in the current helper registry or implementation patterns, pause and verify against Albanian core noun constructors first.

### 2.2 A vs AP

These are distinct and must never be conflated.

Rule:
- `A` and `AP` are not interchangeable
- helpers for `A` are not helpers for `AP`
- single-surface adjective utilities do not justify AP-level construction or extraction

Implementation rule for `AP`:
- preserve species, case, gender, and number dimensions for AP-returning functions

Allowed pattern:
- `lin AP { s = \spec,c,g,n => ... }`

Forbidden pattern:
- flattening an AP to one nominative masculine singular form and then returning it as AP
- reusing an `A`-specific helper for AP construction or AP surface extraction

Use `apStr` only when the target category is actually string-like.

Additional rule:
- if an AP extractor is needed for a shallow target such as a surface `Utt`, the extractor itself must still be AP-compatible and should be registered as such in `ALBANIAN_HELPER_REGISTRY.md`.

### 2.3 NP

Albanian NP is case-sensitive and carries agreement.

Implementation rule:
- preserve `s : Case => Str`
- preserve or recompute `a : Agr`

Allowed pattern:
- `lin NP { s = \c => ... ; a = ... }`

Forbidden pattern:
- returning `{s = ...}` with one string where an NP is required
- discarding case just because a current local usage only reads one case

Additional rule:
- if an NP is used under prepositions or clause-level constructors, preserve the nominal category boundary until the final output category truly becomes shallow.

### 2.4 RNP and RNPList

When inherited from `ExtendFunctor`, treat:
- `RNP` as `NP`
- `RNPList` as `ListNP`

Implementation rule:
- if using inherited strategy, all `RNP` functions must behave as NP/ListNP constructors
- do not mix string-based `RNP` values with inherited `NP`-based ones
- `Base_*_RNP` and `Cons_*_RNP` must preserve actual list shape, not fake it with strings

Additional rule:
- if the symbol status ledger marks any RNP-family member as provisional, treat the whole family as review-sensitive until coherence is re-established.

### 2.5 String-like categories

Only these should be implemented by direct string concatenation without further structural fields:
- explicitly string-based local helper categories
- simple adverbial/complement-like records known to be `{s : Str}`
- local list helper categories already defined as `{s : Str}` in the module
- `Utt`-style or similar surface-only outputs only when the current Albanian codebase already treats them as shallow in that context

Even here:
- use inherited constructors when available
- verify constructor availability in the actual module
- do not promote a shallow local success into a general category rule
- consult `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md` if the category belongs to the structural/functional layer

### 2.6 Surface shape vs constructor availability

Even when a category is known or documented to have a shallow shape, confirm all of the following before using direct `lin Cat { ... }`:
- the category is actually available in the current module scope
- the constructor form is used elsewhere in current Albanian code or is accepted by the compiler
- the implementation does not bypass a safer inherited or Albanian core constructor path
- the category is not only visible in documentation but actually constructible in that scope
- no aliasing/open pattern is hiding a different implementation path
- the constructor pattern is not contradicted by the shallow-category constructor matrix
- the symbol status ledger does not already mark the category or constructor path as warning-state or provisional

If any of those are uncertain, do not guess from category shape alone.

### 2.7 Structural shallow categories

Special caution applies to shallow-looking structural categories such as:
- `DConj`
- `CAdv`
- `Utt`
- `Voc`
- `PConj`
- `Subj`
- some simple conjunction/preposition wrappers

Rule:
- treat these as high-risk for constructor drift
- a simple field shape does not make them universally safe for direct `lin Cat { ... }`
- verify both export path and actual constructibility in the current resource
- prefer documented paradigm/resource constructors when available
- record uncertainties in the constructor matrix instead of normalizing them silently into prose

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

Before replacing the inherited path, verify that the inherited path is actually missing, wrong for Albanian, or blocked by the target category shape.

### 3.2 Second choice: Albanian-preserving local construction

If there is no inherited constructor path, construct a full Albanian value of the target category.

Examples:
- full `lin CN`
- full `lin AP`
- full `lin NP`
- full `lin ListNP`

This choice is valid only if the constructor form itself is confirmed in the actual Albanian module context.

Where possible:
- ground the construction in an already documented Albanian producer module
- cross-check against the implementation patterns file
- register any new helper introduced for this construction in the helper registry

### 3.3 Third choice: model-language-guided custom implementation

Only if neither of the above is enough:
- inspect the same function family in Bulgarian or German
- copy structure, not language-specific morphology

Model-language analogy cannot override:
- the exact abstract signature
- the current Albanian lincat shape
- the current Albanian module’s available constructors

If model-language guidance is used:
- record that fact in the decision log if it materially changes policy
- do not treat model-language similarity as evidence stronger than current Albanian compile reality

### 3.4 Fourth check: scope and alias verification

Before finalizing any local constructor:
- resolve all `open` statements
- resolve local aliases such as `(R = ResSqi)` or `(AS = AdverbSqi)`
- check whether the apparent category is coming from `CatSqi`, a helper resource, or a local alias
- verify whether the constructor is category-native, paradigm-based, or helper-based

This step is mandatory for structural resources and helper-heavy modules.

### 3.5 Fifth check: support-doc synchronization

Before finalizing a constructor decision in a drift-prone zone, verify whether it should update one of:
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_DECISION_LOG.md`

If the constructor decision changes what future AI systems must assume, the support docs must be kept synchronized.

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

Additional rule:
- treat the existential family as a policy family; a new pattern in one member should be checked against all members before being normalized into documentation.

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

Additional rule:
- if a helper used here is not fully typed and classified in the helper registry, the implementation is not considered documentation-complete.

### 4.3 Preposition family

Functions include:
- `PrepCN`
- any local `PrepNP`-like usage
- preposition-bearing adverb/AP/NP constructors

Rule:
- follow Albanian preposition behavior already established in core modules
- when possible, build through `PrepNP`
- if a CN is used under a preposition, prefer the inherited path or a bare/mass NP strategy rather than inventing a fake noun category

Do not infer a new preposition strategy only from the apparent surface form of a structural item.

Additional rule:
- use the shallow-category constructor matrix and symbol status ledger together when evaluating structural preposition items, because preposition-looking categories are often where constructor availability and warning-state behavior drift apart.

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

Additional rule:
- if the helper registry marks some helper in this family as fallback-only, do not use it as the anchor for family-wide design.

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

Additional rule:
- if a nominalization or participial constructor is currently provisional, record that in the symbol status ledger rather than leaving it implicit.

### 4.6 Structural clause/function-item family

Functions and items include:
- clause-level prepositions
- `DConj`
- `PConj`
- `Subj`
- `CAdv`
- `Utt`
- `Voc`
- similar structural exports in `StructuralSqiClause.gf`

Rule:
- distinguish category description from resource-local constructibility
- prefer verified paradigm or resource constructors when they exist
- if direct `lin Cat { ... }` is used, verify that:
  - the category is constructible in the current module
  - the pattern is accepted by the compiler
  - there is no existing paradigm/resource path that is safer
  - the constructor matrix does not already classify the category as restricted or warning-state

Additional rule:
- if a structural item is re-exported through `StructuralSqi.gf`, verify that the chosen construction route matches the intended structural export path, not just one local resource.

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

If an implementation needs a surface extractor for `AP`, that extractor must itself be `AP`-typed. Do not substitute an `A`-specific helper.

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

### 5.7 Compatibility builders

Compatibility wrappers are allowed only when:
- they are explicitly documented as compatibility/fallback builders
- they target a shallow or lexicalized output path
- they do not silently replace a proper rich-category constructor
- their use is visible in the code and easy to audit
- they are marked appropriately in the helper registry and, if fragile, in the symbol status ledger

A compatibility builder must never be mistaken for a fully category-preserving constructor.

### 5.8 Module extraction awareness

If work depends on a module that is still marked as under-extracted in `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`, do not overgeneralize from one local pattern in that module. Treat the evidence as narrower until a full extraction pass exists.

This especially matters when:
- the module is high-impact but not yet deeply documented,
- the module is known to sit near rich/shallow boundaries,
- or the module is already listed as an extraction priority.

---

## 6. Local helper policy

Helpers such as `cnStr`, `apStr`, `npConst`, `cnConst`, `apConst`, `mkCompat*`, and similar are permitted, but under strict conditions.

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

### 6.3 Exact helper-signature check

Before reusing a helper, verify:
- exact input category
- exact output category
- field shape expected by the helper
- whether the helper belongs to the same subsystem or a more general helper layer
- whether the helper is category-preserving, lossy, or compatibility-based
- whether the helper registry classifies it as `stable`, `warning`, `fallback`, or `temporary`

A helper is not safe just because:
- its name looks semantically similar
- it returns a `Str`
- its output could be inserted into a shallow result

### 6.4 Helper reuse vs subsystem coherence

A helper may reduce duplication, but it must not collapse important category distinctions inside a subsystem.

In particular:
- do not replace an `AP` extractor with an `A` extractor
- do not replace a structured `NP` builder with a string helper
- do not hide family-level category drift behind a shared convenience helper

### 6.5 Required helper labeling

Every helper pattern used in documentation or code reasoning should be classifiable as one of:
- neutral utility
- category-preserving builder
- lossy surface extractor
- compatibility/fallback builder

If a helper cannot be classified, do not rely on it in a final implementation.

### 6.6 Helper registry synchronization

Any helper that becomes important enough to be cited in a code review, doc update, or policy explanation should be added or updated in `ALBANIAN_HELPER_REGISTRY.md`.

The helper registry is the anti-drift memory layer for helper behavior. If it is missing a critical helper, documentation completeness is not yet achieved.

---

## 7. Lock-field discipline

If the compiler warns about `lock_AP`, `lock_CN`, or similar hidden fields, treat it as a structural warning, not a cosmetic one.

Rule:
- a lock warning usually means a function is manufacturing an incomplete category record
- the preferred repair is not “add one more field manually”, but “rebuild through the right constructor path or use the full category shape already used in Albanian core modules”

Interpretation rule:
- repeated lock warnings across a family indicate category drift
- one-off lock warnings in a `variants {}` area may still be acceptable temporarily, but they should remain tracked in the symbol status ledger and, if policy-significant, in the open questions or decision log

Related rule:
- absence of a lock warning does not by itself prove that a constructor choice is valid; constructor availability and exact category matching must still be verified

Additional rule:
- if a symbol is already tracked in `ALBANIAN_SYMBOL_STATUS_LEDGER.md` as warning-state, do not document its current constructor path as fully stable without first updating the ledger.

---

## 8. Override rules for `ExtendSqi`

### 8.1 When to override

Override only if one of these is true:
- `ExtendFunctor` leaves the function as `variants {}`
- Albanian word order/case behavior requires a real language-specific change
- inherited composition exists but yields the wrong Albanian structure or meaning
- current compile reality shows the inherited/local candidate is structurally invalid in the Albanian module context

### 8.2 When not to override

Do not override if the only reason is:
- it is easy to write with strings
- the inherited path looks verbose
- a model language has a custom override but Albanian does not need one
- a local helper makes the shallow output easy
- one warning disappeared while the family representation became less coherent

### 8.3 What every override must state

For each override, document:
- abstract signature
- target category
- inherited/default path if known
- why Albanian needs the override
- what category shape is being preserved
- what constructor form is valid in the current module context
- what helper types, if any, are reused exactly
- whether the symbol status is stable, warning, fallback, or temporary

### 8.4 Subsystem coherence rule

An override inside a subsystem family must not be justified in isolation.

Before finalizing any override inside:
- existential family
- AP/CN conversion family
- RNP family
- structural clause/function-item family
- focus/preposition family

verify that the choice is coherent with the rest of the family.

### 8.5 Support-doc propagation rule

If an `ExtendSqi` override creates a new enduring rule about:
- helper legality,
- shallow-category constructor limits,
- warning-state behavior,
- or stale comments,

then update the relevant support docs at the same time. Do not let `ExtendSqi` become the only place where the lesson exists.

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

Do not use a model language to justify a constructor that the current Albanian module context does not support.

### 9.4 Model-language documentation rule

If model-language evidence materially influences an Albanian rule:
- record the subsystem and rationale in the decision log
- do not leave that reasoning only in chat or ad hoc notes

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
9. Introducing `lin Cat { ... }` only because the documented category shape looks simple.
10. Reusing a helper across category families without exact signature compatibility.
11. Assuming that a category name visible in docs or comments is automatically constructible in the current module.
12. Patching one member of a subsystem family without checking the rest of the family.
13. Trusting a stale explanatory comment over current code and compiler output.
14. Borrowing a constructor pattern from another module without verifying scope, export path, and constructibility in the current one.
15. Using a compatibility/fallback builder as if it were a full structural constructor.
16. Treating an undocumented helper as if its safety class were obvious.
17. Treating a warning-state symbol as if it were stable because one local call site seems to work.
18. Letting support docs lag after a rule-changing implementation fix.

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
9. Any reused helper has the exact needed signature.
10. Any direct `lin Cat { ... }` form is valid in the current module context.
11. The implementation is coherent with the surrounding subsystem family.
12. Comments were not used as decisive evidence against live code or compile results.
13. Compatibility builders, if present, are explicitly identified as such.
14. The helper registry, constructor matrix, status ledger, or stale-comment tracker were updated if the rule changed.
15. If the module is still under-extracted, the implementation claim does not overstate what the docs guarantee.

---

## 12. Minimal resolution strategy when debugging

When a constructor fails, use this order:

1. read the exact abstract signature
2. inspect inherited `ExtendFunctor` composition if present
3. inspect Albanian lincat shape in core modules
4. inspect Albanian core-module constructor patterns for the same target category
5. verify helper signatures before reusing any helper
6. classify any helper as preserving, lossy, or compatibility-based
7. verify constructor availability in the actual current module
8. inspect the shallow-category constructor matrix if the category is structural/shallow-looking
9. inspect the symbol status ledger if the symbol or family is already known fragile
10. inspect same constructor family in Bulgarian, then German if needed
11. implement the least invasive category-correct fix
12. recompile
13. resolve lock warnings before moving to unrelated functions
14. if code, comments, and docs disagree, update comments/docs after compile reality is established

Do not skip steps 5, 6, 7, 8, or 9 merely because the documented category shape looks obvious.

---

## 13. Final rule

The Albanian syntax implementation is considered healthy only when:
- constructors follow abstract signatures exactly
- outputs preserve Albanian category shapes
- inherited grammar paths are used whenever available
- local overrides are coherent by family
- compiler warnings no longer indicate structural drift
- constructor forms are valid in the current Albanian module context
- reused helpers match the actual categories involved
- compatibility builders are not mistaken for structural constructors
- comments and documentation are kept consistent with current code and compile reality
- helper registry entries exist for critical helper-based decisions
- shallow-category constructor assumptions are made explicit in the constructor matrix
- fragile/currently warning-state symbols are reflected in the symbol status ledger
- known stale comments are either fixed or tracked
- documentation coverage for relevant modules is not overstated

This file is normative for constructor design. If code and this file disagree:
- fix the code when the file states a stable architectural or category-preserving rule
- fix the file when compile reality and current Albanian source prove that a documented constructor assumption is too broad or outdated
- record any intentional exception in `ALBANIAN_DECISION_LOG.md`

### 13.1 Completion standard

This file is considered fully mature only when:
- every recurring constructor lesson has a support-doc home,
- no major drift rule lives only in chat,
- and future AI-assisted edits can follow the policy without needing to infer missing operational glue.

Until then, keep this file synchronized with:
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`