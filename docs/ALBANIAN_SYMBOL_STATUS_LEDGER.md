# ALBANIAN_SYMBOL_STATUS_LEDGER

## Status

Normative tracking document for symbol- and pattern-level maturity in the Albanian GF codebase.

This file exists to prevent AI drift and maintenance drift by making the current status of fragile, provisional, fallback, warning-state, blocked, and historically misleading symbols explicit.

It complements, but does not replace:

- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`

This is the Albanian ledger for “what is safe right now”, “what is only conditionally usable”, “what is blocked”, and “what must not be copied as a general pattern”.

---

## 1. Purpose

The Albanian documentation set now contains strong architecture, constructor, helper, and anti-drift rules. What it still needs in operational form is a single place that answers questions like:

- Is this symbol stable, or only temporarily acceptable?
- Is this helper category-safe, or only usable in shallow outputs?
- Is this constructor pattern canonical, fallback, or blocked?
- Is this comment still trustworthy?
- If a symbol is known to be fragile, what exactly must be true before it can be considered final?

This ledger supplies that information.

It is intentionally narrower than a general architecture document and more explicit than a prose decision log.

---

## 2. Scope

This ledger tracks:

1. individual symbols that are known to be fragile, blocked, fallback-only, or incomplete,
2. helper families whose allowed use depends on exact type or shallow-target discipline,
3. grouped structural zones that remain warning-state,
4. stale-comment hazards that can mislead automated or human maintainers,
5. downstream façade or aggregator files that may fail only because an owned symbol is still broken.

This ledger does **not** attempt to list every ordinary exported Albanian constant.
Absence from this ledger is not proof of stability.

---

## 3. Precedence and use

This ledger is subordinate to:

1. exact abstract signatures,
2. current compiler behavior,
3. current Albanian source truth,
4. current Albanian category/core-constructor evidence,
5. architecture and policy documents.

Use this ledger as a **status classifier**, not as a substitute for type-checking or constructor verification.

If this ledger ever disagrees with current compiler reality, update the ledger.

---

## 4. Status labels

Every tracked entry must use exactly one primary status and may also carry secondary notes.

### 4.1 `stable`
Use this only when the symbol or pattern is:
- accepted in the live Albanian codebase,
- category-safe for its intended role,
- not currently associated with unresolved warnings/failures,
- and not dependent on a temporary compatibility story.

### 4.2 `warning`
Use this when:
- the symbol/pattern is currently usable or partially usable,
- but recent runs, known warning clusters, or fragile constructor contexts mean it must be treated carefully,
- and it should not be used as a generic template without re-checking.

### 4.3 `temporary`
Use this when:
- the implementation is intentionally interim,
- a better Albanian-canonical path is expected later,
- and the current form exists only to preserve progress or unblock a narrow step.

### 4.4 `fallback`
Use this when:
- the implementation is explicitly compatibility-based,
- or it uses a reduced/bridging strategy that is acceptable only in its declared scope,
- and it must not be promoted into general canonical practice.

### 4.5 `incomplete`
Use this when:
- the symbol is intentionally known but not fully implemented,
- or the public façade keeps it disabled until the real implementation exists.

### 4.6 `blocked by compile reality`
Use this when:
- current compile evidence shows that the current pattern is not accepted,
- or a constructor/category/module-context mismatch is still unresolved,
- or the symbol cannot be treated as reusable until a compile blocker is repaired.

### 4.7 `historical comment only`
Use this when:
- the item is not a live constructor or implementation pattern,
- but a stale explanatory comment or historical note is still present in the codebase,
- and that note is now dangerous enough to deserve explicit tracking.

---

## 5. Required fields for every entry

Every tracked entry in this ledger should record:

- `entry`
- `kind` (`symbol`, `helper`, `grouped zone`, `comment hazard`, `façade file`)
- `current_owner`
- `current_location`
- `primary_status`
- `why_this_status`
- `allowed_use`
- `forbidden_use`
- `exit_criteria`
- `related_tests`
- `related_docs`

When relevant, also record:
- `current_blocked_by`
- `downstream_effect`
- `notes`

---

## 6. Current ledger

## 6.1 Core open / blocked items

### Entry: `must_VV`
- **kind:** symbol
- **current_owner:** `StructuralSqiVerbal.gf` / `StructuralSqi.gf`
- **current_location:** verbal structural export path
- **primary_status:** `incomplete`
- **why_this_status:** the structural façade keeps `must_VV` disabled with an explicit note that the crash source is not yet isolated in the verbal helper chain.
- **allowed_use:** documentation, explicit tracked open item, future repair target
- **forbidden_use:** silently treating it as already supported; re-enabling it without actual evidence and tests
- **exit_criteria:**
  1. crash source isolated,
  2. verbal helper chain repaired,
  3. `StructuralSqi.gf` exports it without a keep-disabled note,
  4. minimal verbal regression tests added and passing
- **related_tests:** structural verbal compile test, targeted `must_VV` façade test
- **related_docs:** decision log, lexical/functional elements, minimal test suite

---

### Entry: `fp_FocusAP`
- **kind:** symbol
- **current_owner:** `ExtendSqiFocusPrep.gf`
- **current_location:** focus/preposition subsystem
- **primary_status:** `warning`
- **why_this_status:** recent Albanian compile failures and documentation updates established this as an anti-drift anchor for exact helper-category compatibility. The known failure class is using an `A`-typed helper where an `AP`-typed helper or local `AP` extractor is required.
- **allowed_use:** shallow `Utt`-level realization only when the helper/extractor is verified as `AP -> Str` and the target remains surface-only
- **forbidden_use:** reusing an `A` helper by family resemblance; treating the symbol as solved without checking exact helper type in the live branch
- **exit_criteria:**
  1. live implementation uses an `AP`-compatible helper/extractor only,
  2. `ExtendSqiFocusPrep.gf` compiles cleanly,
  3. `ExtendSqi.gf` no longer fails downstream because of this item,
  4. exact-helper-type regression test passes
- **related_tests:** `FocusAP` exact helper-type compatibility test
- **related_docs:** syntax/constructor rules, implementation patterns, decision log, minimal test suite
- **notes:** if the current branch still reintroduces an `A`-helper misuse, status must be escalated to `blocked by compile reality`.

---

### Entry: `mkDConj`
- **kind:** symbol
- **current_owner:** `StructuralSqiClause.gf`
- **current_location:** clause/discourse structural vocabulary
- **primary_status:** `blocked by compile reality`
- **why_this_status:** a recent Albanian structural branch used `mkDConj : Str -> DConj = \s -> lin DConj {s = s}`, and the compile logs/documented regression show that `DConj` was not accepted in that module context in the assumed way.
- **allowed_use:** only after the constructor/context pattern is verified against the current source and current compiler in that exact module
- **forbidden_use:** copying `lin DConj {s = ...}` from lincat intuition or from a different module without verifying scope/context acceptance
- **exit_criteria:**
  1. accepted constructor pattern for `DConj` in `StructuralSqiClause.gf` is established,
  2. module compiles,
  3. paired `DConj` exports below compile cleanly,
  4. structural closed-class constructor-availability test passes
- **related_tests:** `StructuralSqiClause` structural closed-class constructor-availability test
- **related_docs:** category/lincat reference, syntax/constructor rules, lexical/functional elements, decision log

---

### Entry: `both7and_DConj`
- **kind:** symbol
- **current_owner:** `StructuralSqiClause.gf`
- **current_location:** clause/discourse structural vocabulary
- **primary_status:** `blocked by compile reality`
- **why_this_status:** this export depends directly on the same unresolved `DConj` constructor/context issue as `mkDConj`.
- **allowed_use:** none beyond tracked blocked item status until `mkDConj` is repaired
- **forbidden_use:** treating it as a normal reusable structural template while the underlying constructor issue is unresolved
- **exit_criteria:** same as `mkDConj`
- **related_tests:** same as `mkDConj`
- **related_docs:** same as `mkDConj`

---

### Entry: `either7or_DConj`
- **kind:** symbol
- **current_owner:** `StructuralSqiClause.gf`
- **current_location:** clause/discourse structural vocabulary
- **primary_status:** `blocked by compile reality`
- **why_this_status:** same constructor-context failure class as `mkDConj` / `both7and_DConj`
- **allowed_use:** none beyond tracked blocked item status until `mkDConj` is repaired
- **forbidden_use:** treating it as a general structural pattern while the constructor issue remains unresolved
- **exit_criteria:** same as `mkDConj`
- **related_tests:** same as `mkDConj`
- **related_docs:** same as `mkDConj`

---

## 6.2 Warning-state structural zones

### Entry: `StructuralSqiClause preposition constructor zone`
- **kind:** grouped zone
- **current_owner:** `StructuralSqiClause.gf`
- **current_location:** structural clause-level prepositions
- **primary_status:** `warning`
- **why_this_status:** multiple Albanian audit/documentation passes identify preposition handling as a warning-state zone, including `missing lock field lock_Prep` warnings around preposition items and the broader lesson that prepositions are richer in compile reality than a naïve `{s : Str}` reading suggests.
- **included symbols (minimum tracked examples):**
  - `above_Prep`
  - `after_Prep`
  - `before_Prep`
  - `behind_Prep`
  - `between_Prep`
  - `by8agent_Prep`
  - `by8means_Prep`
- **allowed_use:** maintain through verified Albanian prep constructors such as the established `ResSqi` / `AdverbSqi` paths; treat each touched prep item as needing compile verification
- **forbidden_use:** creating a new prep as a naked string hack; assuming prepositions are trivial because the visible surface form is simple; ignoring prep-related warnings as harmless
- **exit_criteria:**
  1. no relevant `lock_Prep`-class warnings remain in touched structural preposition code,
  2. the accepted constructor path is regularized and documented,
  3. warning-state label can be downgraded entry-by-entry only after clean compile evidence
- **related_tests:** structural prep warning test, touched-preposition compile test
- **related_docs:** lexical/functional elements, minimal test suite, decision log, category/lincat reference
- **notes:** this grouped zone remains warning-state even if one individual preposition happens to compile cleanly in isolation.

---

## 6.3 Approved but non-canonical wrappers

### Entry: `mkCompatAPFromStr`
- **kind:** helper
- **current_owner:** `ExtendSqiHelpers.gf`
- **current_location:** helper inventory, compatibility-wrapper class
- **primary_status:** `fallback`
- **why_this_status:** the helper inventory explicitly classifies compatibility helpers as temporary/fallback tools rather than general canonical constructors.
- **allowed_use:** narrow extension-layer bridging where the documentation explicitly says compatibility-based or temporary
- **forbidden_use:** presenting it as the normal final Albanian way to construct rich `AP` values
- **exit_criteria:** either retired in favor of a verified category-preserving path, or explicitly retained as a bounded lexical/extension fallback with tests
- **related_tests:** helper-registry conformance test, touched-usage compile check
- **related_docs:** implementation patterns, lexical/functional elements, anti-drift rules

---

### Entry: `mkCompatCNFromStr`
- **kind:** helper
- **current_owner:** `ExtendSqiHelpers.gf`
- **current_location:** helper inventory, compatibility-wrapper class
- **primary_status:** `fallback`
- **why_this_status:** same compatibility-wrapper class as above
- **allowed_use:** narrow, documented fallback-only cases
- **forbidden_use:** canonical `CN` construction in rich-category-preserving code
- **exit_criteria:** same policy as `mkCompatAPFromStr`
- **related_tests:** same helper-registry and touched-usage checks
- **related_docs:** same as above

---

### Entry: `mkCompatNPFromStr`
- **kind:** helper
- **current_owner:** `ExtendSqiHelpers.gf`
- **current_location:** helper inventory, compatibility-wrapper class
- **primary_status:** `fallback`
- **why_this_status:** the live documentation identifies this class as compatibility-based and acceptable in bounded lexical-tail contexts, not as proof that generic rich `NP` construction should be done this way everywhere.
- **allowed_use:** documented lexical-tail compatibility wrappers and similar narrow extension cases
- **forbidden_use:** promoting it into a general canonical NP-builder for unrelated subsystems
- **exit_criteria:** same policy as other compatibility wrappers
- **related_tests:** lexical-tail wrapper tests, helper-registry conformance
- **related_docs:** lexical/functional elements, implementation patterns, anti-drift rules

---

### Entry: `lex_UseDAP`
- **kind:** symbol
- **current_owner:** `ExtendSqiLexicon.gf`
- **current_location:** lexical tail
- **primary_status:** `fallback`
- **why_this_status:** the documentation now explicitly treats `UseDAP*` implementations as lexical-tail compatibility wrappers rather than proof of a general canonical `DAP -> NP` structural pattern.
- **allowed_use:** lexical-tail compatibility use only, clearly documented as such
- **forbidden_use:** citing this as evidence that all `DAP`-to-`NP` behavior in Albanian should be implemented through compatibility wrappers
- **exit_criteria:** either preserved as explicitly bounded lexical-tail fallback or replaced by a stronger verified constructor path
- **related_tests:** `UseDAP*` lexical-tail regression checks
- **related_docs:** lexical/functional elements, implementation patterns, category/lincat reference

---

### Entry: `lex_UseDAPMasc`
- **kind:** symbol
- **current_owner:** `ExtendSqiLexicon.gf`
- **current_location:** lexical tail
- **primary_status:** `fallback`
- **why_this_status:** same bounded lexical-tail wrapper class as `lex_UseDAP`
- **allowed_use:** lexical-tail compatibility use only
- **forbidden_use:** use as canonical structural pattern
- **exit_criteria:** same as `lex_UseDAP`
- **related_tests:** same as `lex_UseDAP`
- **related_docs:** same as `lex_UseDAP`

---

### Entry: `lex_UseDAPFem`
- **kind:** symbol
- **current_owner:** `ExtendSqiLexicon.gf`
- **current_location:** lexical tail
- **primary_status:** `fallback`
- **why_this_status:** same bounded lexical-tail wrapper class as `lex_UseDAP`
- **allowed_use:** lexical-tail compatibility use only
- **forbidden_use:** use as canonical structural pattern
- **exit_criteria:** same as `lex_UseDAP`
- **related_tests:** same as `lex_UseDAP`
- **related_docs:** same as `lex_UseDAP`

---

## 6.4 Exact-type surface helpers

### Entry: `adjSurfaceNomMascSg`
- **kind:** helper
- **current_owner:** `ExtendSqiHelpers.gf`
- **current_location:** exact-type surface helper inventory
- **primary_status:** `stable`
- **why_this_status:** the current documentation explicitly names it as an exact-type helper for `A`, and uses it as the canonical counterexample in the `A` vs `AP` drift lesson.
- **allowed_use:** shallow/presentation-level extraction from `A` only, where an `A -> Str` helper is exactly what is needed
- **forbidden_use:** any `AP` use site; any rich-category final construction
- **exit_criteria:** none beyond keeping the exact-type contract true
- **related_tests:** exact-helper-type mismatch regression test
- **related_docs:** category/lincat reference, implementation patterns, syntax/constructor rules

---

### Entry: `apSurfaceNomMascSg`
- **kind:** helper
- **current_owner:** `ExtendSqiHelpers.gf`
- **current_location:** exact-type surface helper inventory
- **primary_status:** `stable`
- **why_this_status:** the documentation explicitly names it as the correct AP-typed counterpart to `adjSurfaceNomMascSg`.
- **allowed_use:** shallow/presentation-level extraction from `AP` only
- **forbidden_use:** treating the extracted string as if it were a full `AP`; using it where the target category must stay rich
- **exit_criteria:** none beyond keeping the exact-type contract true
- **related_tests:** `FocusAP` exact helper-type regression checks
- **related_docs:** helper inventory, syntax/constructor rules, implementation patterns

---

### Entry: `cnSurfaceNomSg`
- **kind:** helper
- **current_owner:** `ExtendSqiHelpers.gf`
- **current_location:** exact-type surface helper inventory
- **primary_status:** `stable`
- **why_this_status:** documented as an exact-type `CN -> Str` surface extractor
- **allowed_use:** shallow/presentation-level extraction from `CN`
- **forbidden_use:** treating it as a canonical `NP` or `CN` builder; using it as if it preserved noun richness
- **exit_criteria:** none beyond keeping the exact-type contract true
- **related_tests:** helper exact-type and rich-category preservation tests
- **related_docs:** helper inventory, syntax/constructor rules, implementation patterns

---

## 6.5 Historical comment hazards

### Entry: `ConjunctionSqi.gf` DAP explanatory comment
- **kind:** comment hazard
- **current_owner:** `ConjunctionSqi.gf`
- **current_location:** conjunction/commentary layer
- **primary_status:** `historical comment only`
- **why_this_status:** the current documentation explicitly records a stale comment in `ConjunctionSqi.gf` claiming that `DAP` is not defined in `CatSqi`, while the current `CatSqi` snapshot already defines `DAP = {s : Str}`.
- **allowed_use:** historical context only
- **forbidden_use:** using the comment as implementation evidence; copying the comment into new code or docs as current truth
- **exit_criteria:**
  1. comment updated or removed,
  2. no documentation still presents the stale explanation as current,
  3. comment-authority rule remains cross-linked
- **related_tests:** stale-comment audit check
- **related_docs:** decision log, category/lincat reference, anti-drift rules, syntax/constructor rules

---

## 6.6 Downstream blocked façades

### Entry: `ExtendSqi.gf` (downstream block class)
- **kind:** façade file
- **current_owner:** extension coordinator layer
- **current_location:** `ExtendSqi` thin coordinator
- **primary_status:** `warning`
- **why_this_status:** when an owned companion module such as `ExtendSqiFocusPrep.gf` fails on a direct category/helper mismatch, `ExtendSqi.gf` can appear as a failing importer even though the coordinator architecture is still correct.
- **allowed_use:** thin coordinator only
- **forbidden_use:** diagnosing coordinator architecture as wrong before resolving the owned direct failure
- **exit_criteria:** all direct owned subsystem failures resolved; coordinator compiles cleanly without downstream blockage
- **related_tests:** full `ExtendSqi` compile after subsystem repair
- **related_docs:** override policy, future structure, final target, test suite
- **notes:** this is not a symbol-level “blocked” entry unless the coordinator itself violates thinness.

---

### Entry: `StructuralSqi.gf` (downstream block class)
- **kind:** façade file
- **current_owner:** structural aggregator layer
- **current_location:** `StructuralSqi.gf`
- **primary_status:** `warning`
- **why_this_status:** when `StructuralSqiClause.gf` fails on a direct constructor/context issue, `StructuralSqi.gf` can fail as a downstream importer even if the aggregator design remains correct.
- **allowed_use:** pure re-export structural aggregator
- **forbidden_use:** treating downstream structural aggregator failure as proof that the aggregator architecture is wrong before the owned clause-level failure is resolved
- **exit_criteria:** clause-level direct failures resolved; structural aggregator compiles and integration test passes
- **related_tests:** `StructuralSqiClause` compile test, `StructuralSqi` downstream integration compile test
- **related_docs:** language architecture, module dependency map, minimal test suite

---

## 7. Required maintenance rules

### 7.1 When to add an entry
Add or update an entry whenever:
- a new Albanian compile failure reveals a new fragile symbol or fragile pattern,
- a stale comment is discovered to affect implementation decisions,
- a helper is promoted, demoted, or reclassified,
- a previously blocked item becomes stable,
- or a new fallback/temporary wrapper is introduced.

### 7.2 When to remove an entry
Remove an entry only when:
- the symbol/pattern is no longer special enough to merit status tracking,
- the relevant exit criteria have been satisfied,
- the tests exist and pass,
- and the change is recorded in the decision log.

### 7.3 When to escalate an entry
Escalate status severity when:
- a `warning` entry becomes a direct compile blocker,
- a `fallback` entry begins to be copied as if it were canonical,
- a stale comment is found to be actively influencing repairs,
- or a “temporary” pattern starts spreading across multiple modules.

---

## 8. Relationship to tests

This ledger does not replace the minimal test suite.
Instead, it tells the test suite what must remain visible.

At minimum, each non-stable entry should have:
- a direct compile test,
- a negative anti-drift test if applicable,
- and a regression anchor if the symbol/pattern already caused a real Albanian failure.

Required named regression anchors include:
- `fp_FocusAP`
- `mkDConj` / `both7and_DConj` / `either7or_DConj`
- warning-state structural prepositions
- `must_VV`
- compatibility-wrapper lexical-tail items
- stale-comment hazard checks where feasible

---

## 9. Relationship to other documents

This ledger should be read together with:

- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`

Recommended division of labor:
- **architecture docs** define ownership and subsystem shape,
- **constructor/helper docs** define legal implementation behavior,
- **decision log** records why a policy changed,
- **this ledger** records current maturity and risk state per symbol/pattern,
- **test suite** enforces the high-risk entries.

---

## 10. Minimal checklist for maintainers and AI systems

Before reusing any tracked symbol or pattern from this ledger, ask:

1. What is its current primary status?
2. Is it canonical, or only fallback/temporary?
3. Does the current module context match the one in which the pattern was documented?
4. Is there a more canonical inherited or core Albanian constructor path now?
5. Do current compile logs still support the current status label?
6. Has a stale comment or older branch confused the meaning of this symbol?
7. Are the required tests present and passing?

If the answer to 3, 4, or 5 is uncertain, re-check current code and compile evidence before copying the pattern.

---

## 11. Final rule

A symbol is not safe just because it exists in the codebase.

A symbol is safe only when:
- its category role is explicit,
- its current status is explicit,
- its constructor or helper use is justified,
- its module-context legality is known,
- and its known failure modes are visible.

That is the function of this ledger.
