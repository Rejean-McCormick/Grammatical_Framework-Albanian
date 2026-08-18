# Albanian Extend specifics: lock fields and coordinator boundary

## Status and purpose

This document is the **tactical repair guide** for `ExtendSqi`.

It does **not** replace the Albanian phase plan, the final-target architecture doc, or the override matrix. Those documents already define the architecture, the phase order, and the stable ownership map. This document exists to make one class of work explicit and repeatable:

- coordinator-boundary decisions in `ExtendSqi.gf`
- lock-field failures in full `ExtendSqi` builds
- subsystem repair order for `ExtendSqiVPBridge`, `ExtendSqiAPCN`, `ExtendSqiRNP`, and related glue
- acceptance rules for temporary shallow fallbacks versus category-preserving Albanian paths
- drift prevention when current code, current logs, and current ownership docs disagree

Use this document when a change compiles in isolation but the **full `ExtendSqi` build still warns or crashes**.

## What this document is for

Use this document when any of the following happens:

- `ExtendSqi.gf` is the only remaining failing concrete
- the build emits `missing lock field lock_*` warnings
- `GeneratePMCFG.hs` crashes after warning floods
- a subsystem compiles alone but fails or degrades when wired through `ExtendSqi.gf`
- there is uncertainty about whether to keep a function inherited from `ExtendFunctor` or override it locally
- there is uncertainty about whether Bulgarian or German should be used as the model for a specific Albanian override
- the current code and the override matrix disagree about who owns a function

Do **not** use this document as the primary source for overall project ordering. For that, use the Albanian phase plan.

---

## Authority order

When deciding how to implement or repair an Albanian `Extend` function, use this precedence order.

1. **Current abstract signature and current compile behavior**
2. **`ExtendFunctor` composition path**
3. **Current Albanian category shape and Albanian core-module precedent**
4. **Current override matrix / target architecture**
5. **Model languages**
6. **Comments, stale notes, and older local drafts**

This order is mandatory.

### Consequences

- Never choose an implementation by function name alone.
- Never let a model-language function override the evidence of the current abstract signature.
- Never prefer a shallow local rewrite over a working `ExtendFunctor` path unless Albanian evidence forces it.
- Never treat an older comment as stronger than the current compiler behavior.
- Never let current code ownership override the approved ownership docs without an explicit doc update.

---

## Non-negotiable invariants

### 1. `ExtendSqi.gf` stays a thin coordinator

`ExtendSqi.gf` exists to wire Albanian subsystem ownership. It is **not** the place to accumulate ad hoc local repair logic.

Allowed in `ExtendSqi.gf`:

- inheritance restriction (`- [ ... ]`) when justified
- subsystem import / opening
- direct wiring from subsystem operations to abstract functions
- minimal `lincat` declarations only when boundary completion requires them and the family remains coherent
- explicit shallow boundary declarations for inherited families only when documented in the override matrix

Not allowed in `ExtendSqi.gf`:

- local reinvention of subsystem logic that belongs in helpers/scaffolding/APCN/VPBridge/RNP/etc.
- piecemeal category-shape workarounds that should live in a subsystem
- unstructured copying from `ExtraSqi`
- local ownership of functions marked inherited in the override matrix

### 2. `ExtendFunctor` is the primary model for Albanian `ExtendSqi`

Default assumption: if `ExtendFunctor` already gives a valid path, Albanian should inherit it.

Override only when:

- the abstract function is not adequately realized by the inherited path, or
- Albanian category shape / agreement / complement behavior requires a real local family.

### 3. Never half-localize a family

If Albanian overrides a family, it must override it **coherently**.

A family is “half-localized” when Albanian subtracts functions from `ExtendFunctor` but does not supply the `lincat`/`lin` side needed for the whole family.

Typical danger zones:

- `VPI`, `VPI2`, `VPS`, `VPS2`
- `ListVPI`, `ListVPI2`, `ListVPS`, `ListVPS2`
- `Base*`, `Cons*`, `Conj*` list/coordination families
- `Comp` and `Imp` coordination boundaries

### 4. Lock-field warnings are blocking defects

In this project state, a `missing lock field lock_*` warning is not cosmetic noise.

Treat every such warning in a full `ExtendSqi` build as a **blocking structural defect** until proven otherwise.

A patch is not acceptable just because:

- the individual subsystem compiles, or
- the function typechecks locally, or
- the result “looks string-like enough.”

### 5. `ExtraSqi` is a temporary surface reference, not the final correctness model

`ExtraSqi` may justify temporary shallow wrappers for explicitly shallow surface behavior.

It must **not** be used as proof that the same shallow wrapper is acceptable in full `ExtendSqi`.

Reason: `ExtraSqi` is a surface extension layer; `ExtendSqi` is a full `Extend` concrete.

### 6. Rich categories must stay rich unless the target is genuinely shallow

Do not flatten:

- `AP`
- `CN`
- `NP`
- `Pron`
- `A2` / `N2`-derived structures

unless the target category is genuinely shallow in Albanian and the loss is explicitly documented as temporary.

Examples of commonly shallow Albanian targets:

- `Utt`
- many clause-like string categories such as `S`, `QS`, `RS`, `Cl`, `QCl`, `Comp`, `Imp`, `VP`, `VPSlash` in the current `CatSqi`

Examples of categories that must be handled more carefully:

- `AP`
- `CN`
- `NP`
- `Pron`
- anything built from `A2`, `N2`, determiners, or quantified nominal structures

### 7. Override matrix is binding for coordinator ownership

If the override matrix marks a function as **inherit**, `ExtendSqi.gf` must not:

- subtract it from `ExtendFunctor`
- wire a local replacement
- or locally own surrounding family machinery for it

unless the matrix is updated first.

This rule exists specifically to prevent coordinator drift.

---

## Mandatory pre-edit gate for `ExtendSqi.gf`

Run this gate before any coordinator edit.

1. Confirm the exact abstract signature.
2. Check the current `ExtendFunctor` path.
3. Check the current override matrix.
4. Check the current full-build stderr.
5. Only then decide whether the function is:
   - inherited
   - local override
   - or boundary-declaration-only

### Hard stop rules

Do **not** edit `ExtendSqi.gf` if any of the following is true:

- the function is marked inherited in the matrix and no matrix update has been made
- the edit would move subsystem logic into the coordinator
- the edit would create local list-family logic
- the edit is being justified only by a warning, without checking signature/functor/category evidence
- the edit would accept a new `lock_*` warning as “good enough”

---

## Default decision workflow

Apply this workflow to every problematic function.

### Step 1. Confirm the exact abstract signature

Write down:

- argument categories
- result category
- whether the result is shallow or rich in Albanian

Do not start from a guessed implementation pattern.

### Step 2. Check the inherited `ExtendFunctor` path

Ask:

- Does `ExtendFunctor` already provide the correct composition path?
- Is Albanian subtracting this function for a real reason, or just because an earlier draft did?
- Would restoring inheritance be more correct than a local fallback?

If `ExtendFunctor` is adequate, prefer inheritance.

### Step 3. Check current Albanian lincats and core precedent

Open and inspect:

- `CatSqi.gf`
- the Albanian core modules relevant to the family
- helper modules already established for Albanian

Ask:

- What is the real Albanian category shape?
- Does the category carry agreement / case / species / complement fields?
- Is there already an Albanian constructor/composition path for this shape?

### Step 4. Check the override matrix and target architecture

Ask:

- Is this function supposed to be inherited or overridden this cycle?
- Is the current code already drifting from the approved ownership?
- Is the current problem really a subsystem bug, or a coordinator-ownership bug?

### Step 5. Decide whether the target is shallow or rich

If shallow:

- a surface extractor may be acceptable
- a fallback record may be acceptable

If rich:

- preserve the full shape if at all possible
- prefer inherited or Albanian-compositional constructors
- compatibility helpers are temporary and must be explicit

### Step 6. Only then consult model languages

Use model languages to answer **structural** questions, not lexical or surface questions.

### Step 7. Reject any patch that introduces new lock warnings

If the full `ExtendSqi` compile emits a new `lock_*` warning after your patch, the patch is not finished.

---

## Model-language usage rules

### Primary model selection

Use this default order:

1. `ExtendFunctor`
2. Albanian core modules
3. Bulgarian for `RNP` and minimal structured list/coordination behavior
4. German for rich whole-family overrides and category-shape-preserving redesign

### Bulgarian is the first comparison when

- the problem is in `RNP`
- the issue is a minimal list/coordination family around `NP`
- the target behavior is structurally small and regular

### German is the first comparison when

- the problem is a rich override family
- the issue is how to preserve category shape across a family
- the override interacts with richer AP/CN/NP-like behavior
- the problem spans several related functions in one subsystem

### Never do these

- do not copy German or Bulgarian by function name alone
- do not import German-specific structural assumptions unless Albanian lincats require them
- do not use Bulgarian as proof against a working functor/default path
- do not use model-language surface strings as Albanian design evidence

---

## Coordinator-boundary rules

These rules govern `ExtendSqi.gf`.

### 1. The coordinator must only subtract what Albanian really owns

If a function is subtracted from `ExtendFunctor`, Albanian must supply:

- a valid local family boundary
- the needed `lincat` side if inheritance no longer supplies it
- a coherent `lin` implementation path

### 2. Do not rely on implicit default lincats in production patches

If the compiler says it is “inserting default `{s : Str}`” for a family, treat that as a boundary failure.

Only add explicit shallow `lincat`s if:

- the family is intentionally shallow in Albanian for this cycle, and
- the family is wired coherently, and
- the choice is documented here and in the override matrix / phase notes.

### 3. Boundary glue belongs in scaffolding, not in the coordinator body

If Albanian needs temporary glue for:

- `Base*`
- `Cons*`
- `Conj*`
- `Mk*`
- `Pred*`

that glue should live in `ExtendSqiScaffolding.gf` or the owning subsystem, not as ad hoc local coordinator logic.

### 4. Individual-module success does not clear a subsystem

A subsystem is only considered stable when:

- it compiles individually, and
- the full `ExtendSqi` build compiles without new lock warnings from that subsystem.

### 5. Inherited-family boundary declarations do not transfer ownership

If `ExtendSqi.gf` contains local shallow `lincat` declarations for an inherited family, that does **not** mean Albanian locally owns the family logic.

Boundary declarations are allowed only to make the inherited shallow family explicit and prevent silent default insertion.

### 6. High-risk mismatch rule

If a function is:

- marked inherited in the matrix
- but still subtracted or locally wired in code

then fix that mismatch before accepting any other coordinator-side patch.

---

## Lock-field triage protocol

Use this section whenever a full build emits `missing lock field lock_*` warnings.

### Interpretation

A lock warning means the full concrete build expected a record shape that was not preserved by the current local linearization path.

In practice, this usually means one of the following:

- a hand-built `lin` record dropped structure that an inherited path would have preserved
- a provisional compatibility helper is being used in a place that is too rich for it
- the coordinator boundary is incoherent and the function is being checked against the wrong inherited family context
- a local shallow wrapper is acceptable in isolation but not in the full `ExtendSqi` concrete
- the current coordinator ownership already disagrees with the approved ownership docs

### Severity rule

Prioritize warnings in this order:

1. the first named warning in the failing run
2. repeated warnings across one subsystem family
3. warnings on coordinator-wired functions that should be inherited
4. warnings in lexical-tail temporary wrappers

### Triage order

1. inspect the first named warning in stderr
2. inspect the whole subsystem family of that function
3. inspect the coordinator subtraction/wiring for that family
4. compare current coordinator ownership against the override matrix
5. only then inspect secondary warning clusters

### Current live example

At the time of writing, the live first-warning example is `vp_A2VPSlash`, followed by many coordinator-wired lock warnings and a final crash in `GeneratePMCFG.hs`.

That pattern means:

- start with VP bridge
- do not start by cleaning lexical tail or RNP in isolation
- check whether the coordinator/functor boundary is amplifying the damage
- check whether inherited functions are being locally owned against the matrix

---

## Subsystem playbooks

## VP bridge playbook

### Scope

This family includes at least:

- `PresPartAP`
- `EmbedPresPart`
- `PastPartAP`
- `PastPartAgentAP`
- `PassVPSlash`
- `PassAgentVPSlash`
- `NominalizeVPSlashNP`
- `ProgrVPSlash`
- `A2VPSlash`
- `N2VPSlash`
- `AdvIsNP`
- `AdvIsNPAP`
- `PurposeVP`
- `WithoutVP`
- `ByVP`
- `InOrderToVP`
- `CompoundAP`

### Rules

- Repair this family **as a family**, not by isolated one-line edits.
- `A2VPSlash` and `N2VPSlash` are high-risk because they project richer complement-bearing categories into slash/string-like outputs.
- Prefer inherited or Albanian compositional paths first.
- Only use compatibility helpers for AP/NP outputs when the richer path is genuinely unavailable and the choice is explicitly temporary.
- Clause/adverbial outputs may be shallow, but that does not automatically justify shallow intermediate projections.

### Immediate priority order

1. `A2VPSlash`
2. `N2VPSlash`
3. participial AP bridges
4. passive/progressive/nominalizing slash bridges
5. `AdvIsNP` and `AdvIsNPAP`
6. purpose/without/by/in-order-to adverbial wrappers

### Typical red flags

- constructing a `VPSlash` by raw concatenation from an `A2` or `N2`
- AP-producing participle functions implemented only via `mkCompatAPFromStr`
- coordinator run shows `lock_A`, `lock_A2`, `lock_N2`, `lock_VPSlash`, or `lock_VP` on this family

## APCN and complement playbook

### Scope

This family includes at least:

- `ICompAP`
- `CompBareCN`
- `CompIQuant`
- `PredAPVP`
- `AdjAsCN`
- `AdjAsNP`
- `CardCNCard`
- any AP/CN/Comp bridge used again from VP bridge or focus logic

### Rules

- Keep rich-category outputs rich.
- `IComp` may be shallow; `AP` and `CN` are not.
- `AdjAsCN` and `AdjAsNP` are allowed to be provisional, but they must stay explicitly provisional and must not silently become the default pattern.
- `PredAPVP` should prefer inherited Albanian composition over raw string building.

### Typical red flags

- hard-coding gender in AP→CN bridges without subsystem-level justification
- taking raw noun cells when canonical `CompCN` or other inherited composition exists
- new `lock_AP`, `lock_CN`, or `lock_IComp` warnings after APCN edits

## Existential playbook

### Scope

This family includes:

- `ExistS`
- `ExistNPQS`
- `ExistIPQS`
- `ExistCN`
- `ExistMassCN`
- `ExistPluralCN`
- `ExistsNP`

### Rules

- Prefer clause/question composition via Albanian core constructors.
- Avoid raw string assembly unless the target really is only a shallow clause surface.
- If existential logic already composes through `ExistNP`, `ExistIP`, `UseCl`, or `UseQCl`, keep that path.

## RNP playbook

### Scope

This family includes:

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

### Rules

- Start with inherited `NP`/`ListNP` behavior.
- Bulgarian is the first model-language comparison for this family.
- If custom list behavior is required, redesign the RNP list family together.
- Do not keep obsolete coordinator wiring for abstract functions that are not actually present.

### Typical red flags

- unreachable-branch warnings in complement helpers
- ad hoc local `NP` compatibility wrappers becoming permanent
- list-family functions present in the coordinator but absent from the abstract

## Focus / preposition playbook

### Scope

This family includes:

- `FocusObj`
- `FocusAdv`
- `FocusAdV`
- `FocusAP`
- `PrepCN`

### Rules

- `Utt` targets are shallow, so surface extraction is acceptable there.
- `PrepCN` must stay aligned with Albanian preposition/government behavior.
- If an AP surface helper is needed for `FocusAP`, it must be the exact AP helper, not an `A` helper with a similar name.

## Lexical-tail playbook

### Scope

This family includes at least:

- `ReflPossPron`
- feminine/polite pronoun additions
- `UseDAP`
- `UseDAPMasc`
- `UseDAPFem`

### Rules

- No structural repair logic belongs here.
- DAP wrappers may remain provisional, but they should not be allowed to drive category policy for the rest of `ExtendSqi`.
- If `UseDAP*` emits lock warnings in full build, fix the wrapper, not the coordinator.

---

## Anti-drift rules

Use this section to prevent slow degradation.

- Do not normalize provisional helpers into permanent defaults just because they compile.
- Do not move rich-category logic into lexical-tail wrappers.
- Do not treat a shallow `ExtraSqi` pattern as proof that `ExtendSqi` should also be shallow.
- Do not accept compile success in a single subsystem as a substitute for full `ExtendSqi` stability.
- Do not accept new default-inserted `lincat`s without documenting the family decision.
- Do not change coordinator ownership without updating the override matrix in the same change.
- Do not let current code outrank the approved ownership docs.

---

## Acceptance checklist for any patch

A patch is only ready when all items below are true.

### Signature and architecture

- [ ] Exact abstract signature checked
- [ ] Current compile behavior checked
- [ ] `ExtendFunctor` path checked first
- [ ] Albanian `CatSqi` lincat shape checked
- [ ] Albanian core-module precedent checked
- [ ] Correct model-language priority used
- [ ] Override matrix checked
- [ ] Current coordinator ownership checked against the matrix

### Category safety

- [ ] No accidental flattening of `AP`, `CN`, `NP`, or `Pron`
- [ ] Any compatibility helper is explicitly justified as temporary
- [ ] Rich targets remain rich where required
- [ ] Shallow targets are shallow by category, not by convenience

### Family coherence

- [ ] Whole subsystem family inspected, not only one function
- [ ] Coordinator subtraction/wiring checked for that family
- [ ] No half-localized family remains
- [ ] No default-inserted `lincat` is being relied on silently
- [ ] No inherited function is still locally owned by drift

### Compile acceptance

- [ ] Individual subsystem compile succeeds
- [ ] Full `ExtendSqi` compile succeeds or advances without new structural regressions
- [ ] No new `missing lock field` warnings introduced
- [ ] Existing first-warning hotspot is either fixed or clearly narrowed

### Documentation acceptance

- [ ] If a temporary fallback remains, it is recorded here
- [ ] If a family boundary decision changed, the override matrix is updated
- [ ] If the phase/order implications changed, the phase doc is updated
- [ ] If model-language priority was non-default, that choice is documented

---

## Current watchlist template

Maintain this section during active repair.

### First-warning hotspot

- `vp_A2VPSlash`

### Current subsystem watchlist

- VP bridge family
- APCN family
- existential family
- RNP family
- DAP wrappers
- any coordinator-wired function still emitting `lock_*` in full `ExtendSqi`

### Current boundary watchlist

- `Comp` / `Imp` coordination families
- `VPI` / `VPI2` / `VPS` / `VPS2` families
- list-family `lincat` insertion by default
- any inherited function still subtracted in `ExtendSqi.gf`

---

## Maintenance rule

Whenever a full `ExtendSqi` run fails with a new first-warning hotspot, update this document in exactly three places:

1. **Current watchlist template**
2. the relevant subsystem playbook
3. the coordinator-boundary section if ownership or inheritance assumptions changed

Do not rewrite the whole document for each run.

---

## Relationship to other Albanian docs

Use the docs in this order:

1. Albanian phase / architecture doc for project ordering
2. final target / override matrix for stable ownership decisions
3. this document for tactical repair decisions in `ExtendSqi`
4. model-language comparison notes when deciding Bulgarian vs German vs functor/default path
5. local comments only as supporting context

This document should stay short enough to be used during live debugging, but concrete enough that two different contributors would make the same repair decision from it.