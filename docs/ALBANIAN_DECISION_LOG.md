# ALBANIAN_DECISION_LOG.md

Status: working authoritative log  
Scope: Albanian GF concrete syntax, with emphasis on `lib/src/albanian/*` and especially `ExtendSqi.gf` when override decisions affect cross-module assumptions.

## Purpose

This file records implementation decisions that have already been made, decisions that were tested and rejected, and decisions that remain provisional. It exists to prevent drift across repair sessions and to stop future edits from re-opening settled design questions without explicit evidence.

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

---

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

**Do not:**
- Declare success after the first green compile if lock warnings or undocumented approximations remain.

---

# Rejected or superseded ideas

## ALB-REJ-001
**Status:** rejected  
**Idea:** Solve `ExtendSqi.gf` mainly by flattening values to strings and rebuilding approximate categories.

**Why rejected:** This is the direct cause of most AP/CN/NP/Cl mismatch problems found in the audit runs.

---

## ALB-REJ-002
**Status:** rejected  
**Idea:** Copy German `RNP` wholesale into Albanian.

**Why rejected:** German is structurally informative but too rich to be adopted without Albanian evidence.

---

## ALB-SUP-001
**Status:** superseded  
**Idea:** Fix `ExtendSqi.gf` one failing function at a time without subsystem grouping.

**Why superseded:** The run history proved that representation problems propagate across function families (`RNP`, `RNPList`, AP/CN conversions, existentials).

---

# Open follow-up items

These are documented here but belong in `ALBANIAN_OPEN_QUESTIONS.md` for active tracking:

1. Final category-correct Albanian implementation of `ICompAP`.
2. Final category-correct Albanian implementation of `N2VPSlash`.
3. Final category-correct Albanian implementation of `AdjAsCN`.
4. Final category-correct Albanian implementation of `AdjAsNP`.
5. Final category-correct Albanian implementation of `CompoundAP`.
6. Final coherent `RNP` family validation pass with zero warnings.
7. Final existential family validation pass with zero warnings.

---

# Change protocol

Any future entry added to this file must include:

- affected file(s),
- exact abstract signature,
- whether the decision follows `ExtendFunctor`, Albanian local precedent, or model-language precedent,
- compile evidence if available,
- whether the decision is `accepted`, `provisional`, `superseded`, `rejected`, or `open`.
