# ALBANIAN_FUTURE_EXTENDSQI_STRUCTURE

## Status of this document

This is the **governing architecture and implementation-control document** for the future `GF/lib/src/albanian/ExtendSqi.gf`.

It replaces a looser “structure note” with a document that is meant to be used during real repair and refactor work.

It serves four purposes at once:

1. define the architectural role of `ExtendSqi.gf`
2. define the target physical structure of the file
3. define the override policy for every subsystem
4. define the control rules that prevent drift back into unsafe AP/CN/CN→NP/Card reconstruction

It is **not** a chronological repair log.

---

## 1. Purpose

The future `ExtendSqi.gf` must be a **thin, controlled, subsystem-organized override over `ExtendFunctor`**.

Its job is to:

- inherit from `ExtendFunctor` by default
- override only where Albanian truly needs it
- keep rich-category boundaries explicit
- group overrides by subsystem
- make safe helpers and lossy helpers visibly distinct
- prevent recurrence of:
  - AP/CN drift
  - existential-family drift
  - ad hoc prep/focus drift
  - ad hoc RNP drift

---

## 2. Core architectural principle

`ExtendSqi.gf` is a **controlled override module**, not a second Albanian core grammar.

It is not the place to casually replace inherited composition with local string assembly when a valid inherited path already exists.

For every function, the decision order is:

1. abstract signature
2. inherited `ExtendFunctor` path
3. Albanian lincat/category shape
4. Albanian core-module constructor path
5. model-language structure only if still needed

This order is mandatory.

---

## 3. Module-level design rule

The future `ExtendSqi.gf` must be organized around:

- **category boundaries**
- **subsystems**
- **override strategy**

It must **not** be organized primarily around:

- raw abstract declaration order
- patch history
- one-off compiler errors
- convenience helper reuse

---

## 4. Albanian category policy

The file must explicitly respect the Albanian split between **rich** and **string-like** categories.

### 4.1 Rich categories

These must not be flattened unless the target category is genuinely shallow:

- `AP`
- `CN`
- `NP`
- `Pron`
- any category carrying agreement tables, case, gender, number, lock-bearing structure, or other nontrivial internal shape

### 4.2 String-like categories

These may be realized by shallow `{s : Str}` assembly only when that matches Albanian core behavior:

- many clause-level extension wrappers
- many `VPS` / `VPI` wrappers
- many utterance-level extension wrappers
- other categories whose Albanian lincat is already shallow

### 4.3 Non-negotiable rule

A rich category may be read as a surface string **only** when the target category is itself string-like.

A rich category may **not** be flattened and then rebuilt as another rich category unless that rebuild genuinely preserves the target category’s required structure.

---

## 5. Global override policy

### Rule 1: inherit first

If `ExtendFunctor` already gives a valid path, use it or mirror it structurally.

### Rule 2: no hidden flattening

Any helper that extracts a single surface form from a rich category is **lossy**. Lossy helpers are never neutral. They may only be used when the target is genuinely string-like.

### Rule 3: subsystem repair only

The following areas must be maintained as coherent subsystems:

- existential family
- AP/CN conversion family
- focus/preposition family
- VP/VPSlash bridge family
- RNP family

### Rule 4: warnings are architectural signals

`missing lock_AP` and `missing lock_CN` warnings are architectural failures, not cosmetic warnings.

### Rule 5: local overrides must be classified

Every nontrivial override must be labeled as one of:

- inherited unchanged
- mirrored from `ExtendFunctor`
- Albanian-specific constructor path
- temporary fallback

### Rule 6: no silent duplication of Albanian core behavior

If a helper is shared across `ExtendSqi`, `ExtraSqi`, `AdverbSqi`, `AdjectiveSqi`, or `NounSqi`, it probably belongs outside `ExtendSqi`.

---

## 6. Future file layout

The future `ExtendSqi.gf` should be laid out physically in this order.

### 6.1 Module policy header

At the top of the file, include a short policy comment.

Example:

```gf
-- POLICY:
-- 1. ExtendFunctor is the default source of structure.
-- 2. Rich Albanian categories (AP/CN/NP/Pron) must not be flattened for rich outputs.
-- 3. Surface extractors are allowed only for string-like targets.
-- 4. Existential, AP/CN, Prep/Focus, VP-bridge, and RNP are maintained as subsystems.
-- 5. Every nontrivial override must be classified: inherited / mirrored / Albanian-specific / temporary.
````

### 6.2 Grouped exclusion list

Do not keep one long flat exclusion list. Group exclusions by subsystem with comments.

### 6.3 `oper` section split by safety class

The `oper` section must be physically subdivided into:

1. neutral utilities
2. category-preserving helpers
3. lossy surface extractors
4. temporary compatibility helpers

### 6.4 `lincat` section

Keep local extension lincats together, but if a lincat choice exists only for a specific subsystem, place it near that subsystem.

### 6.5 `lin` section grouped by subsystem

Use this order:

1. thin scaffolding and list wrappers
2. existential subsystem
3. AP/CN conversion subsystem
4. focus/preposition subsystem
5. VP/VPSlash bridge subsystem
6. RNP subsystem
7. constants and lexical tail

---

## 7. Target file skeleton

This is the target file shape.

```gf
-- POLICY HEADER

concrete ExtendSqi of Extend =
  CatSqi ** ExtendFunctor -
  [
    -- scaffolding / list wrappers
    ...

    -- existential subsystem
    ...

    -- AP/CN conversion subsystem
    ...

    -- focus / preposition subsystem
    ...

    -- VP / VPSlash bridge subsystem
    ...

    -- RNP subsystem
    ...

    -- constants / lexical tail
    ...
  ]
  with
    (Grammar = GrammarSqi) **
  open Prelude, Predef, ResSqi, ParamX in {

  oper
    -- =========================================================
    -- 1. NEUTRAL UTILITIES
    -- =========================================================

    -- =========================================================
    -- 2. CATEGORY-PRESERVING HELPERS
    -- =========================================================

    -- =========================================================
    -- 3. LOSSY SURFACE EXTRACTORS
    -- allowed only for string-like targets
    -- =========================================================

    -- =========================================================
    -- 4. TEMPORARY COMPATIBILITY HELPERS
    -- must be removed or promoted later
    -- =========================================================

  lincat
    -- shared local extension lincats

  lin
    -- =========================================================
    -- SCAFFOLDING / LIST WRAPPERS
    -- Strategy: shallow wrappers only
    -- =========================================================

    -- =========================================================
    -- EXISTENTIAL SUBSYSTEM
    -- Strategy: mirror ExtendFunctor clause/question composition
    -- =========================================================

    -- =========================================================
    -- AP/CN CONVERSION SUBSYSTEM
    -- Strategy: preserve rich category boundaries
    -- =========================================================

    -- =========================================================
    -- FOCUS / PREPOSITION SUBSYSTEM
    -- Strategy: mirror Albanian preposition/government behavior
    -- =========================================================

    -- =========================================================
    -- VP / VPSlash BRIDGE SUBSYSTEM
    -- Strategy: keep verbal wrappers shallow, complements rich
    -- =========================================================

    -- =========================================================
    -- RNP SUBSYSTEM
    -- Strategy: one coherent representation across the family
    -- =========================================================

    -- =========================================================
    -- CONSTANTS / LEXICAL TAIL
    -- =========================================================
}
```

---

## 8. Function-to-subsystem map

This is the operational control map for `ExtendSqi`.

## 8.1 Scaffolding / list wrappers

These are expected to be shallow unless Albanian proves otherwise.

* `MkVPS`
* `ConjVPS`
* `PredVPS`
* `SQuestVPS`
* `QuestVPS`
* `RelVPS`
* `MkVPI`
* `ConjVPI`
* `ComplVPIVV`
* `MkVPS2`
* `ConjVPS2`
* `ComplVPS2`
* `ReflVPS2`
* `MkVPI2`
* `ConjVPI2`
* `ComplVPI2`
* `BaseVPS`
* `ConsVPS`
* `BaseVPI`
* `ConsVPI`
* `BaseVPS2`
* `ConsVPS2`
* `BaseVPI2`
* `ConsVPI2`
* `BaseComp`
* `ConsComp`
* `ConjComp`
* `BaseImp`
* `ConsImp`
* `ConjImp`

### Exit condition

* no shape drift introduced into rich categories
* wrappers remain visibly shallow

---

## 8.2 Existential subsystem

* `ExistS`
* `ExistNPQS`
* `ExistIPQS`
* `ExistCN`
* `ExistMassCN`
* `ExistPluralCN`
* `ExistsNP`

### Required strategy

* mirror inherited clause/question composition where possible
* do not hand-assemble existential clauses as raw strings unless target lincat is provably shallow
* CN-based existential entries must respect the NP/clause path, not bypass it arbitrarily

### Exit condition

* no existential-family record-shape mismatch
* no existential-family `lock_CN` warning
* no raw ad hoc existential assembly where inherited composition exists

---

## 8.3 AP/CN conversion subsystem

* `ICompAP`
* `CompBareCN`
* `CompIQuant`
* `PredAPVP`
* `AdjAsCN`
* `AdjAsNP`
* `CardCNCard`
* `CompoundAP`
* `N2VPSlash`
* any other AP/CN bridge function added later

### Required strategy

* preserve category boundaries
* use inherited/functor composition where valid
* do not rebuild rich outputs from one extracted surface cell
* return categories must be explicit and correct:

  * `AP` must stay AP-shaped
  * `CN` must stay CN-shaped
  * `NP` must stay NP-shaped
  * `Card` must not be rebuilt as `CN`

### Exit condition

* no `lock_AP`
* no `lock_CN`
* no lossy helper used to build a rich result
* no Card/CN category confusion

---

## 8.4 Focus / preposition subsystem

* `FocusObj`
* `FocusAdv`
* `FocusAdV`
* `FocusAP`
* `PrepCN`

### Required strategy

* mirror Albanian focus/preposition behavior
* keep prep/government decisions close together
* do not silently convert `CN` to something else without explicit policy
* `FocusAP` must respect whether the result is shallow or rich

### Exit condition

* no `lock_AP`
* no `lock_CN`
* no local prep/focus transition that contradicts Albanian core behavior

---

## 8.5 VP / VPSlash bridge subsystem

* `A2VPSlash`
* `N2VPSlash`
* `AdvIsNP`
* `AdvIsNPAP`
* `PresPartAP`
* `EmbedPresPart`
* `PastPartAP`
* `PastPartAgentAP`
* `PassVPSlash`
* `PassAgentVPSlash`
* `NominalizeVPSlashNP`
* `ProgrVPSlash`
* `PurposeVP`
* `WithoutVP`
* `ByVP`
* `InOrderToVP`

### Required strategy

* allow shallow verbal wrappers where Albanian is shallow
* keep rich complements rich
* do not let VP-bridge functions become another AP/CN flattening zone

### Exit condition

* no AP/CN lock warnings from VP-bridge functions
* complement shape remains explicit

---

## 8.6 RNP subsystem

* `ReflRNP`
* `ReflPron`
* `ReflPoss`
* `PredetRNP`
* `AdvRNP`
* `AdvRVP`
* `AdvRAP`
* `ReflA2RNP`
* `PossPronRNP`
* `ConjRNP`
* `Base_rr_RNP`
* `Base_nr_RNP`
* `Base_rn_RNP`
* `Cons_rr_RNP`
* `Cons_nr_RNP`
* `Cons_rn_RNP`

### Required strategy

* treat this as one subsystem
* use one coherent representation strategy across the family
* do not mix NP-style and ad hoc string/list behavior

### Exit condition

* one coherent representation across the family
* no subsystem-internal representation drift

---

## 8.7 Constants / lexical tail

* pronoun constants
* `UseDAP`
* `UseDAPMasc`
* `UseDAPFem`
* low-risk lexical constants
* simple wrapper constants

### Exit condition

* constants stay isolated from subsystem logic
* no helper drift leaks into constants section

---

## 9. Helper safety matrix

This section is mandatory during implementation.

## 9.1 Safe helper classes

These may be used freely if their types are correct.

### Neutral utilities

Examples:

* spacing helpers
* agreement constants
* present-tense/person extraction
* pronoun-table builders

### Category-preserving builders

Examples:

* builders that return `NP`, `CN`, `AP`, `Pron`, etc. with all required shape preserved
* wrappers that keep agreement/case/gender/number structure intact

### Rule

Safe helpers may build rich outputs.

---

## 9.2 Lossy helper classes

These are allowed **only** when the target category is string-like.

Examples:

* one-cell AP extractors
* one-cell CN extractors
* helpers that read nominative singular, accusative singular, or another single surface cell
* helpers that convert rich categories to plain `Str`

### Rule

Lossy helpers may not be used to construct:

* `AP`
* `CN`
* `NP`
* `Pron`
* `Card`
* any other rich category

---

## 9.3 Temporary compatibility helpers

These are allowed only if all three are true:

1. the inherited path is not currently usable
2. Albanian core does not yet provide the needed path cleanly
3. the helper is visibly labeled as temporary

### Rule

Temporary helpers must live in their own subsection and must have a removal or promotion plan.

---

## 9.4 Forbidden helper usage

Forbidden patterns:

* AP -> one surface form -> AP
* CN -> one surface form -> CN
* AP -> one surface form -> NP
* CN -> one surface form -> Card
* any lossy helper used inside a rich-category constructor without explicit proof that the target is shallow

---

## 10. Naming policy

Helper names must reveal their role.

## 10.1 Bad style

Avoid:

* `apStr`
* `cnStr`
* `SentAP`
* short helper names that do not reveal whether they preserve or lose structure

## 10.2 Good style

Prefer names like:

* `apSurfaceNomMascSg`
* `cnSurfaceAccSg`
* `npSurfaceNom`
* `mkBareNpFromCn`
* `mkPrepAdvFromNp`
* `mkCompatSentAp`
* `mkExistNpFromCn`

A name should reveal:

* whether it extracts surface
* whether it preserves structure
* what category it returns
* whether it is compatibility-only

---

## 11. Per-block documentation rule

Every subsystem block must start with a strategy note.

Examples:

```gf
-- EXISTENTIAL SUBSYSTEM
-- Strategy: mirror ExtendFunctor clause/question composition.
-- No raw {s = ...} existential assembly unless target lincat is proven shallow.
```

```gf
-- AP/CN CONVERSION SUBSYSTEM
-- Strategy: preserve rich category boundaries.
-- Surface extractors allowed only when target category is string-like.
```

```gf
-- FOCUS / PREPOSITION SUBSYSTEM
-- Strategy: mirror Albanian preposition/government behavior.
-- Do not invent local category transitions without explicit policy.
```

```gf
-- RNP SUBSYSTEM
-- Strategy: one coherent representation across all members.
-- Do not mix NP-style and ad hoc string/list behavior.
```

---

## 12. Cross-file boundary rules

This is the most important missing control rule in weaker versions of this document.

## 12.1 What belongs in `ExtendSqi`

Keep in `ExtendSqi` only:

* extension-specific overrides
* subsystem coordination logic
* functor mirroring where Albanian needs local control
* small local helpers that are used only by `ExtendSqi`

## 12.2 What should move out of `ExtendSqi`

Move out when a helper or behavior is shared with:

* `ExtraSqi`
* `AdverbSqi`
* `AdjectiveSqi`
* `NounSqi`
* any other Albanian module

Shared behavior belongs in a more stable Albanian-local helper layer or in the relevant core module.

## 12.3 Expected module ownership

### `ExtendSqi`

* extension-specific orchestration
* subsystem-level override logic

### `ExtraSqi`

* Albanian extension behavior that is not specific to `Extend`
* shared extension constructors if they are reused elsewhere

### `AdverbSqi`

* preposition/adverb behavior that is generally Albanian, not just `Extend`
* prep/government logic when shared

### `AdjectiveSqi`

* AP-preserving builders and adjective-local structure

### `NounSqi`

* CN/NP nominal builders and noun-local structure

### Rule

`ExtendSqi` must not become a second Albanian core.

---

## 13. Override matrix template

Every nontrivial overridden function should eventually be tracked in a small matrix with these columns:

* function
* subsystem
* return category
* inherited source-of-truth path
* Albanian local source-of-truth path
* strategy label
* current status
* notes

Example template:

| Function     | Subsystem   |      Return | Inherited source                 | Albanian source      | Strategy          | Status      | Notes                       |
| ------------ | ----------- | ----------: | -------------------------------- | -------------------- | ----------------- | ----------- | --------------------------- |
| `ExistS`     | Existential | `S/Cl` path | `ExtendFunctor` existential path | clause/question path | mirrored          | final       | no raw existential assembly |
| `AdjAsCN`    | AP/CN       |        `CN` | none directly                    | Albanian AP→CN path  | Albanian-specific | provisional | must preserve CN shape      |
| `CardCNCard` | AP/CN       |      `Card` | inherited card path if valid     | local card path      | Albanian-specific | provisional | never return CN             |

This matrix should live either in this document or in a paired implementation-control document.

---

## 14. Refactor target state

A successful future `ExtendSqi.gf` must have all of these properties:

* override families are visibly grouped
* inherited structure is obvious
* safe helpers and lossy helpers are separated
* rich/string category boundaries are obvious
* no ad hoc subsystem mixing
* repairs can be made family-by-family instead of line-by-line
* future audits can identify the active subsystem immediately
* shared Albanian behavior is not trapped unnecessarily inside `ExtendSqi`

---

## 15. Minimal maintenance workflow

When editing the future file:

1. identify the subsystem
2. identify the target return category
3. check the abstract signature
4. check `ExtendFunctor`
5. check Albanian lincat shape
6. check Albanian core constructor path
7. decide whether the function is inherited / mirrored / Albanian-specific / temporary
8. place the implementation inside the correct subsystem block
9. verify helper safety class
10. update the override matrix if strategy or status changed

---

## 16. Completion criteria

The refactor is complete only when all of the following are true:

* the file follows the target section order
* all nontrivial overrides are grouped by subsystem
* all nontrivial overrides are strategy-labeled
* lossy helpers are physically separated from safe helpers
* no rich-category output is built through hidden flattening
* subsystem exit conditions are satisfied
* shared helpers have been moved out where appropriate

---

## 17. Final design summary

The future `ExtendSqi.gf` should be a:

**thin, controlled, subsystem-organized override over `ExtendFunctor`**

with:

* explicit category-boundary discipline
* explicit safe vs lossy helper separation
* explicit subsystem blocks
* explicit override-strategy labels
* explicit cross-file ownership rules
* explicit subsystem exit criteria
* minimal local reinvention of inherited grammar paths

