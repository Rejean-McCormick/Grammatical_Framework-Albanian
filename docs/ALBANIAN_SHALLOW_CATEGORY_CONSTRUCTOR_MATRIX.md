# ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX

## Status
Authoritative operational matrix for **shallow / surface-oriented categories** in the Albanian GF grammar.

This document exists to prevent a recurring class of implementation drift:

- assuming that a category is safe to build with `lin Cat { ... }` merely because its documented shape looks shallow,
- assuming that a constructor pattern used in one module is automatically valid in another,
- assuming that helper or compatibility functions may be reused across nearby categories,
- and treating old comments or historical summaries as stronger evidence than the current codedump and current compiler behavior.

This document is complementary to:

- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`

It is **not** a generic lincat reference for all categories.
It is a targeted **constructor-availability matrix** for categories that are shallow enough to tempt unsafe AI drift.

---

## 1. Purpose

The Albanian grammar has an intentional split between:

- **rich categories** that must preserve structure (`CN`, `AP`, `NP`, `Pron`, list categories, etc.),
- and many **shallow categories** whose current Albanian use is effectively surface-oriented.

The existence of a shallow category does **not** settle how it should be built.

This document answers four practical questions for each shallow category:

1. What is the current Albanian shape?
2. Which module(s) currently own or commonly produce it?
3. What is the preferred constructor path?
4. Is direct `lin Cat { ... }` locally verified, merely possible in principle, or currently unsafe to infer?

The goal is to stop AI agents from making “looks shallow, so I’ll fabricate it” mistakes.

---

## 2. Authority and precedence

When this matrix is used during implementation work, the authority order is:

1. current compile result / current compiler error
2. current Albanian codedump
3. exact abstract signature
4. current Albanian lincat and current Albanian core constructor path
5. Albanian architecture and policy documents
6. model-language comparison
7. comments and historical notes last

This means:

- a shallow documented shape does **not** override a current compile failure,
- a local constructor pattern must be verified in the actual module context,
- and a stale comment must not be treated as evidence against the current code.

---

## 3. Scope

This document covers categories that are shallow, surface-used, or structurally tempting to flatten in the current Albanian codebase.

It focuses especially on:

- clause/discourse structural categories,
- adverbial and prepositional categories,
- utterance/result categories,
- comparative/adverbial structural categories,
- shallow determiner-like or digit-like helper categories,
- and other categories whose visible shape can mislead AI agents into unsafe constructor assumptions.

This document does **not** replace the rich-category reference for:

- `CN`
- `AP`
- `NP`
- `Pron`
- `ListNP`
- `ListCN`
- `ListAP`

Those remain governed primarily by `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`.

---

## 4. How to read this matrix

Each category entry records:

- **Current Albanian shape**  
  What the current codebase exposes or effectively uses.

- **Primary owners / producers**  
  The modules that currently define or most safely produce the category.

- **Preferred constructor path**  
  The path an AI should try first.

- **Direct local `lin` status**  
  Whether a local `lin Cat { ... }` pattern is:
  - **verified**,
  - **conditional**,
  - or **unsafe to infer**.

- **Common drift risk**  
  The most common wrong move.

- **Status**  
  One of:
  - `stable`
  - `conditional`
  - `warning`
  - `fallback-only`
  - `blocked`

### 4.1 Meaning of status labels

#### `stable`
The current codebase and module patterns support the documented constructor path, and it is reasonable to reuse it when the same category appears in the same kind of module context.

#### `conditional`
The category is shallow, but the correct constructor path still depends on module context, producer ownership, helper type, or export path.

#### `warning`
The category looks shallow, but a recent failure or known ambiguity shows that direct fabrication is risky.

#### `fallback-only`
A simplified constructor path may exist in the current codebase, but it should not be treated as the final design norm for all future implementations.

#### `blocked`
A tempting pattern is specifically known to be wrong or unsafe in the current cycle.

---

## 5. Global rules for shallow categories

Before using any shallow-category constructor, apply all of the following:

1. Confirm the exact abstract return category.
2. Confirm the current Albanian lincat shape.
3. Confirm which module currently owns or safely produces the category.
4. Confirm whether the category is being built by:
   - `ParadigmsSqi`,
   - `ResSqi`,
   - a core syntax module,
   - a structural submodule,
   - or a local verified `lin` pattern.
5. Confirm the constructor is valid in the current module context.
6. Confirm no safer producer path already exists.
7. Confirm that any helper used to reach the shallow category is exact-type compatible with its inputs.

### 5.1 Non-negotiable rule

A shallow category may be **surface-shaped** without making direct local construction **universally legal**.

That is the central distinction this document is here to preserve.

---

## 6. Categories not covered by this matrix

These categories are excluded because they are not shallow enough to be treated here as local surface-fabrication targets:

- `CN`
- `AP`
- `NP`
- `Pron`
- `ListNP`
- `ListCN`
- `ListAP`
- `Det` when used in rich nominal composition
- complement-bearing lexical categories such as `A2`, `N2`, `N3`, `V2`, `V3`

For those categories, use the rich-category rules and preserve the full Albanian shape.

---

# 7. Shallow-category constructor matrix

## 7.1 Clause / discourse structural categories

### `Subj`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in practical structural use |
| Typical meaning | subordinator / clause linker |
| Primary owners / producers | `ParadigmsSqi`, structural clause modules |
| Preferred constructor path | `P.mkSubj "..."` |
| Direct local `lin Subj { ... }` status | **conditional** |
| Why conditional | The category is shallow, but producer ownership and module context should still be preferred over arbitrary local construction |
| Common drift risk | Treating any raw string as if it were equivalent to the established structural producer path |
| Status | `conditional` |

Guidance:
- Prefer `ParadigmsSqi.mkSubj`.
- Use direct local `lin` only if the category is actually available and there is no stronger producer path in the owning structural module.
- When in a structural vocabulary resource, keep all subordinate particles grouped there rather than scattered across extension modules.

---

### `Conj`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in practical structural use |
| Typical meaning | binary conjunction |
| Primary owners / producers | `ParadigmsSqi`, structural clause/nominal modules, conjunction code |
| Preferred constructor path | `P.mkConj "..."` |
| Direct local `lin Conj { ... }` status | **conditional** |
| Why conditional | The category is shallow, but conjunction inventory is structurally owned and should stay coherent |
| Common drift risk | Replacing structural-owner constructors with ad hoc `lin` patterns in random modules |
| Status | `conditional` |

Guidance:
- Prefer `ParadigmsSqi.mkConj`.
- Keep `Conj` items in the structural layer unless the owning grammar module clearly exposes a better constructor path.
- If a conjunction participates in list behavior, do not confuse the conjunction record with the list categories it coordinates.

---

### `PConj`

| Field | Value |
|---|---|
| Current Albanian shape | surface-like discourse connector in current practical use |
| Typical meaning | postposed or discourse-level conjunction-like connector |
| Primary owners / producers | `ParadigmsSqi`, structural clause modules |
| Preferred constructor path | `P.mkPConj "..."` |
| Direct local `lin PConj { ... }` status | **conditional** |
| Why conditional | Shape is shallow, but the preferred constructor path is still paradigm-owned |
| Common drift risk | Assuming any `Conj`-like shape can be interchanged with `PConj` |
| Status | `conditional` |

Guidance:
- Prefer `ParadigmsSqi.mkPConj`.
- Do not infer that `PConj` and `Conj` are interchangeable.
- If used in structural exports, keep ownership in `StructuralSqiClause` or the relevant structural producer.

---

### `DConj`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` at current lincat/documentation level |
| Typical meaning | double/distributed conjunction-like item |
| Primary owners / producers | structural clause layer, local structural conventions if verified |
| Preferred constructor path | **verify against current module context first** |
| Direct local `lin DConj { ... }` status | **blocked unless locally verified** |
| Why blocked | Recent failure showed that the shallow shape does **not** guarantee that `lin DConj { ... }` is valid in every module |
| Common drift risk | Assuming shape alone licenses direct local construction |
| Status | `warning` |

Guidance:
- Treat `DConj` as the canonical anti-drift example.
- Do not use `lin DConj { ... }` unless:
  1. `DConj` is actually in scope,
  2. the current module accepts the pattern,
  3. and the owning structural layer really intends local construction there.
- If the category is shallow in the documentation but rejected in the module, the compiler wins.

---

### `CAdv`

| Field | Value |
|---|---|
| Current Albanian shape | local comparative-adverbial record behavior in current code |
| Typical meaning | comparative adverbial element with a head string and comparison particle |
| Primary owners / producers | structural clause modules, comparative/adverbial code |
| Preferred constructor path | local verified record construction when category is in scope |
| Direct local `lin CAdv { ... }` status | **verified in current structural practice** |
| Why verified | The current structural code uses local `lin CAdv {s = ... ; p = ...}` patterns successfully |
| Common drift risk | Treating `CAdv` as identical to ordinary `Adv` or losing the comparison particle field |
| Status | `stable` |

Guidance:
- If you build `CAdv`, preserve its full current local field pattern.
- Do not downgrade it to a plain single-string `Adv`.
- Reuse existing structural comparative patterns when possible.

---

### `Utt`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current practical use |
| Typical meaning | utterance/result surface output |
| Primary owners / producers | structural modules, phrase/sentence modules, extension scaffolding and focus/prep wrappers |
| Preferred constructor path | local `lin Utt {s = ...}` is acceptable **when the target really is Utt** |
| Direct local `lin Utt { ... }` status | **verified but still category-input-sensitive** |
| Why verified | Albanian uses shallow utterance outputs in multiple places |
| Common drift risk | Believing that because `Utt` is shallow, any upstream helper or category collapse is safe |
| Status | `stable` |

Guidance:
- `Utt` is shallow enough for local surface composition.
- But every **input** used to reach that `Utt` still must obey its own category rules.
- Example anti-drift rule: a surface-only `Utt` result does **not** make an `A -> Str` helper valid for an `AP` input.

---

### `Voc`

| Field | Value |
|---|---|
| Current Albanian shape | surface-use category in current practice |
| Typical meaning | vocative/result-like structural item |
| Primary owners / producers | `ParadigmsSqi`, structural clause/phrase modules |
| Preferred constructor path | `P.mkVoc "..."` |
| Direct local `lin Voc { ... }` status | **conditional** |
| Why conditional | Shape is surface-oriented, but producer ownership still matters |
| Common drift risk | Treating `Voc` as just another unrestricted shallow string result |
| Status | `conditional` |

Guidance:
- Prefer `ParadigmsSqi.mkVoc`.
- Use local direct construction only when the current module clearly owns the category and the pattern is already verified there.

---

### `Imp`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current documented practical use |
| Typical meaning | imperative/result-like clause output |
| Primary owners / producers | verbal/phrase/sentence modules |
| Preferred constructor path | use the established verbal/phrase producer path |
| Direct local `lin Imp { ... }` status | **conditional** |
| Why conditional | Shape is shallow, but imperative formation belongs to verbal grammar, not arbitrary local fabrication |
| Common drift risk | Treating imperative surface strings as if no verbal producer path mattered |
| Status | `conditional` |

Guidance:
- Use direct local fabrication only if the exact module already does so and the imperative semantics are genuinely local.
- Otherwise, prefer the verbal producer path.

---

## 7.2 Adverbial and prepositional categories

### `Prep`

| Field | Value |
|---|---|
| Current Albanian shape | `Compl`, practically surface-used as `{s : Str}` |
| Typical meaning | preposition/complement introducer |
| Primary owners / producers | `ResSqi`, `AdverbSqi`, structural clause modules |
| Preferred constructor path | `ResSqi.mkPrep "..."` for lexical structural items; `AdverbSqi.PrepNP` for composition |
| Direct local `lin Prep { ... }` status | **warning / producer-first** |
| Why warning | The current runtime behavior looks string-like, but the safe path is still through the producer modules; prepositions are a known drift zone |
| Common drift risk | Assuming rich preposition metadata exists, or inventing new case policy without checking the existing `PrepNP` path |
| Status | `warning` |

Guidance:
- Prefer `ResSqi.mkPrep` when defining a structural preposition.
- Prefer `AdverbSqi.PrepNP` when composing a preposition with an NP.
- Do not introspect or redesign preposition semantics from the surface string alone.
- If warnings or lock issues appear, treat that as evidence of a wrong constructor path even if the visible form looks trivial.

---

### `Adv`

| Field | Value |
|---|---|
| Current Albanian shape | producer-owned category, surface-used as `{s : Str}` in current modules |
| Typical meaning | ordinary adverbial |
| Primary owners / producers | `AdverbSqi`, `ParadigmsSqi`, structural modules |
| Preferred constructor path | producer modules first (`P.mkAdv`, `AdverbSqi` constructors, inherited adverb paths) |
| Direct local `lin Adv { ... }` status | **conditional** |
| Why conditional | Many current modules treat it stringwise, but producer modules should still be preferred |
| Common drift risk | Inventing a local record when a producer constructor already exists |
| Status | `conditional` |

Guidance:
- Prefer `ParadigmsSqi.mkAdv` or the local adverb producer path.
- Local `lin` is possible only if the category is truly in scope and the current module already supports that style.

---

### `AdV`

| Field | Value |
|---|---|
| Current Albanian shape | producer-owned, practically surface-used as `{s : Str}` |
| Typical meaning | adverbial modifier of verbal/clausal material |
| Primary owners / producers | `ParadigmsSqi`, adverbial/core syntax modules |
| Preferred constructor path | producer module or inherited constructor path |
| Direct local `lin AdV { ... }` status | **conditional** |
| Why conditional | Shallow in practical use, but still producer-first |
| Common drift risk | Treating `AdV` as identical to `Adv` without checking module usage |
| Status | `conditional` |

Guidance:
- Preserve the current practical distinction between `Adv` and `AdV` where the grammar uses it.
- Do not replace both with one shared local fabrication pattern unless the owning module already does so.

---

### `AdA`

| Field | Value |
|---|---|
| Current Albanian shape | surface-used as `{s : Str}` in current practical use |
| Typical meaning | adverbial modifier of adjectival/adverbial material |
| Primary owners / producers | `ParadigmsSqi`, adverbial/core syntax modules |
| Preferred constructor path | `P.mkAdA "..."` or inherited producer path |
| Direct local `lin AdA { ... }` status | **conditional** |
| Why conditional | Shape is shallow, but paradigm ownership is still the safer path |
| Common drift risk | Treating `AdA` as if it were always interchangeable with `AdV` or `Adv` |
| Status | `conditional` |

Guidance:
- Prefer `ParadigmsSqi.mkAdA`.
- Avoid category substitution based only on visible string behavior.

---

### `AdN`

| Field | Value |
|---|---|
| Current Albanian shape | surface-used as `{s : Str}` in current practical use |
| Typical meaning | adverbial/numeral-like modifier of nominal material |
| Primary owners / producers | `ParadigmsSqi`, structural/nominal modules |
| Preferred constructor path | `P.mkAdN "..."` or owner-module constructor |
| Direct local `lin AdN { ... }` status | **conditional** |
| Why conditional | Shape is shallow, but role in nominal structure still makes producer ownership relevant |
| Common drift risk | Treating `AdN` as another interchangeable generic adverb |
| Status | `conditional` |

Guidance:
- Prefer `ParadigmsSqi.mkAdN`.
- Check whether the surrounding nominal construction expects a specific owner-module path.

---

### `IAdv`

| Field | Value |
|---|---|
| Current Albanian shape | producer-owned, practically surface-used as `{s : Str}` |
| Typical meaning | interrogative adverbial |
| Primary owners / producers | `ParadigmsSqi`, question/structural modules |
| Preferred constructor path | `P.mkIAdv "..."` |
| Direct local `lin IAdv { ... }` status | **conditional** |
| Why conditional | Interrogative inventory should remain coherent through its producer modules |
| Common drift risk | Treating interrogative adverbials as generic `Adv` items |
| Status | `conditional` |

Guidance:
- Prefer `ParadigmsSqi.mkIAdv`.
- Keep interrogative inventory grouped with other question/structural items.

---

## 7.3 Clause/result categories commonly surface-flattened

### `Comp`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current practical use |
| Typical meaning | complement/result surface category |
| Primary owners / producers | sentence/adverbial/core syntax constructors, `ExtendFunctor` composition |
| Preferred constructor path | inherited/compositional path first (`CompCN`, `CompAP`, `CompAdv`, etc.) |
| Direct local `lin Comp { ... }` status | **conditional** |
| Why conditional | Shape is shallow, but Albanian already has constructor chains that should be preferred |
| Common drift risk | Over-preserving AP/CN shape when the target is already reduced, or inventing raw `Comp` when an inherited constructor exists |
| Status | `conditional` |

Guidance:
- If the target is `Comp`, use the most direct inherited or Albanian constructor chain.
- Do not reconstruct richer categories if the abstract result is already a reduced complement.

---

### `S`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in many current practical paths |
| Typical meaning | sentence surface result |
| Primary owners / producers | `SentenceSqi`, inherited sentence constructors |
| Preferred constructor path | core sentence constructors first |
| Direct local `lin S { ... }` status | **conditional** |
| Why conditional | Albanian often surfaces sentences as strings, but sentence formation still belongs to the core sentence layer |
| Common drift risk | Building local sentence strings in places where an existing sentence constructor path already exists |
| Status | `conditional` |

Guidance:
- Use local sentence surface construction only if the module genuinely owns the final sentence output.
- If a core sentence constructor exists, prefer it.

---

### `QS`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current practical use |
| Typical meaning | question sentence result |
| Primary owners / producers | `QuestionSqi`, inherited question constructors |
| Preferred constructor path | core/interrogative constructors first |
| Direct local `lin QS { ... }` status | **conditional** |
| Why conditional | Shape is shallow, but question formation belongs to question grammar |
| Common drift risk | Treating `QS` as just `S` with a question mark |
| Status | `conditional` |

Guidance:
- Prefer question constructors and question-owner modules.
- Use local surface-only `QS` construction only when that is already the verified module pattern.

---

### `RS`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current practical use |
| Typical meaning | relative sentence result |
| Primary owners / producers | `RelativeSqi`, inherited relative constructors |
| Preferred constructor path | relative producer path first |
| Direct local `lin RS { ... }` status | **conditional** |
| Why conditional | Relative-sentence shaping belongs to relative grammar even if the end result is shallow |
| Common drift risk | Treating relative outputs as ordinary sentence strings |
| Status | `conditional` |

Guidance:
- Use the relative producer path first.
- Do not bypass relative grammar just because the final result is surface-like.

---

### `Cl`

| Field | Value |
|---|---|
| Current Albanian shape | current practical use is surface-like |
| Typical meaning | clause result |
| Primary owners / producers | sentence/clause grammar |
| Preferred constructor path | inherited/core clause constructors |
| Direct local `lin Cl { ... }` status | **conditional** |
| Why conditional | Clauses are surface-used, but clause formation still belongs to the core sentence layer |
| Common drift risk | Reconstructing clause output locally where a core clause path already exists |
| Status | `conditional` |

Guidance:
- Prefer the clause producer path.
- Local `lin Cl` is not a free license for any module.

---

### `QCl`

| Field | Value |
|---|---|
| Current Albanian shape | current practical use is surface-like |
| Typical meaning | interrogative clause result |
| Primary owners / producers | question/clause grammar |
| Preferred constructor path | inherited/core question-clause constructors |
| Direct local `lin QCl { ... }` status | **conditional** |
| Why conditional | Same reason as `QS`, but at clause layer |
| Common drift risk | Treating it as generic clause string assembly |
| Status | `conditional` |

Guidance:
- Prefer the question/clause producer path.
- Keep interrogative clause logic in the question layer where possible.

---

### `RCl`

| Field | Value |
|---|---|
| Current Albanian shape | current practical use is surface-like |
| Typical meaning | relative clause result |
| Primary owners / producers | `RelativeSqi`, clause grammar |
| Preferred constructor path | relative/clause producer path |
| Direct local `lin RCl { ... }` status | **conditional** |
| Why conditional | Relative-clause semantics remain relative-grammar-owned |
| Common drift risk | Treating `RCl` as a generic clause string |
| Status | `conditional` |

Guidance:
- Use relative-clause constructors first.
- Avoid local flat reconstruction unless the verified local module already owns the result.

---

### `SSlash` / `ClSlash`

| Field | Value |
|---|---|
| Current Albanian shape | surface-used as `{s : Str}` in current practice |
| Typical meaning | slash/gapped clause/sentence outputs |
| Primary owners / producers | question/relative/scaffolding structures |
| Preferred constructor path | owner-module path first |
| Direct local `lin` status | **conditional** |
| Why conditional | Shallow output does not remove the need to preserve the right ownership path |
| Common drift risk | Treating slash categories as arbitrary strings without respecting the owning subsystem |
| Status | `conditional` |

Guidance:
- Use the owner-module constructor path first.
- Only use local surface composition where the current module already does so and the result does not need richer structure.

---

### `IComp`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current practical use |
| Typical meaning | interrogative complement |
| Primary owners / producers | question/complement constructors |
| Preferred constructor path | inherited/core interrogative complement path |
| Direct local `lin IComp { ... }` status | **conditional** |
| Why conditional | Shallow target, but still better served by existing interrogative constructor chains |
| Common drift risk | Treating it as a free local string category while bypassing question grammar |
| Status | `conditional` |

Guidance:
- Do not construct `IComp` locally just because it is shallow if a current interrogative-complement path already exists.

---

### `IP`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current practical use |
| Typical meaning | interrogative phrase |
| Primary owners / producers | question grammar, interrogative inventories |
| Preferred constructor path | producer modules first |
| Direct local `lin IP { ... }` status | **conditional** |
| Why conditional | Shape is shallow, but interrogative ownership still matters |
| Common drift risk | Treating all interrogative phrases as local plain strings |
| Status | `conditional` |

Guidance:
- Prefer question-owner constructors or structural interrogative inventories.
- If using a local string, make sure the module actually owns `IP` production there.

---

### `IDet`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current practical use |
| Typical meaning | interrogative determiner |
| Primary owners / producers | question grammar, structural interrogative inventory |
| Preferred constructor path | question/structural producer path |
| Direct local `lin IDet { ... }` status | **conditional** |
| Why conditional | Inventory ownership still matters |
| Common drift risk | Treating `IDet` as just any `Det` surface string |
| Status | `conditional` |

Guidance:
- Keep interrogative determiner inventory grouped in the question/structural layer.

---

### `IQuant`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current practical use |
| Typical meaning | interrogative quantifier |
| Primary owners / producers | question grammar, structural inventory |
| Preferred constructor path | question/structural producer path |
| Direct local `lin IQuant { ... }` status | **conditional** |
| Why conditional | Same as `IDet` and `IP` |
| Common drift risk | Treating interrogative quantifiers as generic quantifier strings |
| Status | `conditional` |

Guidance:
- Prefer owner-module or structural interrogative constructors.

---

### `RP`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current practical use |
| Typical meaning | relative pronoun/result-like relative connector |
| Primary owners / producers | `RelativeSqi`, structural relative inventory |
| Preferred constructor path | relative producer path |
| Direct local `lin RP { ... }` status | **conditional** |
| Why conditional | Relative inventory must remain coherent |
| Common drift risk | Treating `RP` as just another pronoun or just another string |
| Status | `conditional` |

Guidance:
- Use relative-owner constructors first.
- Do not confuse `RP` with ordinary `Pron`.

---

## 7.4 Determiner-like / digit-like shallow helper categories

### `DAP`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` |
| Typical meaning | digit/article-like helper category in current snapshot |
| Primary owners / producers | conjunction/digit/numeral support, lexical compatibility wrappers |
| Preferred constructor path | exact-type-compatible helpers only |
| Direct local `lin DAP { ... }` status | **conditional** |
| Why conditional | The category is shallow, but old comments and family resemblance create high drift risk |
| Common drift risk | Reusing NP/Det helpers or trusting stale comments about implicit default insertion |
| Status | `warning` |

Guidance:
- Treat current `DAP` as explicitly string-shaped in the current codebase.
- Do not use arbitrary NP/Det helpers on it.
- If bridging from `DAP` to `NP`, label the path as compatibility-based unless Albanian core code explicitly canonicalizes it.

---

### `Numeral`

| Field | Value |
|---|---|
| Current Albanian shape | `{s : Str}` in current practical use |
| Typical meaning | numeral surface category |
| Primary owners / producers | `NumeralSqi`, numeral grammar |
| Preferred constructor path | numeral producer path first |
| Direct local `lin Numeral { ... }` status | **conditional** |
| Why conditional | Shape is shallow, but numeral system behavior still belongs to numeral grammar |
| Common drift risk | Treating numeral strings as free substitutes for more specific numeral-support categories |
| Status | `conditional` |

Guidance:
- Use numeral producer paths first.
- Avoid mixing numeral strings with richer nominal return categories.

---

### `Digits`

| Field | Value |
|---|---|
| Current Albanian shape | surface-oriented helper category in numeral support |
| Typical meaning | digit sequence surface category |
| Primary owners / producers | numeral support / numeral grammar |
| Preferred constructor path | numeral-support producer path |
| Direct local `lin Digits { ... }` status | **conditional** |
| Why conditional | Shallow, but still system-owned by numeral support code |
| Common drift risk | Treating `Digits` and `DAP` as freely interchangeable |
| Status | `conditional` |

Guidance:
- Keep digit-support items in numeral-support ownership.
- Do not infer that because both are surface-like they are the same category.

---

# 8. Category clusters with special anti-drift notes

## 8.1 `DConj`, `CAdv`, `Utt` are not equivalent “simple shallow categories”

These are all surface-oriented enough to tempt local record fabrication, but their status is different:

- `Utt` is broadly shallow and commonly used as a final local result.
- `CAdv` has a verified local comparative-adverbial record pattern.
- `DConj` is the warning case: shallow documented shape, but direct local construction is **not** universally licensed.

Never collapse these three into one general “if shallow, just `lin` it” rule.

---

## 8.2 `Prep` is shallow in runtime behavior, but still producer-owned

`Prep` is one of the most misleading categories in the current Albanian snapshot.

It looks shallow enough to invite arbitrary direct fabrication.
That is the wrong instinct.

The safe rule is:

- define lexical structural prepositions through `ResSqi.mkPrep`,
- compose them through `AdverbSqi.PrepNP`,
- do not invent a new local preposition policy from surface strings alone.

---

## 8.3 `DAP` is shallow, but comment drift is especially dangerous there

Some older explanations in the codebase historically described `DAP` as if it were not explicitly present and had to be defaulted.
That is not reliable evidence now.

Current code and current category definitions win over old comments.

Therefore:
- treat `DAP` as current explicit shallow category truth,
- but still do not reuse arbitrary NP/Det helpers on it,
- and do not infer canonicality from fallback compatibility wrappers.

---

# 9. Fast lookup rules for AI systems

If the target category is:

- `Utt` → local shallow surface composition is often okay, but input-category discipline still applies
- `CAdv` → preserve the comparative structure, not just the visible string
- `DConj` → stop and verify module-context constructor availability before doing anything
- `Prep` → prefer `mkPrep` / `PrepNP`
- `Subj`, `Conj`, `PConj`, `Voc` → prefer paradigm constructors
- `Adv`, `AdV`, `AdA`, `AdN`, `IAdv` → prefer producer modules first, local `lin` only if already verified in that module
- `Comp`, `S`, `QS`, `RS`, `Cl`, `QCl`, `RCl`, `SSlash`, `ClSlash`, `IComp`, `IP`, `IDet`, `IQuant`, `RP` → treat as shallow result categories, but still prefer owner-module constructor paths
- `DAP`, `Numeral`, `Digits` → keep numeral/support ownership explicit; do not borrow helpers by family resemblance

---

# 10. What this matrix forbids

This matrix forbids:

- inferring local constructor legality from lincat shape alone,
- reusing helpers across nearby categories,
- treating `DConj` as a generic string-safe `lin` category without verification,
- treating `Prep` as a free local string category instead of a producer-owned item,
- treating `DAP` comments as stronger evidence than current category definitions,
- treating all shallow categories as equally safe for direct local construction,
- treating “surface-only” as synonymous with “constructor-verified”.

---

# 11. Acceptance criteria for shallow-category implementations

A shallow-category implementation is acceptable only if:

1. the exact abstract result category is correct,
2. the current Albanian category shape is respected,
3. the constructor path is valid in the actual module context,
4. helper reuse is exact-type compatible,
5. no stronger producer path has been ignored,
6. no current compile warning/failure contradicts the chosen pattern,
7. the implementation does not introduce downstream breakage,
8. any fallback/compatibility use is explicitly labeled.

If any of those fail, the implementation remains provisional.

---

# 12. Maintenance obligations

Whenever one of the following changes:

- current category shape,
- current constructor availability,
- helper legality,
- structural ownership,
- or known fragile shallow-category behavior,

update all of:

- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`
- this matrix

This matrix is only useful if it stays synchronized with the live codebase.

---

# 13. Summary

The Albanian grammar contains many categories that are shallow in current practical use, but shallow shape is not the same as constructor freedom.

This matrix therefore divides shallow categories into:

- paradigm-owned,
- producer-owned,
- locally verified,
- warning-state,
- and blocked/unverified categories.

The central rule is simple:

**A shallow category may be surface-oriented without being locally safe to fabricate.**

That distinction is the main thing this document is meant to preserve.