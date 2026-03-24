# ALBANIAN_EXTENDSQI_FINAL_TARGET

## Status
Approved target architecture for the current Albanian development cycle.

This document defines the final intended role of `GF/lib/src/albanian/ExtendSqi.gf` and the subsystem ownership rules that all companion modules must follow.

---

## 1. Purpose

The purpose of this document is to freeze the target architecture of the Albanian `Extend` layer before further implementation work.

The guiding principle for this cycle is:

- `ExtendSqi.gf` is a **thin coordinator**.
- Companion modules hold Albanian-specific implementation logic.
- Unsupported families stay inherited from `ExtendFunctor`.
- Every local override must be justified by Albanian-specific evidence and must preserve the correct concrete category shape.

This document is the source of truth for all `ExtendSqi`-related edits in this cycle.

---

## 2. Final target for `GF/lib/src/albanian/ExtendSqi.gf`

`ExtendSqi.gf` must be a **thin wiring layer only**.

It must contain:

- the concrete header and `Grammar = GrammarSqi` binding
- the canonical subsystem imports
- the subtraction list for supported local Albanian overrides only
- the `lin` renamings that connect abstract `Extend` functions to subsystem implementations

It must not contain:

- local VPS/VPI/VPS2/VPI2/list-family machinery
- local coordinator-side helper definitions
- generic repair code
- drifted or experimental logic that belongs in a subsystem module
- overflow implementations that should live in core Albanian modules

---

## 3. Fixed architecture decisions for this cycle

### 3.1 Coordinator rule

`ExtendSqi.gf` remains thin and declarative.

### 3.2 Companion module set

The canonical Albanian `Extend` companion modules for this cycle are:

- `GF/lib/src/albanian/ExtendSqiScaffolding.gf`
- `GF/lib/src/albanian/ExtendSqiExistential.gf`
- `GF/lib/src/albanian/ExtendSqiAPCN.gf`
- `GF/lib/src/albanian/ExtendSqiFocusPrep.gf`
- `GF/lib/src/albanian/ExtendSqiVPBridge.gf`
- `GF/lib/src/albanian/ExtendSqiRNP.gf`
- `GF/lib/src/albanian/ExtendSqiLexicon.gf`
- `GF/lib/src/albanian/ExtendSqiHelpers.gf`

### 3.3 VPS-family decision

Do **not** build `ExtendSqiVPS.gf` in this cycle.

The entire VPS/VPI/VPS2/VPI2/list-wrapper family remains inherited from `ExtendFunctor`.

Reason:

- the family was previously half-local and failed as a family
- the chosen architecture for this cycle is stability first
- the coordinator must not reintroduce unsupported local list-family logic

### 3.4 Contract-side rule

Boundary-facing helpers must align with the `Extend` / `ExtendFunctor` / `CommonX` contract, not with ad hoc local shapes.

### 3.5 Category-shape rule

Do not flatten rich Albanian categories to `Str` unless the current Albanian lincat is already string-shaped.

### 3.6 Family-coherence rule

Subsystems are implemented and reviewed family-by-family, not one isolated function at a time.

---

## 4. Final role of each subsystem

### 4.1 `ExtendSqiScaffolding.gf`

Role:

- boundary-safe helpers
- contract alignment helpers
- small Albanian glue operations that do not belong in richer subsystem modules

Responsibilities include:

- `GenNP`, `GenIP`, `GenRP`, `GenModNP`, `GenModIP`
- pied-piping/stranding shell helpers
- basic utterance and complement wrappers
- boundary-facing tense/polarity/anteriority helpers
- gerund wrappers
- small NP/CN/Comp helpers

This subsystem is the first stabilization target and must remain contract-correct.

### 4.2 `ExtendSqiVPBridge.gf`

Role:

- participial/AP/VP bridging
- VPSlash-derived bridges
- VP-to-Adv/AP conversion helpers in the Albanian extension layer

### 4.3 `ExtendSqiAPCN.gf`

Role:

- AP/CN/NP conversion family
- category-preserving adjectival and nominal bridge helpers

### 4.4 `ExtendSqiExistential.gf`

Role:

- existential family only
- all existential variants implemented coherently as one subsystem

### 4.5 `ExtendSqiRNP.gf`

Role:

- reflexive NP family
- reflexive/possessive/RNP coordination family
- AP/VP attachment helpers that are specifically part of the RNP family

### 4.6 `ExtendSqiFocusPrep.gf`

Role:

- focus family
- focused prep-related extension behavior only

### 4.7 `ExtendSqiLexicon.gf`

Role:

- extension-specific lexical tail only
- no structural repair logic

### 4.8 `ExtendSqiHelpers.gf`

Role:

- local helper constructors and reusable internal support for the above modules
- not a second coordinator

---

## 5. Final ownership map

### Owned by `ExtendSqi.gf`

Only:

- subsystem imports
- subtraction list
- subsystem renamings

### Owned by `ExtendSqiScaffolding.gf`

Only:

- boundary-safe glue helpers
- tense/polarity/anteriority contract-safe wrappers
- gerund and small shell wrappers

### Owned by `ExtendSqiVPBridge.gf`

Only:

- VP/VPSlash/AP/Adv bridge family

### Owned by `ExtendSqiAPCN.gf`

Only:

- AP/CN/NP conversion family

### Owned by `ExtendSqiExistential.gf`

Only:

- existential family

### Owned by `ExtendSqiRNP.gf`

Only:

- reflexive NP / RNP family

### Owned by `ExtendSqiFocusPrep.gf`

Only:

- focus/preposition extension behavior

### Owned by `ExtendSqiLexicon.gf`

Only:

- extension-specific lexical entries and lexical wrappers

---

## 6. Final override policy for this cycle

A function belongs in local Albanian `Extend` code only when all of the following are true:

1. The abstract `Extend` function is present and understood.
2. The `ExtendFunctor` default path is inspected.
3. The Albanian category shape is confirmed in the current codedump.
4. The override has a specific Albanian reason.
5. The implementation preserves the correct concrete category shape.

Otherwise, the function remains inherited.

This cycle applies that rule strictly.

---

## 7. Explicit inherited families

The following remain inherited from `ExtendFunctor` for this cycle:

- VPS family
- VPI family
- VPS2 family
- VPI2 family
- list wrappers for those families
- any `Base*` / `Cons*` / `Conj*` members belonging to that unsupported local family

These are intentionally not owned by local Albanian subsystem modules in this cycle.

---

## 8. Explicit local Albanian subsystem families

The following are local Albanian subsystem families for this cycle:

- scaffolding family
- existential family
- AP/CN family
- focus/prep family
- VP bridge family
- RNP family
- lexical tail

Each of these is completed and validated as a family.

---

## 9. Acceptance criteria for this cycle

The Albanian `Extend` layer is considered correct for this cycle only when all of the following are true:

1. `ExtendSqi.gf` remains a thin coordinator.
2. `ExtendSqiScaffolding.gf` is contract-correct.
3. No unsupported local VPS/VPI/VPS2/VPI2/list-family logic is present.
4. Every local override is owned by the correct subsystem file.
5. No accidental category flattening has been introduced.
6. The full Albanian extension layer compiles cleanly.
7. No new lock warnings are introduced by the extension layer.
8. Final public-surface validation through `GrammarSqi` and `SyntaxSqi` passes.

---

## 10. Current implementation order

The implementation order for this cycle is fixed:

1. `ExtendSqiScaffolding.gf`
2. `ExtendSqiHelpers.gf`
3. `ExtendSqi.gf` coordinator lock
4. `ExtendSqiVPBridge.gf`
5. `ExtendSqiAPCN.gf`
6. `ExtendSqiExistential.gf`
7. `ExtendSqiRNP.gf`
8. `ExtendSqiFocusPrep.gf`
9. `ExtendSqiLexicon.gf`
10. structural cleanup outside `Extend`
11. final validation

---

## 11. Anti-drift rules

The following are prohibited during this cycle:

- reintroducing local VPS/VPI/VPS2/VPI2/list-family coordinator logic
- moving subsystem logic into `ExtendSqi.gf`
- fixing one function in a family while leaving the rest structurally inconsistent
- flattening rich Albanian categories to strings for convenience
- using coordinator-level hacks instead of subsystem fixes
- treating stale run logs as more authoritative than the current codedump

---

## 12. Reference set

This target document is aligned to the current Albanian source dump and the Albanian architecture docs, especially:

- future `ExtendSqi` structure
- override and inheritance policy
- module dependency map
- implementation pattern catalog
- high-priority watchlist
- forbidden patterns and anti-drift rules

---

## 13. Immediate next deliverable

The next document to create from this target is:

- `ALBANIAN_EXTENDSQI_OVERRIDE_MATRIX.md`

That matrix will enumerate every function currently wired through `ExtendSqi.gf`, identify its subsystem owner, and mark it as either inherited or locally overridden for this cycle.
