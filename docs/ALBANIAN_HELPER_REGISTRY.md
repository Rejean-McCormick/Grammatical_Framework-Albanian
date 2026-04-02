# ALBANIAN_HELPER_REGISTRY

## Status
Authoritative working registry for Albanian helper functions and helper-like constructor devices that matter for AI-assisted coding, override review, and anti-drift validation.

This file is not a general inventory of every morphology utility in the Albanian codebase. It is the registry of the helpers that an AI or maintainer is likely to touch, reuse, or misread during concrete-syntax work.

Its job is to answer five questions for every registered helper:

1. what the helper is called,
2. what its exact GF type is,
3. what helper class it belongs to,
4. where it is allowed or forbidden,
5. and whether it is stable, provisional, or blocked.

This document is intentionally explicit. If a helper is not classified here, it must not be reused casually.

---

## 1. Purpose

The Albanian codebase has repeatedly shown that “helper drift” is one of the fastest ways for an AI to make a plausible-looking but structurally wrong edit.

The two most important recent lessons are:

- a helper may look relevant by name while still having the wrong input category,
- and a shallow-looking category may still reject an apparently obvious local constructor in a specific module context.

This registry exists to stop those errors before they happen.

It is the companion document to:

- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`

---

## 2. Scope

### 2.1 In scope

This registry covers:

1. the live shared extension helper resource:
   - `GF/lib/src/albanian/ExtendSqiHelpers.gf`

2. local helper-like operations in active extension/structural subsystems that are currently drift-sensitive:
   - `GF/lib/src/albanian/ExtendSqiFocusPrep.gf`
   - `GF/lib/src/albanian/ExtendSqiRNP.gf`
   - `GF/lib/src/albanian/StructuralSqiClause.gf`

3. public constructor layers that must be preferred before ad-hoc helper invention:
   - `SyntaxSqi.gf`
   - `ConstructorsSqi.gf`
   - `TrySqi.gf`
   - `ResSqi.gf`
   - `ParadigmsSqi.gf`

4. helper usage already visible in current extension consumers such as:
   - `ExtendSqiLexicon.gf`
   - `ExtendSqiFocusPrep.gf`

### 2.2 Out of scope

This registry does **not** attempt to enumerate every low-level morphology transformer, every paradigm stem function, or every internal noun/adjective declension helper in the whole Albanian codebase.

Examples of things intentionally out of scope here:

- deep nominal stem transformers in `MorphoSqi.gf`
- one-off inflectional stem rules in `ParadigmsSqi.gf`
- general-purpose Haskell/Python audit tooling

Those belong in morphology-specific documentation, not in the anti-drift helper registry.

### 2.3 Why the scope is restricted

The purpose of this document is not “maximum number of helper names.”
The purpose is “complete coverage of the helper layer that an AI is likely to misuse during current Albanian maintenance.”

That means the registry must be exhaustive in the active extension and structural drift zones, not exhaustive over every low-level morphology primitive.

---

## 3. Source basis and precedence

This registry must be maintained against the following authority order:

1. current compiler behavior and current audit logs,
2. current Albanian source dump,
3. exact abstract signature,
4. current Albanian category/lincat reference,
5. default `ExtendFunctor` behavior,
6. architecture docs,
7. comments last.

Implications:

- a helper description in this file does not override a current compile failure,
- a stale code comment does not override the current helper type,
- a category description alone does not justify a helper reuse pattern.

---

## 4. Helper classes

Every helper in this registry must be classified as exactly one of the following.

### 4.1 Neutral utility

Definition:
- does not pretend to preserve a rich category;
- spacing, agreement constants, or simple extraction/formatting logic;
- may return `Str` or a small non-category value.

General rule:
- reusable only if the result type is actually appropriate;
- may participate in larger construction chains;
- not a substitute for a real grammar constructor.

### 4.2 Exact-type surface helper

Definition:
- extracts one visible surface form from a specific category;
- input category must be exact;
- output is `Str`.

General rule:
- allowed only when the final target is shallow or explicitly presentation-level;
- forbidden as a shortcut for rebuilding a rich output.

### 4.3 Category-preserving builder

Definition:
- returns a full Albanian category with its required structure preserved.

General rule:
- preferred over surface hacks for rich outputs;
- safe only if the helper’s return category matches the needed target category.

### 4.4 Compatibility wrapper

Definition:
- fabricates a reduced or compatibility-oriented category value from limited surface input.

General rule:
- provisional by default;
- allowed only in tightly controlled zones;
- must not silently become the canonical construction strategy for a rich category.

### 4.5 Local-only subsystem helper

Definition:
- helper-like operation defined inside one subsystem file and intended only for that subsystem.

General rule:
- not reusable across modules unless promoted explicitly;
- must be documented here if it is likely to tempt future reuse.

### 4.6 Blocked or unresolved helper

Definition:
- current code names it as a helper/constructor device,
- but current compile evidence shows the pattern is not yet accepted or not yet stable.

General rule:
- may be documented,
- may not be treated as reusable or settled,
- must carry a warning or blocked status.

---

## 5. Status vocabulary

Every registered helper must carry one of these statuses.

### 5.1 `stable`

Use is accepted in the live codebase and consistent with current documentation.

### 5.2 `restricted`

Use is accepted only for a narrow class of targets or contexts.

### 5.3 `fallback`

Use is tolerated as a compatibility or temporary device, but must not be mistaken for the final preferred pattern.

### 5.4 `warning`

Use is structurally plausible but connected to current drift risk, lock warnings, stale comments, or unresolved constructor-context uncertainty.

### 5.5 `blocked`

Current compile evidence shows the pattern is not currently valid or accepted.

---

## 6. Public constructor layers (preferred before local helper invention)

These are not all local helper functions, but they are the preferred constructor layers that should be checked before introducing or reusing local helpers.

### 6.1 `SyntaxSqi.gf`

Role:
- user-facing constructor façade.

Policy:
- prefer for ordinary client-side construction;
- do not bypass it casually when it already provides the needed category-safe path.

### 6.2 `ConstructorsSqi.gf`

Role:
- public constructor surface.

Policy:
- safer than ad-hoc record fabrication in many ordinary construction tasks;
- still subordinate to exact type and current code behavior.

### 6.3 `TrySqi.gf`

Role:
- façade / interactive constructor layer.

Policy:
- preferred for user-facing experimentation, not for replacing core grammar logic.

### 6.4 `ResSqi.gf`

Role:
- low-level Albanian resource constructors and internal shapes.

Examples explicitly documented as relevant constructor sources:
- `mkPrep`

Policy:
- use when a structural/functional category already has an Albanian resource constructor;
- preferred over naked string record fabrication for prepositions and related items.

### 6.5 `ParadigmsSqi.gf`

Role:
- low-level paradigm constructors for many structural items.

Examples explicitly documented as relevant constructor sources:
- `mkConj`
- `mkSubj`
- `mkPConj`
- `mkAdv`
- `mkVoc`

Policy:
- use for structural functional items when the paradigm constructor already matches the category.

---

## 7. Shared extension helper resource: `ExtendSqiHelpers.gf`

This section is exhaustive for the live shared helper inventory surfaced in the current source dump.

### 7.1 `wordSep`

- **Type:** `Str`
- **Class:** neutral utility
- **Status:** `stable`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** shared surface separator; current value is exactly one space.
- **Allowed use:** surface concatenation in shallow outputs, shared spacing in extension wrappers, presentation-level assembly.
- **Forbidden use:** must not be mistaken for a grammar constructor or treated as evidence that a rich category can be built by string concatenation.
- **Known consumers:** visible in `ExtendSqiFocusPrep.gf` and many local extension helpers.
- **Notes:** safe utility, but never a justification for flattening a rich category.

### 7.2 `agrMascSg`

- **Type:** `R.Agr`
- **Class:** neutral utility
- **Status:** `stable`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** agreement constant for third-person masculine singular.
- **Allowed use:** when a helper needs a conventional masculine singular agreement constant and that choice is actually correct for the target.
- **Forbidden use:** do not use as a silent generic agreement default for semantically unspecified categories.
- **Known consumers:** not singled out in the surfaced extension snippets, but valid as a shared agreement constant.
- **Notes:** a utility constant, not a constructor policy.

### 7.3 `adjSurfaceNomMascSg`

- **Type:** `A -> Str`
- **Class:** exact-type surface helper
- **Status:** `stable`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** extract the nominative masculine singular surface from category `A`.
- **Allowed use:** only when the final target is shallow and the source category is exactly `A`.
- **Forbidden use:**
  - do not use on `AP`;
  - do not use to rebuild `AP`, `NP`, `CN`, `Pron`, or any other rich category;
  - do not select it merely because the name contains “adj”.
- **Known risk:** current `fp_FocusAP` incorrectly calls this helper on an `AP`, and the compile log shows that mismatch explicitly.
- **Notes:** this helper is the canonical example of why exact helper typing must be documented.

### 7.4 `verbPres3sg`

- **Type:** `R.Verb -> Str`
- **Class:** neutral utility / exact-type surface helper
- **Status:** `restricted`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** extract third-person singular present indicative form from a resource-level verb.
- **Allowed use:** only when a shallow or presentation-level target explicitly needs this one verb form.
- **Forbidden use:** do not treat as a general finite-verb builder; do not use it to justify flattening verbal paradigms.
- **Known consumers:** not singled out in the surfaced extension snippets.
- **Notes:** allowed, but strongly restricted to explicitly shallow outputs.

### 7.5 `prepSurfaceAcc`

- **Type:** `R.Prep -> NP -> Str`
- **Class:** neutral utility / exact-type surface helper
- **Status:** `restricted`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** combine a resource-level preposition surface with an NP in accusative.
- **Allowed use:** presentation-level or shallow output assembly where the source really is a resource-level `R.Prep` and the target is `Str`.
- **Forbidden use:**
  - do not treat as the canonical preposition constructor path;
  - do not confuse `R.Prep` with the higher-level concrete category unless verified;
  - do not use it to bypass preferred `mkPrep` / `PrepNP`-style behavior.
- **Known consumers:** none explicitly surfaced in the current extension snippets.
- **Notes:** useful as a utility, but preposition handling remains a sensitive zone with lock-field implications.

### 7.6 `mkPronConst`

- **Type:** `Str -> Str -> Str -> Str -> Str -> R.Gender -> P.Number -> CatSqi.Pron`
- **Class:** category-preserving builder
- **Status:** `stable`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** build a full Albanian `Pron` with nominative, accusative, dative/ablative, clitic fields, and agreement.
- **Allowed use:** pronoun constants that really are Albanian pronoun entries.
- **Forbidden use:**
  - do not downgrade pronouns to `{s : Str}` once this builder is available;
  - do not treat it as a generic NP builder.
- **Known consumers:** current `ExtendSqiLexicon.gf` feminine/polite pronoun constants.
- **Notes:** this is the model category-preserving helper in the extension layer.

### 7.7 `adjComplStr`

- **Type:** `A -> R.Species -> R.Case -> R.Gender -> P.Number -> Str`
- **Class:** exact-type surface helper
- **Status:** `restricted`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** realize an `A` with its clitic-sensitive complement-link behavior.
- **Allowed use:** shallow or presentation-level contexts where the source is exactly `A` and the output is `Str`.
- **Forbidden use:**
  - do not use on `AP`;
  - do not use as a final builder for rich adjectival categories;
  - do not infer that all adjective-like categories have the same clitic fields.
- **Known consumers:** no explicit shared consumer surfaced in the current extension snippets; a local analogue exists in `ExtendSqiRNP.gf` for `A2`.
- **Notes:** category exactness matters here because clitic behavior is part of the type story.

### 7.8 `mkBareNpFromCn`

- **Type:** `P.Number -> CN -> NP`
- **Class:** category-preserving builder
- **Status:** `stable`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** build a bare NP from a common noun by preserving noun gender and agreement.
- **Allowed use:** when the target is genuinely `NP` and the intended reading is bare/indefinite nominalization from `CN`.
- **Forbidden use:** do not replace a `CN`-preserving path with this helper if the function still returns `CN`; do not use it just because a noun surface form is available.
- **Known consumers:** documented as part of the current helper inventory; no explicit surfaced call site in the snippets shown here.
- **Notes:** category-preserving and safe when the target really is `NP`.

### 7.9 `cnSurfaceNomSg`

- **Type:** `CN -> Str`
- **Class:** exact-type surface helper
- **Status:** `restricted`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** extract one indefinite nominative singular cell from a common noun.
- **Allowed use:** only when the final target is shallow and that exact noun cell is the intended presentation form.
- **Forbidden use:**
  - do not use to rebuild `CN`;
  - do not use to rebuild `NP` unless a specifically documented fallback path allows it;
  - do not use for card-like or AP-like outputs.
- **Known consumers:** not surfaced directly in the visible extension snippets.
- **Notes:** archetypal lossy helper.

### 7.10 `apSurfaceNomMascSg`

- **Type:** `AP -> Str`
- **Class:** exact-type surface helper
- **Status:** `restricted`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** extract one indefinite nominative masculine singular cell from an `AP`.
- **Allowed use:** only when the final target is shallow and the source is exactly `AP`.
- **Forbidden use:**
  - do not use as if it were an `A` helper;
  - do not use to rebuild `AP`, `NP`, or `CN`;
  - do not flatten a rich AP output and then pretend the result is still AP-like.
- **Known relevance:** this is the helper that should be used for a shallow AP-to-string step if `fp_FocusAP` really needs an `AP -> Str` extractor.
- **Notes:** the existence of this helper is precisely why `adjSurfaceNomMascSg` must not be used on `AP`.

### 7.11 `mkCompatAPFromStr`

- **Type:** `Str -> AP`
- **Class:** compatibility wrapper
- **Status:** `fallback`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** fabricate an AP by repeating one surface string across the AP agreement table.
- **Allowed use:** only as a temporary compatibility device when no inherited/core Albanian path is currently usable and the provisional nature is documented.
- **Forbidden use:**
  - do not call this a final AP implementation;
  - do not use it in subsystems whose whole point is to preserve AP structure faithfully;
  - do not use it when a core Albanian or inherited constructor path already exists.
- **Known consumers:** not surfaced in the current snippets.
- **Notes:** useful as a documented fallback, not a gold-standard builder.

### 7.12 `mkCompatCNFromStr`

- **Type:** `Str -> R.Gender -> CN`
- **Class:** compatibility wrapper
- **Status:** `fallback`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** fabricate a CN by repeating one surface form and attaching a gender.
- **Allowed use:** only as a temporary compatibility device when the intended subsystem is not yet able to preserve full noun structure through a better path.
- **Forbidden use:**
  - do not call this final CN-preserving syntax;
  - do not use it when noun-preserving core patterns exist;
  - do not hide it behind a neutral-sounding name.
- **Known consumers:** not surfaced in the current snippets.
- **Notes:** fallback only.

### 7.13 `mkCompatNPFromStr`

- **Type:** `Str -> R.Gender -> P.Number -> NP`
- **Class:** compatibility wrapper
- **Status:** `fallback`
- **Owner:** `ExtendSqiHelpers.gf`
- **Meaning:** fabricate an NP by repeating one surface string across cases and assigning agreement.
- **Allowed use:** narrow lexical-wrapper and compatibility contexts where the source material is already surface-level and no better constructor path is currently available.
- **Forbidden use:**
  - do not use it to justify general NP building in rich nominal syntax;
  - do not upgrade it silently into a canonical constructor;
  - do not use it in places where a proper noun-to-NP or CN-to-NP path already exists.
- **Known consumers:** `lex_UseDAP`, `lex_UseDAPMasc`, `lex_UseDAPFem` in `ExtendSqiLexicon.gf`.
- **Notes:** one of the most important helpers to label correctly because it is useful and dangerous at the same time.

---

## 8. Local-only subsystem helper registry

These helpers are not shared global extension helpers. They are documented here because they are visible in drift-prone subsystem files and might tempt future reuse.

## 8.1 `ExtendSqiFocusPrep.gf`

### 8.1.1 `fp_npSurfaceNom`

- **Type:** `NP -> Str`
- **Class:** local-only subsystem helper / exact-type surface helper
- **Status:** `restricted`
- **Owner:** `ExtendSqiFocusPrep.gf`
- **Meaning:** read nominative surface from NP for shallow `Utt` assembly.
- **Allowed use:** local focus/utterance assembly where the target is `Utt` and the source is exactly `NP`.
- **Forbidden use:** do not promote to a shared helper without explicit registration; do not use to rebuild NP-like outputs.
- **Known consumers:** `fp_FocusObj`, `fp_FocusAP`.
- **Notes:** local and reasonable, but not automatically a shared utility.

### 8.1.2 `fp_FocusObj`, `fp_FocusAdv`, `fp_FocusAdV`, `fp_FocusAP`, `fp_PrepCN`

These are subsystem operations, not general reusable helpers.

Policy note:
- They should not be entered into the helper registry as general helpers.
- They belong to subsystem behavior documentation, not reusable helper documentation.

Special warning for `fp_FocusAP`:
- current code calls `adjSurfaceNomMascSg ap`, which mismatches the helper input type because `ap` is `AP`, not `A`.
- this is a current anti-example of helper misuse, not a reusable pattern.

## 8.2 `ExtendSqiRNP.gf`

### 8.2.1 `rnp_wordSep`

- **Type:** `Str`
- **Class:** local-only subsystem helper / neutral utility
- **Status:** `stable`
- **Owner:** `ExtendSqiRNP.gf`
- **Meaning:** local spacing constant for RNP subsystem composition.
- **Allowed use:** only inside the RNP subsystem unless promoted.
- **Forbidden use:** not automatically a shared helper just because it is a separator.

### 8.2.2 `rnp_afterPrepNP`

- **Type:** `Prep -> NP -> Str`
- **Class:** local-only subsystem helper / exact-type surface helper
- **Status:** `restricted`
- **Owner:** `ExtendSqiRNP.gf`
- **Meaning:** local RNP policy for projecting NP after a preposition; current implementation ignores the prep value and takes accusative NP surface.
- **Allowed use:** only inside the current RNP subsystem while that subsystem remains on the documented strategy.
- **Forbidden use:** do not treat this as the canonical Albanian preposition helper; do not generalize outside RNP without review.
- **Notes:** semantically narrower than `prepSurfaceAcc`.

### 8.2.3 `rnp_mkCompatNPFromStr`

- **Type:** `Str -> R.Gender -> Number -> NP`
- **Class:** local-only subsystem helper / compatibility wrapper
- **Status:** `fallback`
- **Owner:** `ExtendSqiRNP.gf`
- **Meaning:** local NP compatibility constructor for RNP-family fallback needs.
- **Allowed use:** only within the RNP subsystem as documented fallback behavior.
- **Forbidden use:** do not confuse with the shared `mkCompatNPFromStr` as if they were interchangeable without review.
- **Notes:** same broad idea as the shared compatibility wrapper, but local ownership still matters.

### 8.2.4 `rnp_adjComplStr`

- **Type:** `A2 -> R.Species -> R.Case -> R.Gender -> Number -> Str`
- **Class:** local-only subsystem helper / exact-type surface helper
- **Status:** `restricted`
- **Owner:** `ExtendSqiRNP.gf`
- **Meaning:** local clitic-sensitive complement realization for `A2`.
- **Allowed use:** only inside RNP/AP-complement logic where the source is exactly `A2`.
- **Forbidden use:** do not substitute for `adjComplStr` on plain `A`; do not promote casually to shared status.
- **Notes:** its existence is another example of why near-type helper reuse is dangerous.

### 8.2.5 Remaining `rnp_*` operations

The rest of `rnp_ReflRNP`, `rnp_ReflPron`, `rnp_ReflPoss`, `rnp_PredetRNP`, `rnp_AdvRNP`, `rnp_AdvRVP`, `rnp_AdvRAP`, `rnp_ReflA2RNP`, `rnp_PossPronRNP`, `rnp_ConjRNP`, `rnp_Base_*`, and `rnp_Cons_*` are subsystem implementations, not general reusable helpers.

Policy:
- document them in subsystem docs,
- do not treat them as shareable helpers,
- and do not mine them as “generic patterns” outside the RNP family.

## 8.3 `StructuralSqiClause.gf`

### 8.3.1 `mkDConj`

- **Type (intended):** `Str -> DConj`
- **Class:** local-only subsystem helper / blocked constructor device
- **Status:** `blocked`
- **Owner:** `StructuralSqiClause.gf`
- **Meaning:** local constructor attempt for paired conjunction values.
- **Current problem:** compile logs show `constant not found: DConj` in this module context when the file tries `lin DConj {s = s}`.
- **Allowed use:** none as a reusable pattern in the current state.
- **Forbidden use:**
  - do not cite this as evidence that `lin DConj { ... }` is generally safe;
  - do not copy this pattern into other modules;
  - do not treat category documentation alone as proof that this constructor is accepted.
- **Notes:** this is a canonical blocked example for the constructor-availability rule.

---

## 9. Helper consumers that matter for anti-drift review

This section records visible helper consumption that affects policy.

### 9.1 `ExtendSqiLexicon.gf`

Current lexical wrappers use:
- `mkPronConst` for pronoun constants,
- `mkCompatNPFromStr` for `UseDAP`, `UseDAPMasc`, `UseDAPFem`.

Policy consequence:
- pronoun constants are on the category-preserving path,
- `UseDAP*` wrappers are explicitly compatibility-based lexical wrappers,
- AI systems must not generalize the `UseDAP*` pattern into a global NP-building strategy.

### 9.2 `ExtendSqiFocusPrep.gf`

Current `fp_FocusAP` uses the wrong helper in the current code state:
- it feeds an `AP` to `adjSurfaceNomMascSg`, which is typed for `A`.

Policy consequence:
- helper names are not enough,
- helper input type must be verified exactly,
- shallow output permission for `Utt` does not cancel type discipline.

### 9.3 `StructuralSqiClause.gf`

Current `mkDConj` attempt shows:
- even if category documentation says `DConj = {s : Str}`,
- a local `lin DConj { ... }` pattern may still fail in the current module context.

Policy consequence:
- shallow category shape does not guarantee local constructor validity.

---

## 10. Non-helper patterns that must not be misclassified as helpers

The following are **not** to be registered or reused as generic helpers unless explicitly promoted later.

### 10.1 Subsystem implementation functions

Examples:
- `apcn_*`
- `ex_*`
- `fp_*` behavior functions
- `rnp_*` family functions beyond the small local helpers listed above
- `sc_*`
- `vp_*`

Reason:
- these are subsystem implementation operations, not reusable helper primitives.

### 10.2 Pure lexical constants

Examples:
- `lex_iFem_Pron`
- `lex_youFem_Pron`
- `lex_ReflPossPron`

Reason:
- they are entries or wrappers, not helper infrastructure.

### 10.3 Deep morphology utilities

Reason:
- they belong in morphology documentation, not in this anti-drift helper registry.

---

## 11. Selection protocol for AI and maintainers

When choosing a helper, follow this exact protocol.

1. Read the exact abstract signature.
2. Confirm the needed output category.
3. Check whether a public constructor layer already solves the problem.
4. Check whether an Albanian core module already provides the construction pattern.
5. Only then consult this helper registry.
6. If a helper is considered, verify:
   - exact input type,
   - exact output category relevance,
   - helper class,
   - status,
   - owner module,
   - known restrictions.
7. Reject the helper if it is:
   - blocked,
   - fallback in a final rich-category context,
   - a near-type mismatch,
   - or only local to another subsystem.
8. Confirm compile behavior after the change.

This protocol is mandatory for AI-assisted repair work.

---

## 12. Forbidden helper reasoning

The following reasoning patterns are forbidden.

### 12.1 “The names look similar”

Examples:
- `adjSurfaceNomMascSg` must be fine for `AP`
- `mkCompatNPFromStr` must be fine for any noun-like thing
- `rnp_afterPrepNP` must be the same as the global preposition helper

### 12.2 “The category looks shallow”

Examples:
- `DConj` looks like `{s : Str}`, so `lin DConj { ... }` must be safe everywhere
- `Prep` looks surface-only, so any naked string must be fine

### 12.3 “The code compiles somewhere else”

Examples:
- a pattern seen in one module must transfer to another module with different opens/imports

### 12.4 “Fallback equals final”

Examples:
- compatibility wrappers can be documented as if they were canonical builders

### 12.5 “Shallow target cancels type discipline”

Examples:
- because the target is `Utt`, any adjective-like helper is acceptable on any adjective-like source

---

## 13. Promotion and removal policy

### 13.1 Promotion rule

A local-only helper may be promoted into the shared helper layer only if all of the following hold:

1. it is used by more than one subsystem or is clearly reusable,
2. its input and output categories are stable and well-defined,
3. its semantics are not tied to one subsystem’s private representation,
4. it compiles cleanly in the shared helper context,
5. it receives a proper registry entry here.

### 13.2 Removal rule

A compatibility wrapper or workaround helper should be removed or demoted when:

1. an inherited constructor path becomes available,
2. an Albanian core-module path replaces the workaround,
3. the helper is found to encourage drift or misuse,
4. a final subsystem implementation no longer needs it.

### 13.3 Blocked helper rule

Blocked helpers stay documented until the issue is resolved, but they must be labeled blocked and must not be recommended as reusable patterns.

---

## 14. Minimal maintenance checklist

When this registry changes, also check:

- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`

This registry is not a side note. It is one of the main anti-drift control documents.

---

## 15. Compact summary

The live Albanian helper story is currently:

- use public/core constructor layers first,
- use shared `ExtendSqiHelpers` second,
- treat exact type as mandatory,
- treat compatibility wrappers as fallback only,
- treat subsystem-local helpers as local unless promoted,
- treat blocked helpers like `mkDConj` as warnings, not patterns,
- and never let a helper name override type, category shape, or current compile reality.
