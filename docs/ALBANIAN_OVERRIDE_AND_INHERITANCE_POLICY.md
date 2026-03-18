# ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY

## Status
Authoritative working policy for Albanian GF maintenance and AI-assisted editing.

This document defines when Albanian concrete syntax code should inherit default RGL behavior, when it should override it, and how those overrides must be structured to avoid drift, category-shape errors, and lock-field damage.

---

## 1. Purpose

The Albanian codebase is highly interdependent. A local-looking change in one file can silently violate assumptions made in other modules. The goal of this policy is to keep Albanian implementations aligned with:

1. the abstract signature,
2. the default common implementation path,
3. the actual Albanian lincat shapes and morphology,
4. validated model-language patterns,
5. compile-time category integrity.

This policy is not optional for AI-assisted coding.

---

## 2. Source-precedence hierarchy

When deciding whether to inherit or override, use this order of authority.

### Level 1: abstract truth
Use the abstract signature as the non-negotiable contract.

Primary source:
- `gf-rgl/src/abstract/Extend.gf`
- other relevant abstract modules as needed

Rules:
- Never infer a result category from surface intuition.
- Never implement by function name alone.
- Always verify argument and return types first.

### Level 2: default implementation truth
If `ExtendFunctor` or the inherited grammar already provides a valid compositional implementation, that default is the first candidate.

Primary source:
- `gf-rgl/src/common/ExtendFunctor.gf`

Rules:
- Prefer the functor implementation if it already builds the target category compositionally.
- Override only if Albanian morphology, word order, category shape, or lexical policy requires a real divergence.
- If `ExtendFunctor` uses `variants {}`, the function is language-specific and must be designed from Albanian evidence or a validated model language.

### Level 3: Albanian category truth
If a function must be overridden, the implementation must preserve the exact Albanian category shape from Albanian core modules.

Primary sources:
- `albanian/CatSqi.gf`
- `albanian/ResSqi.gf`
- `albanian/NounSqi.gf`
- `albanian/AdjectiveSqi.gf`
- `albanian/AdverbSqi.gf`
- `albanian/ConjunctionSqi.gf`
- `albanian/QuestionSqi.gf`
- `albanian/RelativeSqi.gf`
- `albanian/StructuralSqi*.gf`
- `albanian/ExtraSqi.gf`

Rules:
- Preserve all fields required by the Albanian lincat, including hidden lock fields.
- Preserve agreement, case, species, number, and gender behavior.
- Never replace a rich category with `{s : Str}` unless the target category is actually string-like.

### Level 4: model-language guidance
Use model languages only after Levels 1–3.

Current ranking:
- Bulgarian: primary model for minimal structured reflexive NP systems.
- German: secondary model for richer subsystem design and explicit override discipline.

Rules:
- Copy subsystem structure, not surface strings.
- Do not copy fields blindly.
- Do not import a German/Bulgarian field inventory unless Albanian needs the same structure.

### Level 5: local policy decisions
If Albanian evidence is incomplete and model languages diverge, record the decision explicitly in the local documentation and decision log.

---

## 3. Core inheritance policy

### 3.1 Default stance
**Inherit by default. Override by proof.**

A function should remain inherited unless one of the following is true:

1. the default implementation is `variants {}`,
2. the default implementation yields the wrong Albanian surface semantics,
3. Albanian has a different category shape requirement,
4. Albanian morphology requires custom inflectional control,
5. Albanian clitic, agreement, or case policy cannot be expressed by the inherited path,
6. compile diagnostics show category-shape or lock-field mismatch caused by the current implementation.

### 3.2 Override burden of proof
Any override must answer all of these questions:

- What is the exact abstract signature?
- What does `ExtendFunctor` do, if anything?
- What Albanian lincat shape must be preserved?
- What Albanian module shows the same kind of category-preserving construction?
- Is there a model-language reference for this exact subsystem?
- Why is inheritance insufficient?

If any of those questions is unanswered, do not finalize the override.

---

## 4. Category-shape preservation policy

### 4.1 General rule
The output category controls the implementation strategy.

- If the target is `Adv`, return an adverbial record.
- If the target is `CN`, preserve the full noun table and gender.
- If the target is `AP`, preserve the full adjective table and lock fields.
- If the target is `NP`, preserve case table and agreement.
- If the target is `ListNP`, return the actual `ListNP` shape used by Albanian conjunction code.

### 4.2 Albanian shapes that matter immediately
The Albanian codedump establishes the following key shapes:

- `Prep = Compl`
- `Compl : Type = {s : Str}`
- `CN = Noun`
- `Noun : {s : Species => Case => Number => Str ; g : Gender}`
- `NP = {s : Case => Str ; a : Agr}`
- `AP` is species/case/gender/number-sensitive
- `ListNP = {init : Case => Str ; last : Case => Str ; a : Agr}`

Policy consequence:
- `Prep` may be safely string-like.
- `CN`, `AP`, `NP`, and `ListNP` are not string-like and must not be flattened in implementations that return them.

### 4.3 Lock-field rule
If a category reports `missing lock_AP`, `missing lock_CN`, `missing lock_NP`, or similar during compilation, the implementation is structurally suspect even if the surface string looks plausible.

Policy:
- treat lock-field warnings as evidence of a category-shape problem,
- not as a harmless cosmetic warning,
- unless a known core-module pattern shows the reduced shape is accepted and intentional.

---

## 5. ExtendFunctor-specific policy

### 5.1 If ExtendFunctor gives a real implementation
If `ExtendFunctor` already defines the function compositionally, inherit it unless Albanian demonstrably needs something else.

Examples of inherited-default style from the uploaded functor source:
- `CompBareCN cn = CompCN cn`
- `PrepCN prep cn = PrepNP prep (MassNP cn)`
- `ExistsNP = ExistNP`
- `ExistCN`, `ExistMassCN`, `ExistPluralCN` go through `ExistNP`
- `AdvIsNP adv np = PredVP np (UseComp (CompAdv adv))`
- `AdvIsNPAP adv np ap = PredVP np (AdvVP (UseComp (CompAP ap)) adv)`
- `PredAPVP ap vp = ImpersCl (UseComp (CompAP (SentAP ap (EmbedVP vp))))`

Policy:
- These defaults are the first-choice implementation path.
- A custom Albanian override must justify why this constructor chain is wrong for Albanian.

### 5.2 If ExtendFunctor uses `variants {}`
This means the function is intentionally language-specific.

Policy:
- Do not invent a flat string approximation and treat it as final.
- First inspect Albanian core modules for matching category construction patterns.
- Then inspect the same function family in Bulgarian and German.
- Record the chosen Albanian strategy explicitly.

Functions currently known from the uploaded functor source to be language-specific in this sense include:
- `ICompAP`
- `N2VPSlash`
- `AdjAsCN`
- `AdjAsNP`
- `ReflRNP`
- `ReflPron`
- `ReflPoss`
- `PredetRNP`
- `ConjRNP`
- `Base_*_RNP`
- `Cons_*_RNP`
- `CompoundN`
- `CompoundAP`
- and several other Extend-specific helpers

---

## 6. Albanian-specific override policy by subsystem

## 6.1 Preposition and adverb subsystem

### Inherit when possible
If the functor path already expresses Albanian behavior using `PrepNP`, `MassNP`, `CompAdv`, `CompAP`, or similar, prefer that.

### Override only for Albanian-specific surface policy
Albanian evidence shows:
- `Prep` is string-like,
- prepositions surface as `p.s`,
- material after prepositions is structurally accusative in the Albanian adverb layer.

Policy:
- Do not redesign `Prep` as a richer object unless Albanian core files change.
- Do not inspect `prep.s` dynamically.
- Use Albanian preposition behavior from `AdverbSqi.gf` and `ResSqi.gf`.

### Special rule for `PrepCN`
If `ExtendFunctor` gives a compositional path through `PrepNP prep (MassNP cn)`, that is the baseline.
Custom `PrepCN` is allowed only if Albanian requires a stricter bare-noun reading than the default mass path.

---

## 6.2 CN and noun-preserving subsystem

Albanian `CN` is not flat.

The approved CN-preserving pattern is visible in `NounSqi.gf`, e.g. `AdjCN` preserves:
- noun table shape,
- species/case/number dimensions,
- gender.

Policy:
- Any `CN -> CN` override must preserve `cn.g` and the full `cn.s` table.
- Do not construct a `CN` from a plain string unless the target semantics really are a lexicalized noun placeholder and the reduced shape is accepted by Albanian core code.
- Use core noun constructors when available.

---

## 6.3 AP and adjective-preserving subsystem

Albanian APs are not flat and carry full agreement-sensitive forms.

Policy:
- If the result is AP, preserve species/case/gender/number behavior.
- Prefer Albanian adjective constructors over string extraction.
- Treat `apStr`-style flattening as presentation-only, not as a final implementation strategy.
- Any AP override that produces lock warnings is not final.

This applies especially to functions like:
- `ICompAP`
- `AdvIsNPAP`
- `PredAPVP`
- `AdjAsCN`
- `AdjAsNP`
- `CompoundAP`
- `ReflA2RNP`

---

## 6.4 Existential subsystem

The functor already provides constructor-based existential paths.

Policy:
- `ExistS`, `ExistNPQS`, `ExistIPQS`, `ExistsNP`, `ExistCN`, `ExistMassCN`, and `ExistPluralCN` should inherit or mirror the constructor path unless Albanian clause mechanics force a different analysis.
- Do not build these as flat strings if the functor uses `UseCl`, `UseQCl`, `QuestCl`, `ExistNP`, or `ExistIP`.
- If a custom existential implementation is needed, it must still be clause/question-based, not surface-string based.

---

## 6.5 Reflexive NP (`RNP`) subsystem

This subsystem must be handled as a unit.

### Default structural stance
In the uploaded `ExtendFunctor.gf`,
- `RNP = Grammar.NP`
- `RNPList = Grammar.ListNP`

This is the default low-risk Albanian strategy.

### Policy
- Prefer inherited `NP/ListNP` structure unless Albanian proves it needs a custom `RNP` record.
- Do not mix a custom `RNP` record with inherited `NP/ListNP` list logic unless the entire subsystem is redesigned consistently.
- If Albanian keeps the inherited strategy, then all `RNP`-family functions must return genuine NP/ListNP-compatible values.

### Subsystem members that must be considered together
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

### Model-language policy for RNP
- Bulgarian is the primary structural reference for a compact explicit RNP subsystem.
- German is the secondary reference for richer subsystem behavior and design rationale.
- Do not copy German `rc/ext/isPron` or Bulgarian `gn/isPron` fields into Albanian automatically.

---

## 6.6 Card / numeral / determiner interaction

Albanian core files define `Card` as string-like, but `CN` is noun-shaped.

Policy:
- `CardCNCard` must return a `Card`-appropriate result, not a `CN` record.
- If a function combines cardinals and nouns but the abstract return type is not `CN`, do not use `cnConst` or any other noun constructor in the result position.
- Use noun strings only at the last mile if the target category itself is string-like.

---

## 7. Override triggers and non-triggers

## 7.1 Valid triggers for override
Override is justified when:
- `ExtendFunctor` gives `variants {}`,
- Albanian uses a different category shape than the default path assumes,
- Albanian morphological agreement or case choice differs materially,
- Albanian requires specific article/bare-form policy,
- Albanian uses clitic-sensitive placement not captured by the default,
- compile diagnostics show the inherited path is structurally wrong for Albanian.

## 7.2 Invalid triggers for override
Override is not justified merely because:
- a flat string implementation looks shorter,
- a model language has a custom version,
- a function “sounds language-specific”,
- a local hack removes one compile error but introduces lock warnings,
- the AI cannot immediately see the inherited path.

---

## 8. Forbidden patterns

The following patterns are forbidden unless explicitly documented as intentional exceptions.

### 8.1 Name-based implementation choice
Do not choose constructors or overloads by name similarity.
Always choose by exact signature and module context.

### 8.2 Rich category flattening
Do not use:
- `apStr`
- `cnStr`
- ad-hoc `{s = ...}`

as the final implementation of a function unless the target category is truly string-like.

### 8.3 Partial record fabrication
Do not create `lin AP`, `lin CN`, `lin NP`, `lin ListNP`, etc. with only the visible surface fields if Albanian core code or compiler warnings imply hidden fields must be preserved.

### 8.4 Isolated subsystem patching
Do not redesign only one member of:
- the existential family,
- the AP/CN conversion family,
- the RNP family,

without checking the rest of the family.

### 8.5 Blind model-language copying
Do not port German or Bulgarian field inventories or word order wholesale into Albanian.

---

## 9. Approved implementation patterns

### 9.1 Preserve-category pattern
If a function returns the same broad category family it consumes, preserve the full structural table.

Example policy:
- `CN -> CN` must preserve noun table and gender.
- `AP -> AP` must preserve adjective agreement structure.
- `NP -> NP` must preserve case table and agreement.

### 9.2 Constructor-chain pattern
If `ExtendFunctor` gives a constructor chain, use the same chain or an Albanian-equivalent chain.

Examples:
- `CompBareCN` via `CompCN`
- existentials via `ExistNP` / `ExistIP`
- adverbial predication via `PredVP` + `UseComp`

### 9.3 Surface-only pattern
A string helper is acceptable only when the result category is itself string-like, such as many Albanian `Comp`, `S`, `QS`, `RS`, or `Adv`-style local approximations.

### 9.4 List-shape pattern
If Albanian conjunction defines a list category such as `ListNP`, use that exact list shape and wrap values with the correct list lincat.

---

## 10. Model-language use policy

## 10.1 Bulgarian policy
Use Bulgarian first when:
- the subsystem is compact,
- the target problem is reflexive nominal structure,
- Albanian likely needs a minimal explicit subsystem.

Copy from Bulgarian:
- subsystem completeness,
- role of agreement metadata,
- relation between reflexive pronoun and possessive reflexive NP.

Do not copy blindly:
- Bulgarian case-role inventory,
- Bulgarian noun-form system,
- Bulgarian person/polarity internals.

## 10.2 German policy
Use German when:
- the subsystem is richly developed and fully overridden,
- you need examples of disciplined removal from `ExtendFunctor`,
- you need evidence that a whole family must be overridden together.

Copy from German:
- subsystem grouping,
- override discipline,
- structural reasoning.

Do not copy blindly:
- `rc`, `ext`, `isPron` fields,
- German agreement/controller logic,
- German preposition-case system.

---

## 11. AI coding protocol for inheritance/override decisions

For every candidate function:

1. Read the abstract signature.
2. Read the `ExtendFunctor` implementation or confirm it is `variants {}`.
3. Read the Albanian lincat definitions for all relevant argument and result categories.
4. Search Albanian core modules for an existing constructor pattern of the same target category.
5. If still unresolved, inspect Bulgarian first, then German, only for the same subsystem.
6. Decide:
   - inherit,
   - inherit with constructor mirroring,
   - or full Albanian override.
7. Check for lock-field warnings.
8. Record the decision if it affects subsystem policy.

No final override is accepted before step 7.

---

## 12. Decision criteria for “final” quality

An override is final only if all of the following hold:

- compiles without hard type errors,
- does not introduce category-shape mismatch,
- does not introduce new `missing lock_*` warnings,
- preserves the Albanian lincat contract,
- is defensible from abstract signature + default path + Albanian evidence,
- does not contradict the chosen subsystem strategy.

If any of those fail, the implementation remains provisional.

---

## 13. Current high-risk zones

Based on the uploaded Albanian code and compile history, the highest-risk override zones are:

1. AP/CN conversion and predicate functions:
   - `ICompAP`
   - `PredAPVP`
   - `AdjAsCN`
   - `AdjAsNP`
   - `CompoundAP`
   - `N2VPSlash`

2. Reflexive NP subsystem:
   - entire `RNP` family

3. Any function that currently relies on:
   - `apStr`
   - `cnStr`
   - `apConst`
   - `cnConst`

Policy for these zones:
- assume provisional until compile warnings are gone,
- require explicit evidence review before accepting AI-generated edits.

---

## 14. Minimal policy summary

If a future AI reads only one section, it should read this one.

- Inherit by default.
- Override only with evidence.
- Choose by exact signature, not by name.
- If `ExtendFunctor` has a real constructor chain, prefer it.
- If `ExtendFunctor` has `variants {}`, design from Albanian evidence first, model languages second.
- Preserve Albanian category shape exactly.
- Treat lock warnings as structural warnings.
- Handle subsystem functions together, especially `RNP`.
- Never finalize a flat string approximation for a rich category.

---

## 15. Evidence anchors for this policy

Primary Albanian evidence:
- `albanian/CatSqi.gf`
- `albanian/ResSqi.gf`
- `albanian/NounSqi.gf`
- `albanian/AdverbSqi.gf`
- `albanian/ConjunctionSqi.gf`
- `albanian/ExtendSqi.gf`

Primary default-behavior evidence:
- `gf-rgl/src/common/ExtendFunctor.gf`
- `gf-rgl/src/abstract/Extend.gf`

Primary model-language evidence:
- `gf-rgl/src/bulgarian/ExtendBul.gf`
- `gf-rgl/src/german/ExtendGer.gf`

Primary method evidence:
- `GFCodex/00_ROUTER.md`

