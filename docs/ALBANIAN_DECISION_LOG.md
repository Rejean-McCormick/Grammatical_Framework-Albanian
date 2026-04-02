# ALBANIAN_DECISION_LOG.md

Status: working authoritative log  
Scope: Albanian GF concrete syntax, with emphasis on `lib/src/albanian/*` and especially `ExtendSqi.gf` when override decisions affect cross-module assumptions.

## Purpose

This file records implementation decisions that have already been made, decisions that were tested and rejected, and decisions that remain provisional. It exists to prevent drift across repair sessions and to stop future edits from re-opening settled design questions without explicit evidence.

This log is authoritative for **settled Albanian implementation decisions**, but it does not replace:

- abstract signatures,
- `ExtendFunctor` inheritance/default composition,
- the current Albanian codedump,
- current compiler reality,
- or the dedicated operational control files that now carry large inventories and matrices.

It complements those sources by recording what has already been learned from them.

## Companion control documents

This log is intentionally concise compared with the larger operational files. It should now be read together with the following documents:

- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`

The principle is:

- the **decision log** records short authoritative lessons,
- the **rule docs** record operational detail,
- the **registry/matrix/ledger/tracker docs** record inventories and fragile live facts,
- and the **codedump + compiler** remain authoritative for what actually compiles now.

## How to use this log

Each entry contains:

- **ID**: stable identifier.
- **Status**: `accepted`, `provisional`, `superseded`, `rejected`, or `open`.
- **Area**: subsystem or file group.
- **Decision**: the chosen rule.
- **Why**: technical rationale.
- **Evidence**: files that support the decision.
- **Implications**: what code should do next.
- **Do not**: anti-regression note.

Use the log in this order:

1. read the exact abstract signature,
2. check the current codedump and current compile behavior,
3. check `ExtendFunctor` or the relevant inherited constructor path,
4. check the relevant Albanian core modules,
5. check the relevant support/control documents if the issue is about helpers, shallow categories, fragile symbols, stale comments, or module documentation coverage,
6. then use this log to avoid re-opening already settled questions.

## Entry format reference

### ID
Short machine-readable key.

### Status
- `accepted`: current working rule.
- `provisional`: strong current rule, but still subject to compile confirmation.
- `superseded`: historically important, no longer current.
- `rejected`: explicitly ruled out.
- `open`: unresolved question, documented here for continuity.

---

# Decisions

## ALB-DEC-001
**Status:** accepted  
**Area:** global methodology  
**Decision:** Resolve implementation questions by exact abstract signature and module context, not by function name or surface intuition.

**Why:** Several repair failures came from assuming a function returned one category because its surface behavior looked similar to another. The most important example was `PrepCN`, which was initially treated as if it returned a noun-like value rather than its actual abstract result category.

**Evidence:**
- `Extend.gf`
- `ExtendFunctor.gf`
- `GFCodex.txt`

**Implications:**
- Every override must start with abstract type.
- Then check inherited functor behavior.
- Then check Albanian lincat shape.
- Only after that compare model languages.

**Do not:**
- Choose implementation shape from the function name alone.
- Copy a German/Bulgarian implementation just because the function names match.

---

## ALB-DEC-002
**Status:** accepted  
**Area:** source hierarchy  
**Decision:** Use the following order of authority.

1. `abstract/Extend.gf` and other abstract signatures.
2. `common/ExtendFunctor.gf` and inherited constructor composition.
3. Albanian core modules (`CatSqi.gf`, `NounSqi.gf`, `AdjectiveSqi.gf`, `AdverbSqi.gf`, `ResSqi.gf`, `SyntaxSqi.gf`, `SentenceSqi.gf`, `QuestionSqi.gf`, `ConjunctionSqi.gf`, etc.).
4. Model languages.
5. Local repair decisions in this log.

**Why:** The Albanian repair work repeatedly showed that the safest fixes come from abstract signatures + inherited functor structure + Albanian local category shape. Model languages are useful only after those three are fixed.

**Evidence:**
- `Extend.gf`
- `ExtendFunctor.gf`
- `AlbanianGF_codedump.txt`
- `Bulgarian.txt`
- `GermanGF_Codedump.txt`

**Implications:**
- Model languages are secondary references.
- Local approximations must cite higher-order evidence.

**Do not:**
- Treat model-language code as primary truth.

---

## ALB-DEC-003
**Status:** accepted  
**Area:** category-shape policy  
**Decision:** Preserve full target-category shape. Do not flatten AP/CN/NP/Cl-like categories to `{s : Str}` unless the target category is actually string-like.

**Why:** The main Albanian failures in `ExtendSqi.gf` came from building simplified records where the grammar expected full category records with inherited fields and lock fields. The compile runs repeatedly surfaced `missing lock_AP`, `missing lock_CN`, and type mismatches of the form “expected `{s : Str}` but inferred a category table” or the reverse.

**Evidence:**
- `run_20260317_084411_20260317_084437_03_details.txt`
- `run_20260317_143053_20260317_143145_03_details.txt`
- `AlbanianGF_codedump.txt`

**Implications:**
- `apStr`, `cnStr`, `apConst`, and `cnConst` are only safe in truly string-targeted outputs or carefully justified helper contexts.
- When output category is AP/CN/NP/ListNP/etc., preserve the native shape.

**Do not:**
- Hand-roll reduced AP/CN records in production overrides.
- Assume a working surface string means the category is correctly typed.

---

## ALB-DEC-004
**Status:** superseded  
**Area:** `PrepCN`  
**Decision:** Early repair attempts treated `PrepCN` as noun-like and returned a `CN`-shaped record.

**Why superseded:** Abstract and functor evidence showed `PrepCN` does not belong to the noun-returning family.

**Evidence:**
- Earlier `ExtendSqi.gf` snapshots in `AlbanianGF_codedump.txt`
- `Extend.gf`
- `ExtendFunctor.gf`

**Implications:**
- Keep this entry only to explain earlier failed patches.

**Do not:**
- Re-introduce noun-like `PrepCN` implementations.

---

## ALB-DEC-005
**Status:** accepted  
**Area:** `PrepCN`  
**Decision:** `PrepCN` must follow the abstract/functor result category and be implemented through constructor composition rather than a noun-preserving wrapper.

**Why:** This was the first major signature mistake uncovered during `ExtendSqi.gf` debugging. The right fix direction is composition through existing grammar paths rather than a bespoke noun-table wrapper.

**Evidence:**
- `Extend.gf`
- `ExtendFunctor.gf`
- `AdverbSqi.gf`
- `ResSqi.gf`

**Implications:**
- Prefer constructor paths equivalent to prep + NP/CN composition.
- Preserve Albanian preposition behavior only at the point where Albanian local modules justify it.

**Do not:**
- Build `PrepCN` as `lin CN { ... }`.

---

## ALB-DEC-006
**Status:** accepted  
**Area:** `RNP` / `RNPList`  
**Decision:** Default Albanian strategy is to inherit `RNP = NP` and `RNPList = ListNP` from `ExtendFunctor`, unless Albanian-specific evidence later proves a custom subsystem is necessary.

**Why:** Uploaded `ExtendFunctor.gf` establishes the inherited baseline. Albanian failures were caused in part by flattening `RNP`/`RNPList` to `{s : Str}`. The simplest evidence-backed correction is to restore inherited NP/ListNP compatibility first.

**Evidence:**
- uploaded `ExtendFunctor.gf`
- `Extend.gf`
- run history around `ReflPoss`

**Implications:**
- `ReflPoss`, `PredetRNP`, `ConjRNP`, `Base_*_RNP`, and `Cons_*_RNP` should be compatible with NP/ListNP.
- Custom record redesign is secondary, not default.

**Do not:**
- Flatten `RNP` to `{s : Str}`.
- Mix custom and inherited `RNP` representations in the same repair pass.

---

## ALB-DEC-007
**Status:** accepted  
**Area:** `RNP` subsystem  
**Decision:** Treat the whole `RNP` family as one subsystem.

**Functions included:**
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
- `Base_rr_RNP`, `Base_nr_RNP`, `Base_rn_RNP`
- `Cons_rr_RNP`, `Cons_nr_RNP`, `Cons_rn_RNP`

**Why:** Bulgarian and German both implement these as a coordinated family. Albanian compile failures moved from `ReflPoss` to `RNPList` constructors, confirming that single-function patching is insufficient when representation is shared.

**Evidence:**
- `Bulgarian.txt`
- `GermanGF_Codedump.txt`
- uploaded `ExtendFunctor.gf`
- run logs

**Implications:**
- Any change to one member must be checked against all other members.
- `Base_*_RNP` and `Cons_*_RNP` must return `ListNP`-compatible values.

**Do not:**
- Patch `ReflPoss` in isolation and assume the family is fixed.

---

## ALB-DEC-008
**Status:** accepted  
**Area:** `RNPList` constructors  
**Decision:** `Base_*_RNP` and `Cons_*_RNP` must be wrapped as `ListNP` values, not returned as raw records.

**Why:** After the `RNP = NP` correction, the next failure moved to `Base_rr_RNP`, `Base_nr_RNP`, and `Base_rn_RNP`, where GF explicitly requested wrapping with `lin ListNP`.

**Evidence:**
- run after `RNP` fix (`Base_rr_RNP` / `Base_nr_RNP` / `Base_rn_RNP` diagnostics)
- uploaded `ExtendFunctor.gf`

**Implications:**
- Always construct `RNPList` through `lin ListNP { ... }` when overriding.

**Do not:**
- Return bare records for inherited list categories.

---

## ALB-DEC-009
**Status:** accepted  
**Area:** lock-field diagnostics  
**Decision:** `missing lock_AP` and `missing lock_CN` warnings are design warnings, not harmless noise.

**Why:** In the Albanian runs, every time these warnings clustered around one family, that family later produced a hard type mismatch. They reliably indicate that an implementation is using reduced records or wrong category shapes.

**Evidence:**
- `run_20260317_084411_20260317_084437_03_details.txt`
- `run_20260317_143053_20260317_143145_03_details.txt`

**Implications:**
- Zero hard errors but lingering lock warnings is not considered “done”.
- Warnings should be eliminated before marking a family final.

**Do not:**
- Ignore lock warnings on the grounds that generation “looks fine”.

---

## ALB-DEC-010
**Status:** accepted  
**Area:** AP/CN conversion family  
**Decision:** Functions such as `ICompAP`, `CompBareCN`, `AdjAsCN`, `AdjAsNP`, `AdvIsNPAP`, `N2VPSlash`, `CompoundAP`, and `CardCNCard` must be rewritten using category-preserving Albanian constructors or inherited functor composition whenever possible.

**Why:** This family generated the broadest cluster of `lock_AP` / `lock_CN` warnings and later surfaced as the `PredAPVP` blocker. The common root cause was flattening AP/CN values to strings and rebuilding reduced records.

**Evidence:**
- `run_20260317_143053_20260317_143145_02_raw.txt`
- `run_20260317_084411_20260317_084437_03_details.txt`
- `AlbanianGF_codedump.txt`
- `NounSqi.gf`
- `AdjectiveSqi.gf`

**Implications:**
- Prefer `CompCN`, `CompAP`, `UseComp`, `AdvVP`, and similar inherited paths where available.
- If no inherited path exists, build full Albanian category records, not reduced string wrappers.

**Do not:**
- Implement these functions by `apStr` / `cnStr` concatenation unless target type is truly string-only.

---

## ALB-DEC-011
**Status:** accepted  
**Area:** existential family  
**Decision:** `ExistS`, `ExistNPQS`, and `ExistIPQS` must be built through clause/question constructor paths, not direct string concatenation.

**Why:** The compile logs explicitly reported record-type mismatches for the existential family. This shows they are structurally tied to `Cl`/`QCl`-like machinery, not just to strings.

**Evidence:**
- `run_20260317_143053_20260317_143145_03_details.txt`
- `ExtendFunctor.gf`

**Implications:**
- Use inherited existential constructor composition whenever possible.
- Do not treat existential outputs as plain surface strings.

**Do not:**
- Revert to `pol.s ++ np.s ! Nom`-style existential implementations.

---

## ALB-DEC-012
**Status:** accepted  
**Area:** model-language policy  
**Decision:** Use Bulgarian as the first model language for the minimal `RNP` subsystem, and German as the richer secondary reference.

**Why:** Bulgarian provides a closer “small structured RNP” model, while German shows a larger custom subsystem with extra fields. German is useful for structural insight, but Bulgarian is the safer first comparison when Albanian inheritance is still under repair.

**Evidence:**
- `Bulgarian.txt`
- `GermanGF_Codedump.txt`

**Implications:**
- For `RNP`, compare Bulgarian first.
- Use German to understand subsystem completeness, not as an automatic copy target.

**Do not:**
- Copy German-specific field inventory into Albanian without direct Albanian need.

---

## ALB-DEC-013
**Status:** accepted  
**Area:** model-language limits  
**Decision:** Model languages are validation aids, not templates of truth.

**Why:** German and Bulgarian both customize some `Extend` families, but not always in the same way. Their differences prove that abstract signatures do not determine a unique concrete implementation.

**Evidence:**
- `Bulgarian.txt`
- `GermanGF_Codedump.txt`
- `Extend.gf`

**Implications:**
- Always reconcile model-language code with Albanian lincats.
- Record any model-language borrowing explicitly in this log.

**Do not:**
- Merge Bulgarian and German fragments into Albanian without a coherent target representation.

---

## ALB-DEC-014
**Status:** provisional  
**Area:** `ICompAP`, `N2VPSlash`, `AdjAsCN`, `AdjAsNP`, `CompoundAP`, and parts of `RNP`  
**Decision:** These remain best-effort until they are rebuilt entirely with full Albanian category constructors and validated by a compile run with no lock warnings.

**Why:** `ExtendFunctor.gf` does not give a ready-made default for every one of these, and the current Albanian patches still rely partly on approximations. They are the main remaining sources of non-final confidence.

**Evidence:**
- uploaded `ExtendFunctor.gf`
- latest run logs
- Albanian core modules

**Implications:**
- These functions should be priority targets for future “finalization” work.
- Any local approximation here must be marked provisional in documentation.
- Their current status should also be visible in the symbol status ledger and relevant subsystem documents.

**Do not:**
- Mark the language repair complete while these remain warning-bearing or shape-approximate.

---

## ALB-DEC-015
**Status:** accepted  
**Area:** documentation system  
**Decision:** Albanian documentation should be language-wide and modular, not restricted to `ExtendSqi.gf`.

**Why:** The repair effort showed that constructor behavior, lincat shape, morphology, syntax, inheritance, and cross-module assumptions are tightly interrelated. A narrow `ExtendSqi` doc would not prevent drift in future edits elsewhere.

**Evidence:**
- cross-file dependencies visible in `AlbanianGF_codedump.txt`
- repeated repair dependence on `CatSqi.gf`, `NounSqi.gf`, `AdverbSqi.gf`, `ResSqi.gf`, `QuestionSqi.gf`, and model-language files

**Implications:**
- Maintain the full Albanian documentation suite.
- Record future implementation decisions here with file-level evidence.
- Keep architecture docs, rule docs, inventories, and test docs in sync.

**Do not:**
- Keep important implementation rules only in chat history.

---

## ALB-DEC-016
**Status:** accepted  
**Area:** completion criterion  
**Decision:** “Final” means more than “compiles once”.

**Finality criteria:**
1. no hard type errors,
2. no `lock_AP` / `lock_CN` warnings,
3. no category-shape approximations left undocumented,
4. every override either justified by functor composition or documented as a deliberate Albanian-specific implementation,
5. minimal representative examples specified in the test suite.

**Why:** The repair history already showed multiple stages where one hard error disappeared only for the next design error to surface. A stricter definition of “done” is required.

**Evidence:**
- sequence of run logs from `PrepCN` to `ReflPoss` to `RNPList` to `PredAPVP`

**Implications:**
- Future merges should use this criterion.
- Open/provisional items should stay visible in the symbol status ledger until the finality criteria are actually met.

**Do not:**
- Declare success after the first green compile if lock warnings or undocumented approximations remain.

---

## ALB-DEC-017
**Status:** accepted  
**Area:** helper typing discipline  
**Decision:** Shared helper reuse requires exact category compatibility. Family resemblance is not enough.

**Why:** The current `ExtendSqiFocusPrep.gf` failure showed that surface-extraction permission for a shallow target does not make every nearby helper valid. In the live code, `adjSurfaceNomMascSg` is an `A -> Str` helper, while `fp_FocusAP` takes an `AP`; using the former on the latter produced a real compile failure.

**Evidence:**
- `albanian/ExtendSqiHelpers.gf`
- `albanian/ExtendSqiFocusPrep.gf`
- `run_20260325_084209_20260325_084337_01_ROOT.txt`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`

**Implications:**
- Helper tables in documentation must record exact input and output categories.
- Before reusing a helper, verify exact type, not just family (`A` vs `AP`, `N`/`CN` vs `NP`, `Pron` vs generic `NP`, `ListNP` vs `NP`).
- A local `AP -> Str` helper is acceptable for a shallow `Utt` target if the result category is truly surface-only, but an `A -> Str` helper must not be substituted for it.
- The helper registry is the first operational place to record such exact helper legality.

**Do not:**
- Reuse a helper because its name looks close to the needed category.
- Treat adjective-family helpers as interchangeable across `A`, `A2`, and `AP`.

---

## ALB-DEC-018
**Status:** accepted  
**Area:** constructor availability  
**Decision:** A documented lincat shape is necessary evidence, but it is not by itself a license to use `lin Cat { ... }` in any module. Constructor availability must be checked in the actual module context.

**Why:** The current `StructuralSqiClause.gf` failure showed that even when `DConj` is documented as surface-shaped, a local `lin DConj {s = ...}` pattern can still fail if the category/constructor is not actually available or valid in that resource context.

**Evidence:**
- `albanian/StructuralSqiClause.gf`
- `run_20260325_084209_20260325_084337_01_ROOT.txt`
- `run_20260325_084209_20260325_084337_02_raw.txt`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`

**Implications:**
- Before writing `lin Cat { ... }`, verify:
  1. the category is in scope in the current module,
  2. the fields assumed by the record match the current Albanian concrete category,
  3. the constructor path is already supported somewhere in the current codedump or is compile-validated,
  4. no existing Albanian producer/helper/paradigm path should be preferred.
- Treat simple-looking structural categories (`DConj`, `CAdv`, `Utt`, `Voc`, etc.) as high-risk if module context has not been confirmed.
- The shallow-category constructor matrix is the main operational companion for this lesson.

**Do not:**
- Infer constructor validity from lincat shape alone.
- Import a constructor pattern from one module into another without checking scope and compile behavior.

---

## ALB-DEC-019
**Status:** accepted  
**Area:** evidence quality  
**Decision:** Comments are secondary evidence only. When comments, current source, and current compiler behavior disagree, current source plus compiler reality win.

**Why:** The Albanian maintenance workflow already contains stale or historically descriptive comments. These are useful for context, but they are not authoritative enough to override current category definitions, helper signatures, or compile failures.

**Evidence:**
- current Albanian codedump
- current compile/audit workflow
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`

**Implications:**
- If a comment conflicts with live code, either update the comment or document the discrepancy explicitly.
- AI systems must not treat comments as equal to typed source and compiler diagnostics.
- Documentation should mark historical comments as historical where needed.
- The stale comment tracker is now the main place to record such mismatches explicitly.

**Do not:**
- “Fix” live code to match a stale comment.
- Use a comment as the only evidence for a constructor or helper pattern.

---

## ALB-DEC-020
**Status:** accepted  
**Area:** concrete implementation disputes  
**Decision:** For concrete coding disputes, use the following precedence order:

1. current compiler error and current source dump,
2. exact abstract signature,
3. current Albanian lincat and current Albanian core constructor path,
4. architecture and policy documents,
5. model-language comparison,
6. comments and chat history.

**Why:** The recent `fp_FocusAP` and `StructuralSqiClause` failures showed that architecture docs can be correct in principle while a specific proposed local pattern is still wrong in the live repository. Concrete coding decisions must therefore be resolved against what actually compiles now.

**Evidence:**
- `run_20260325_084209_20260325_084337_01_ROOT.txt`
- `run_20260325_084209_20260325_084337_02_raw.txt`
- `albanian/ExtendSqiFocusPrep.gf`
- `albanian/StructuralSqiClause.gf`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`

**Implications:**
- Architecture still governs ownership and subsystem design.
- Current compiler behavior governs acceptance of a concrete local code pattern.
- Future repairs should record whether a conclusion is architectural, category-shape-based, constructor-based, or compile-driven.

**Do not:**
- Choose one side globally as “always right”.
- Use architecture documents as if they certify every local constructor pattern automatically.
- Ignore current compile evidence because a pattern looked plausible in an earlier session.

---

## ALB-DEC-021
**Status:** open  
**Area:** `must_VV` in `StructuralSqiVerbal.gf` / `StructuralSqi.gf`  
**Decision:** Keep `must_VV` disabled until the crash source is isolated in the verbal helper chain.

**Why:** The current structural aggregator still keeps `must_VV` disabled with an explicit note that the crash source is not yet isolated. This means the item is known but not stable enough to normalize into ordinary structural vocabulary.

**Evidence:**
- `albanian/StructuralSqi.gf`
- current Albanian codedump

**Implications:**
- Do not silently re-enable `must_VV` in structural exports.
- Treat it as a tracked open item rather than an accidental omission.
- When it is repaired, update this entry and add minimal tests.
- Its state should also remain visible in the symbol status ledger until closure.

**Do not:**
- Remove the warning note without actual evidence.
- Treat the disabled state as proof that the rest of the verbal structural layer is unstable.

---

## ALB-DEC-022
**Status:** accepted  
**Area:** `ExtendSqi` architecture  
**Decision:** `ExtendSqi.gf` must remain a thin coordinator; companion modules own Albanian-specific subsystem logic; VPS/VPI/VPS2/VPI2/list-family machinery remains inherited in this cycle.

**Why:** The current extension architecture is intentionally split to stop coordinator drift and unsafe cross-family overrides. The thin-coordinator policy, subsystem ownership, and inherited VPS-family rule were all fixed for the current cycle and should be treated as settled unless new architectural evidence appears.

**Evidence:**
- `ALBANIAN_EXTENDSQI_FINAL_TARGET.md`
- `ALBANIAN_EXTENDSQI_OVERRIDE_MATRIX.md`
- `ALBANIAN_FUTURE_EXTENDSQI_STRUCTURE.md`
- `albanian/ExtendSqi.gf`

**Implications:**
- Keep `ExtendSqi.gf` limited to imports, subtraction list, and `lin` renamings.
- Do not create `ExtendSqiVPS.gf` in this cycle.
- Keep family coherence in subsystem modules (`RNP`, existential, AP/CN conversion, focus/prep, lexical tail, VP bridge).

**Do not:**
- Re-introduce local coordinator-side helper logic.
- Reintroduce VPS/VPI family overrides into `ExtendSqi.gf`.
- Split one family across unrelated local patches.

---

## ALB-DEC-023
**Status:** accepted  
**Area:** documentation maintenance  
**Decision:** When a compile failure reveals a missing operational rule, update the relevant rule documents and this log together.

**Why:** The current documentation suite is meant to prevent repeat drift, not merely describe the architecture. The recent helper-type and constructor-availability failures showed that a lesson is not stable until both the rule document and the decision log capture it.

**Evidence:**
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- current audit failures

**Implications:**
- New lessons should update both rule files and decision-log entries.
- The log should remain the shortest authoritative statement of each settled lesson.
- Rule documents should carry the fuller operational detail.

**Do not:**
- Leave important repair lessons only in temporary conversation history.
- Update one doc file and assume the rest of the anti-drift system will infer the change.

---

## ALB-DEC-024
**Status:** accepted  
**Area:** support documentation dependencies  
**Decision:** The helper registry, shallow-category constructor matrix, symbol status ledger, stale comment tracker, and module extraction coverage file are now authoritative companion controls for this log.

**Why:** The decision log should remain short and authoritative, but some categories of evidence are too large and too changeable to be restated cleanly as prose-only decisions. The new support documents exist specifically to hold operational inventories, matrices, fragile-symbol states, stale-comment records, and documentation-coverage status.

**Evidence:**
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`

**Implications:**
- Use this log for the short settled lesson.
- Use the helper registry for exact helper legality and status.
- Use the constructor matrix for shallow-category constructor-context questions.
- Use the symbol status ledger for fragile/open/provisional symbol tracking.
- Use the stale comment tracker for known comment/code mismatches.
- Use the module extraction coverage file to decide whether a module is documented deeply enough to guide coding without full source re-audit.

**Do not:**
- Expand this log into a duplicate of the registries and matrices.
- Leave a fragile live fact undocumented because “the rule already exists somewhere else”.

---

## ALB-DEC-025
**Status:** accepted  
**Area:** documentation coverage discipline  
**Decision:** Module-level documentation completeness must now be tracked explicitly rather than assumed.

**Why:** The older documentation debt notes explicitly left open the question of which Albanian modules were still under-extracted into the language-wide documentation set. That uncertainty is itself a drift source, because an AI may assume that a module is fully documented when only its architecture placement is known.

**Evidence:**
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`
- `ALBANIAN_LANGUAGE_ARCHITECTURE.md`
- `ALBANIAN_MODULE_DEPENDENCY_MAP.md`

**Implications:**
- Before treating a module as documentation-backed evidence, check whether it is `COVERED_IN_DEPTH`, `COVERED_STRUCTURALLY`, `PARTIALLY_EXTRACTED`, or still `PENDING_TARGETED_EXTRACTION`.
- Deep coding work on under-extracted modules should still consult the live codedump.
- Promotion from partial coverage to in-depth coverage should be recorded in the coverage file, not assumed silently.

**Do not:**
- Assume that architectural naming alone means implementation-level extraction is already complete.
- Treat a thin wrapper and a rich producer module as requiring the same level of narrative extraction.

---

## ALB-DEC-026
**Status:** accepted  
**Area:** fragile symbol tracking  
**Decision:** Symbol-level fragility, provisionality, and blocked status must be tracked centrally rather than only embedded in scattered prose.

**Why:** The Albanian codebase now has multiple classes of non-final items: open issues like `must_VV`, provisional AP/CN/RNP items, warning-state structural categories, blocked helpers, and compatibility wrappers. Leaving these statuses implicit causes AI systems to treat them as ordinary stable patterns.

**Evidence:**
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_DECISION_LOG.md`

**Implications:**
- Keep short decisions here.
- Keep live symbol status in the symbol status ledger.
- When a decision changes the fragility or maturity of a symbol, update both this log and the ledger.
- Treat provisional and open symbols as non-final even if they are currently compileable.

**Do not:**
- Hide a non-final status in one paragraph of one doc file and assume future sessions will notice.
- Treat a compatibility wrapper or blocked helper as ordinary final infrastructure.

---

## ALB-DEC-027
**Status:** accepted  
**Area:** anti-drift system integrity  
**Decision:** A documentation lesson is not considered stabilized until all affected control layers are updated together.

**Why:** The Albanian docs suite is now intentionally layered. A single repair lesson can affect:
- the short decision statement,
- the rule explanation,
- the helper inventory,
- the constructor matrix,
- the fragile-symbol ledger,
- the stale-comment tracker,
- the test suite,
- and module coverage expectations.

If only one layer is updated, the next session can still drift.

**Evidence:**
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`

**Implications:**
- A new settled lesson must propagate to every directly affected control file.
- The decision log remains the short anchor, but not the only place the lesson lives.
- Future review should ask: “which companion files must also be updated?”

**Do not:**
- Treat a conversation conclusion as if it were a stabilized project rule.
- Update only one control file and assume the system is now aligned.

---