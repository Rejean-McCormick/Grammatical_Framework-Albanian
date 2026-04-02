# ALBANIAN_OVERRIDE_AND_INHERITANCE_POLICY

## Status

Authoritative working policy for Albanian GF maintenance and AI-assisted editing.

This document defines when Albanian concrete syntax code should inherit default RGL behavior, when it should override it, and how those overrides must be structured to avoid:

- category-shape drift,
- constructor-context mistakes,
- stale-comment confusion,
- helper-type misuse,
- family incoherence,
- shallow/rich category confusion,
- and lock-field damage.

This document is intentionally conservative. It is written to prevent plausible-looking but structurally wrong edits.

It is a policy document, not a chronological repair log.

---

## 1. Purpose

The Albanian codebase is highly interdependent. A local-looking change in one file can silently violate assumptions made in other modules. The goal of this policy is to keep Albanian implementations aligned with:

1. the abstract signature,
2. the current Albanian codedump and accepted constructor paths,
3. the default common implementation path,
4. the actual Albanian lincat shapes and morphology,
5. validated model-language patterns,
6. compile-time category integrity.

This policy is not optional for AI-assisted coding.

A successful Albanian override is not merely one that “looks plausible” or even one that “compiles once”. A successful override is one that:

- preserves the right category shape,
- uses a constructor path that is valid in the current module context,
- uses only helpers whose signatures match the actual categories involved,
- does not rely on stale comments or guessed helper reuse,
- remains coherent with the chosen subsystem strategy,
- and survives downstream compilation without introducing new structural warnings.

---

## 2. Scope

This policy applies to:

- `GF/lib/src/albanian/*`
- root-level Albanian wrappers and entry points where relevant (`SyntaxSqi`, `ConstructorsSqi`, `TrySqi`, `SymbolicSqi`)
- Albanian extension work around `ExtendSqi`
- architecture-sensitive structural resources such as `StructuralSqi*`
- maintenance tasks where AI systems must decide between:
  - inheriting the existing RGL/default path,
  - mirroring the inherited constructor path locally,
  - or introducing a true Albanian-specific override

This policy is especially binding for:

- `ExtendSqi.gf`
- `ExtendSqi` companion modules
- modules that return rich categories (`CN`, `AP`, `NP`, `Pron`, list categories)
- structural/functional modules where shallow shape can mislead constructor choice
- modules where live code, documentation, and comments may disagree

---

## 3. Source-precedence hierarchy

When deciding whether to inherit or override, use this order of authority.

### Level 1: abstract truth

Use the abstract signature as the non-negotiable contract.

Primary sources:
- `gf-rgl/src/abstract/Extend.gf`
- other relevant abstract modules as needed

Rules:
- Never infer a result category from surface intuition.
- Never implement by function name alone.
- Always verify argument and return types first.
- If the abstract type says a function returns `AP`, the problem is “how to build a valid Albanian `AP`”, not “what surface string seems reasonable”.
- If the abstract type says a function returns `NP`, case and agreement remain part of the problem even if the visible surface form looks trivial.

### Level 2: current Albanian implementation truth

Use the current Albanian codedump and current compile reality as the first concrete implementation evidence.

Primary sources:
- current `albanian/*.gf` codedump
- current Albanian audit logs and artifact indexes
- current warnings and compile failures

Rules:
- Treat the current codedump as the source of truth for what Albanian currently exposes and accepts.
- If documentation and current compile reality disagree, investigate the current code and current compiler output first.
- A documented category shape does **not** by itself prove that `lin Cat { ... }` is valid in the current module context.
- A constructor-looking pattern in one module does **not** automatically transfer to another module.
- A helper name that looks familiar is not evidence that its type matches the current use site.
- A compile failure is stronger evidence than an attractive guessed pattern.
- Current compileable source is stronger evidence than stale explanatory comments.
- Current warnings are evidence, not noise.

### Level 3: default implementation truth

If `ExtendFunctor` or the inherited grammar already provides a valid compositional implementation, that default is the first override candidate.

Primary source:
- `gf-rgl/src/common/ExtendFunctor.gf`

Rules:
- Prefer the functor implementation if it already builds the target category compositionally.
- Override only if Albanian morphology, word order, category shape, lexical policy, or compile evidence requires a real divergence.
- If `ExtendFunctor` uses `variants {}`, the function is language-specific and must be designed from Albanian evidence or a validated model language.
- If `ExtendFunctor` uses a clean constructor chain, that chain is the baseline explanation burden: a custom Albanian override must explain why that chain is insufficient.

### Level 4: Albanian category and constructor truth

If a function must be overridden, the implementation must preserve the exact Albanian category shape and must use a constructor path that is valid in the current Albanian module context.

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
- Distinguish between:
  - category shape,
  - resource-internal implementation type,
  - exported lincat,
  - module-local constructor availability,
  - and helper compatibility.
- Do not assume that a category documented as surface-shaped can always be built with `lin Cat { ... }` in every resource.
- Verify helper input types exactly.
- A helper for `A` is not automatically valid for `AP`.
- A helper for `N` is not automatically valid for `CN`.
- A helper for one list category is not automatically valid for another.
- A category that is shallow in the lincat summary may still require a specific constructor path in practice.
- Constructor availability must be checked after opens/imports and local aliases are resolved, not just after reading the category summary.

### Level 5: support-document truth

The current documentation suite includes operational support documents that refine how Levels 2–4 should be applied.

These include:
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`

Rules:
- Use the helper registry to confirm exact helper type, maturity, and allowed use.
- Use the shallow-category constructor matrix to confirm whether a shallow-looking category is actually constructible in the current module context.
- Use the symbol status ledger to distinguish stable patterns from warning-state or provisional ones.
- Use the stale comment tracker to avoid inheriting historical or misleading commentary into live code decisions.
- Use the module extraction coverage file to know whether a module is already documented deeply enough or whether direct source re-audit is still required.

These support documents refine implementation discipline. They do not override abstract signatures or current compiler reality.

### Level 6: model-language guidance

Use model languages only after Levels 1–5.

Current ranking:
- Bulgarian: primary model for minimal structured reflexive NP systems.
- German: secondary model for richer subsystem design and explicit override discipline.

Rules:
- Copy subsystem structure, not surface strings.
- Do not copy fields blindly.
- Do not import a German/Bulgarian field inventory unless Albanian needs the same structure.
- Use model languages to understand how a whole subsystem is grouped and justified, not as proof that Albanian should expose the same internal fields.

### Level 7: local policy decisions

If Albanian evidence is incomplete and model languages diverge, record the decision explicitly in the local documentation and decision log.

Rules:
- Local policy may resolve ambiguity, but it may not contradict Levels 1–5 without explicit evidence.
- Temporary or fallback decisions must be labeled as such.
- Every local policy decision must name the affected files, categories, and reason for non-final status.
- No “quiet policy” should survive only in chat or commit intuition.

---

## 4. Core inheritance policy

### 4.1 Default stance

**Inherit by default. Override by proof.**

A function should remain inherited unless one or more of the following is true:

1. the default implementation is `variants {}`,
2. the default implementation yields the wrong Albanian surface semantics,
3. Albanian has a different category shape requirement,
4. Albanian morphology requires custom inflectional control,
5. Albanian clitic, agreement, or case policy cannot be expressed by the inherited path,
6. compile diagnostics show category-shape, constructor-context, helper-type, or lock-field mismatch caused by the current implementation,
7. subsystem coherence requires a coordinated local design.

### 4.2 Override burden of proof

Any override must answer all of these questions:

- What is the exact abstract signature?
- What does `ExtendFunctor` do, if anything?
- What Albanian lincat shape must be preserved?
- What Albanian module shows the same kind of category-preserving construction?
- Is the proposed constructor pattern actually valid in this module context?
- Do the proposed helpers match the exact input/output categories?
- What does the helper registry say about the proposed helpers?
- What does the shallow-category constructor matrix say if the target looks shallow?
- What is the current status of the involved symbols in the status ledger?
- Is there a model-language reference for this exact subsystem?
- Why is inheritance insufficient?

If any of those questions is unanswered, do not finalize the override.

### 4.3 Architecture truth vs implementation truth

Architecture and implementation must not be confused.

Architecture truth covers:
- subsystem boundaries,
- coordinator thinness,
- inheritance policy by family,
- staging order,
- structural ownership.

Implementation truth covers:
- exact constructors,
- exact helper legality,
- exact local lincat behavior,
- exact compile acceptance,
- current warnings and current failures.

Policy:
- architecture docs win for subsystem structure,
- current code and compiler win for concrete implementation details.

This distinction is mandatory when a local code pattern looks plausible but violates the live module context.

---

## 5. Category-shape preservation policy

### 5.1 General rule

The output category controls the implementation strategy.

- If the target is `Adv`, return an adverbial record.
- If the target is `CN`, preserve the full noun table and gender.
- If the target is `AP`, preserve the full adjective table and lock fields.
- If the target is `NP`, preserve case table and agreement.
- If the target is `ListNP`, return the actual `ListNP` shape used by Albanian conjunction code.

### 5.2 Albanian shapes that matter immediately

The Albanian codedump establishes the following key shapes:

- `CN = Noun`
- `Noun : {s : Species => Case => Number => Str ; g : Gender}`
- `NP = {s : Case => Str ; a : Agr}`
- `AP` is species/case/gender/number-sensitive
- `ListNP = {init : Case => Str ; last : Case => Str ; a : Agr}`

Policy consequence:
- `CN`, `AP`, `NP`, and `ListNP` are not string-like and must not be flattened in implementations that return them.

### 5.3 Surface-looking categories are still context-sensitive

Some Albanian categories may look surface-like in documentation or in simplified lincat summaries.

Policy:
- Do not infer from a simplified shape alone that any ad-hoc `lin Cat {s = ...}` is safe.
- Verify whether the category is being built through:
  - a true exported lincat,
  - a resource alias,
  - a constructor from `ResSqi`,
  - a paradigm function,
  - a helper with a verified exact type,
  - or a module-local representation.
- Treat compile warnings and compile failures as evidence that the category may be structurally richer or context-sensitive in practice than it first appears.
- Treat shallow shape and constructor availability as two separate questions.

### 5.4 Constructor-availability rule

A category description is not the same thing as a constructor license.

Policy:
- Before using `lin Cat { ... }`, verify that:
  1. `Cat` is actually available in the current module context,
  2. the proposed fields match the actual accepted representation,
  3. the current compiler accepts the pattern in this module,
  4. there is no nearby Albanian constructor path that should be preferred instead,
  5. the pattern is not merely borrowed from another module with a different scope/open structure.
- If any of those are unknown, do not finalize the constructor pattern.
- If the category is only known to be shallow from documentation, that is still not enough.
- If a local constructor path and a core-module constructor path both exist, prefer the core-module path unless there is explicit evidence not to.

### 5.5 Exact-helper-type rule

Helper reuse is approved only under exact category compatibility.

Policy:
- Reuse a helper only when its input category matches the current function input category exactly.
- Reuse a helper only when its output interpretation is also appropriate for the current target category.
- Near-match reuse is not enough:
  - `A` helper ≠ `AP` helper
  - `N` helper ≠ `CN` helper
  - `NP` helper ≠ `ListNP` helper
  - `Pron` helper ≠ general `NP` helper
- If a helper is presentation-only, do not upgrade it into a final implementation helper for a richer category without explicit evidence.
- If a helper is marked compatibility-based or fallback-based, do not silently reuse it in a richer subsystem and call the result final.

### 5.6 Lock-field rule

If a category reports `missing lock_AP`, `missing lock_CN`, `missing lock_NP`, `missing lock_Prep`, or similar during compilation, the implementation is structurally suspect even if the surface string looks plausible.

Policy:
- treat lock-field warnings as evidence of a category-shape or constructor-path problem,
- not as a harmless cosmetic warning,
- unless a known core-module pattern shows the reduced shape is accepted and intentional.
- do not accept “compiles with warnings” as final quality for a category-preserving override.

### 5.7 Comment-authority rule

Comments are explanatory, not authoritative.

Policy:
- comments may summarize older states of the code,
- comments may lag behind current category definitions,
- comments may describe a fallback or historical workaround that is no longer current.

If comments, current code, and compiler behavior disagree:
1. current compiler behavior wins,
2. current code wins next,
3. comments come last.

Do not bend code to match a stale comment.

When comments are known to be stale, the stale comment tracker should record them explicitly until they are repaired or deleted.

---

## 6. ExtendFunctor-specific policy

### 6.1 If ExtendFunctor gives a real implementation

If `ExtendFunctor` already defines the function compositionally, inherit it unless Albanian demonstrably needs something else.

Examples of inherited-default style:
- use `CompAP` instead of flattening AP yourself
- use `CompCN` instead of flattening CN yourself
- use `PrepNP` with the appropriate NP constructor instead of inventing a parallel prepositional encoding
- use `ExistNP`, `ExistIP`, `UseCl`, `UseQCl`, `QuestCl`, `PredVP`, `UseComp`, `CompAdv`, `AdvVP` when those match the abstract signature

Policy:
- These defaults are the first-choice implementation path.
- A custom Albanian override must justify why this constructor chain is wrong for Albanian.
- If the default path already preserves the right category family, prefer it over an ad-hoc local reimplementation.
- If the default path already delegates to Albanian core constructors, treat that as a strong reason not to override.

### 6.2 If ExtendFunctor uses `variants {}`

This means the function is intentionally language-specific.

Policy:
- Do not invent a flat string approximation and treat it as final.
- First inspect Albanian core modules for matching category construction patterns.
- Then inspect the same function family in Bulgarian and German.
- Record the chosen Albanian strategy explicitly.
- If the result is a rich category, the burden to preserve shape remains exactly the same.

### 6.3 If ExtendFunctor and live Albanian code disagree

Sometimes the functor path is elegant, but the current Albanian codebase already exposes a different accepted local constructor route.

Policy:
- do not ignore the functor,
- but do not ignore compile reality either.
- inspect whether Albanian has intentionally diverged,
- inspect whether the divergence is accepted and documented,
- and only then decide whether to inherit, mirror, or redesign.

---

## 7. Albanian-specific override policy by subsystem

### 7.1 Preposition and adverb subsystem

#### Inherit when possible
If the functor path already expresses Albanian behavior using `PrepNP`, `MassNP`, `CompAdv`, `CompAP`, or similar, prefer that.

#### Override only for Albanian-specific surface policy
Albanian evidence shows:
- prepositions often look surface-simple in the current grammar snapshot,
- preposition behavior is mediated through Albanian adverb/preposition code,
- material after prepositions is structurally accusative in the Albanian adverb layer.

Policy:
- Do not redesign `Prep` from superficial intuition alone.
- Do not infer that prepositions are “just `{s : Str}`” for implementation purposes without checking current warnings and current constructor paths.
- Do not inspect `prep.s` dynamically as if that alone defined preposition behavior.
- Use Albanian preposition behavior from `AdverbSqi.gf` and `ResSqi.gf`.
- If compile warnings show `lock_Prep` trouble, treat that as evidence that the constructor path needs correction even if the visible form still looks string-like.
- Treat prepositions as a drift-prone area because they often look simpler than the runtime behavior they participate in.

#### Special rule for `PrepCN`
If `ExtendFunctor` gives a compositional path through `PrepNP prep (MassNP cn)`, that is the baseline.
Custom `PrepCN` is allowed only if Albanian requires a stricter bare-noun reading than the default mass path.

#### Structural export note
If a preposition-like element is publicly re-exported through structural modules, ensure the constructor path remains consistent with the structural resource, not just with one local extension module.

### 7.2 CN and noun-preserving subsystem

Albanian `CN` is not flat.

The approved CN-preserving pattern is visible in `NounSqi.gf`, where nominal constructors preserve:
- noun table shape,
- species/case/number dimensions,
- gender.

Policy:
- Any `CN -> CN` override must preserve `cn.g` and the full `cn.s` table.
- Do not construct a `CN` from a plain string unless the target semantics really are a lexicalized noun placeholder and the reduced shape is accepted by Albanian core code.
- Use core noun constructors when available.
- If a helper extracts a noun surface string, treat that helper as presentation-only unless the target category itself is shallow.
- Never claim a `CN` override is final if it depends on a flattened noun surface and drops gender.

### 7.3 AP and adjective-preserving subsystem

Albanian APs are not flat and carry full agreement-sensitive forms.

Policy:
- If the result is AP, preserve species/case/gender/number behavior.
- Prefer Albanian adjective constructors over string extraction.
- Treat `apStr`-style flattening as presentation-only, not as a final implementation strategy.
- Any AP override that produces lock warnings is not final.
- Any AP-facing helper must be verified as AP-compatible; do not reuse an `A` helper as if it were an `AP` helper.
- If only one AP cell is extracted, that is acceptable only when the target category is shallow and the use is explicitly presentational.

This applies especially to functions like:
- `ICompAP`
- `AdvIsNPAP`
- `PredAPVP`
- `AdjAsCN`
- `AdjAsNP`
- `CompoundAP`
- `ReflA2RNP`

#### Special caution
Any code path that moves between `A`, `Adj`, and `AP` must document the exact category boundary. These names are close enough to cause recurring AI drift.

### 7.4 Existential subsystem

The functor already provides constructor-based existential paths.

Policy:
- `ExistS`, `ExistNPQS`, `ExistIPQS`, `ExistsNP`, `ExistCN`, `ExistMassCN`, and `ExistPluralCN` should inherit or mirror the constructor path unless Albanian clause mechanics force a different analysis.
- Do not build these as flat strings if the functor uses `UseCl`, `UseQCl`, `QuestCl`, `ExistNP`, or `ExistIP`.
- If a custom existential implementation is needed, it must still be clause/question-based, not surface-string based.
- Treat existential functions as a family: do not redesign one while leaving the others on an incompatible representation strategy.
- If a clause-based inherited path exists, that path must be explicitly rejected before any surface-only implementation is accepted.

### 7.5 Reflexive NP (`RNP`) subsystem

This subsystem must be handled as a unit.

#### Default structural stance
In the uploaded `ExtendFunctor.gf`,
- `RNP = Grammar.NP`
- `RNPList = Grammar.ListNP`

This is the default low-risk Albanian strategy.

#### Policy
- Prefer inherited `NP/ListNP` structure unless Albanian proves it needs a custom `RNP` record.
- Do not mix a custom `RNP` record with inherited `NP/ListNP` list logic unless the entire subsystem is redesigned consistently.
- If Albanian keeps the inherited strategy, then all `RNP`-family functions must return genuine NP/ListNP-compatible values.
- Do not leave one member of the family using bare strings while the rest use `NP/ListNP` structure.

#### Subsystem members that must be considered together
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

#### Model-language policy for RNP
- Bulgarian is the primary structural reference for a compact explicit RNP subsystem.
- German is the secondary reference for richer subsystem behavior and design rationale.
- Do not copy German `rc/ext/isPron` or Bulgarian `gn/isPron` fields into Albanian automatically.
- Copy subsystem completeness and family discipline, not hidden inventory.

#### List-shape caution
When the RNP family uses `ListNP`, keep the Albanian list shape exact. Do not fabricate a fake list category from string concatenation if conjunction code expects `init`, `last`, and `a`.

### 7.6 Card / numeral / determiner interaction

Albanian core files define `Card` as string-like, but `CN` is noun-shaped.

Policy:
- `CardCNCard` must return a `Card`-appropriate result, not a `CN` record.
- If a function combines cardinals and nouns but the abstract return type is not `CN`, do not use `cnConst` or any other noun constructor in the result position.
- Use noun strings only at the last mile if the target category itself is string-like.
- Do not infer from noun participation that the result should be noun-shaped.
- Distinguish carefully between numeral syntax, noun agreement, and final return category.

### 7.7 Structural and lexical-functional subsystem

Structural and lexical-functional items are often the most deceptive: they may look shallow, but still be module-context-sensitive.

Policy:
- For items such as `Prep`, `Subj`, `Conj`, `PConj`, `DConj`, `CAdv`, `Utt`, and `Voc`, consult:
  - the lexical/functional elements document,
  - the shallow-category constructor matrix,
  - and the stale comment tracker if older comments exist.
- Do not generalize from a category summary entry to a universal local constructor pattern.
- If an item is tracked as warning-state or provisional in the symbol status ledger, do not treat it as a settled pattern.

---

## 8. Override triggers and non-triggers

### 8.1 Valid triggers for override
Override is justified when:
- `ExtendFunctor` gives `variants {}`,
- Albanian uses a different category shape than the default path assumes,
- Albanian morphological agreement or case choice differs materially,
- Albanian requires specific article/bare-form policy,
- Albanian uses clitic-sensitive placement not captured by the default,
- compile diagnostics show the inherited path is structurally wrong for Albanian,
- the current module context does not accept the apparently obvious constructor pattern,
- the existing local implementation violates exact-helper-type rules,
- the existing local implementation depends on stale comments or stale assumptions.

### 8.2 Invalid triggers for override
Override is not justified merely because:
- a flat string implementation looks shorter,
- a model language has a custom version,
- a function “sounds language-specific”,
- a local hack removes one compile error but introduces lock warnings,
- the AI cannot immediately see the inherited path,
- a category summary looks simple,
- a helper name looks similar to the desired category,
- a stale comment suggests an older representation,
- a constructor pattern worked in another file.

---

## 9. Forbidden patterns

The following patterns are forbidden unless explicitly documented as intentional exceptions.

### 9.1 Name-based implementation choice
Do not choose constructors or overloads by name similarity.
Always choose by exact signature and module context.

### 9.2 Rich category flattening
Do not use:
- `apStr`
- `cnStr`
- ad-hoc `{s = ...}`

as the final implementation of a function unless the target category is truly string-like.

### 9.3 Partial record fabrication
Do not create `lin AP`, `lin CN`, `lin NP`, `lin ListNP`, etc. with only the visible surface fields if Albanian core code or compiler warnings imply hidden fields must be preserved.

### 9.4 Isolated subsystem patching
Do not redesign only one member of:
- the existential family,
- the AP/CN conversion family,
- the RNP family,
- the focus/preposition family,

without checking the rest of the family.

### 9.5 Blind model-language copying
Do not port German or Bulgarian field inventories or word order wholesale into Albanian.

### 9.6 Constructor-by-shape assumption
Do not assume that a documented category shape automatically licenses:
- `lin Cat { ... }`,
- direct field fabrication,
- or local record construction

in a different module or resource.

### 9.7 Near-type helper reuse
Do not reuse a helper for a nearby type unless the type matches exactly.

Examples of forbidden reasoning:
- “`A` is close enough to `AP`”
- “`N` is close enough to `CN`”
- “this list helper probably works for the other list category too”
- “this pronoun helper is probably fine for any NP”
- “this compatibility helper can probably serve as a final rich-category builder”

### 9.8 Compile-success-only reasoning
Do not accept a patch merely because one hard type error disappears if:
- new lock warnings appear,
- a downstream module now fails,
- or the patch depends on an unverified constructor-context assumption.

### 9.9 Stale-comment inference
Do not infer implementation truth from comments alone when:
- current source disagrees,
- current category definitions disagree,
- or the compiler rejects the pattern.

### 9.10 Borrowed-module constructor transfer
Do not assume a constructor pattern from one module is automatically valid in another module with a different open/import context.

---

## 10. Approved implementation patterns

### 10.1 Preserve-category pattern
If a function returns the same broad category family it consumes, preserve the full structural table.

Example policy:
- `CN -> CN` must preserve noun table and gender.
- `AP -> AP` must preserve adjective agreement structure.
- `NP -> NP` must preserve case table and agreement.

### 10.2 Constructor-chain pattern
If `ExtendFunctor` gives a constructor chain, use the same chain or an Albanian-equivalent chain.

Examples:
- `CompBareCN` via `CompCN`
- existentials via `ExistNP` / `ExistIP`
- adverbial predication via `PredVP` + `UseComp`

### 10.3 Surface-only pattern
A string helper is acceptable only when the result category is itself string-like, such as many Albanian `Comp`, `S`, `QS`, `RS`, or `Utt`-style local approximations.

Additional rule:
- the helper must still match the exact input category,
- and the result must remain explicitly presentation-level, not silently reintroduced as a rich category.

### 10.4 List-shape pattern
If Albanian conjunction defines a list category such as `ListNP`, use that exact list shape and wrap values with the correct list lincat.

### 10.5 Verified-helper pattern
A shared helper is approved only when:
1. its type matches the current category exactly,
2. its behavior matches the target module context,
3. it preserves the required Albanian shape where necessary,
4. its maturity/status is appropriate for the subsystem.

### 10.6 Verified-constructor-context pattern
A local constructor pattern is approved only when:
1. the constructor is actually available in the current module,
2. the accepted fields are known from the current codedump or compile acceptance,
3. no existing Albanian core constructor path should be preferred instead,
4. the pattern is not contradicted by current warnings or downstream failures.

### 10.7 Compatibility-wrapper pattern
A compatibility wrapper is acceptable when:
1. it is clearly labeled as compatibility-based or fallback-based,
2. it is used in a subsystem where shallow output is acceptable or temporary bridging is documented,
3. it is not silently upgraded into the final explanation for a rich category,
4. its limitations are documented,
5. the symbol status ledger does not mark it as forbidden for the current category family.

### 10.8 Structural-aggregator pattern
For modules like structural aggregators or coordinators:
- keep them thin,
- keep logic in owned submodules,
- do not repair constructor problems in the aggregator if the owned module is the real source of truth.

### 10.9 Support-document confirmation pattern
If a new support document exists for the issue under review, use it explicitly:
- helper issue → helper registry
- shallow-category issue → shallow-category constructor matrix
- warning/provisional issue → symbol status ledger
- comment conflict issue → stale comment tracker
- module-underdocumentation issue → module extraction coverage

Support documents refine, but do not replace, abstract-signature and compile-reality checks.

---

## 11. Model-language use policy

### 11.1 Bulgarian policy
Use Bulgarian first when:
- the subsystem is compact,
- the target problem is reflexive nominal structure,
- Albanian likely needs a minimal explicit subsystem.

Copy from Bulgarian:
- subsystem completeness,
- role of agreement metadata,
- relation between reflexive pronoun and possessive reflexive NP,
- discipline about keeping a family coherent.

Do not copy blindly:
- Bulgarian case-role inventory,
- Bulgarian noun-form system,
- Bulgarian person/polarity internals.

### 11.2 German policy
Use German when:
- the subsystem is richly developed and fully overridden,
- you need examples of disciplined removal from `ExtendFunctor`,
- you need evidence that a whole family must be overridden together.

Copy from German:
- subsystem grouping,
- override discipline,
- structural reasoning,
- explicit ownership boundaries.

Do not copy blindly:
- `rc`, `ext`, `isPron` fields,
- German agreement/controller logic,
- German preposition-case system.

### 11.3 Model-language refusal rule
If the model language suggests a structure that current Albanian lincats do not support, refuse the transfer even if the pattern looks elegant.

---

## 12. AI coding protocol for inheritance/override decisions

For every candidate function:

1. Read the abstract signature.
2. Read the current Albanian codedump for the relevant modules.
3. Read the `ExtendFunctor` implementation or confirm it is `variants {}`.
4. Read the Albanian lincat definitions for all relevant argument and result categories.
5. Search Albanian core modules for an existing constructor pattern of the same target category.
6. Verify that any proposed local constructor pattern is actually valid in the current module context.
7. Verify that any reused helper matches the exact input/output categories.
8. Check the helper registry if a helper is involved.
9. Check the shallow-category constructor matrix if the category looks shallow.
10. Check the symbol status ledger if the symbol or helper may be provisional or warning-state.
11. Check the stale comment tracker if any explanatory comments appear to drive the decision.
12. If still unresolved, inspect Bulgarian first, then German, only for the same subsystem.
13. Decide:
   - inherit,
   - inherit with constructor mirroring,
   - or full Albanian override.
14. Check for hard type errors and lock-field warnings.
15. Check downstream modules that depend on the edited file.
16. Record the decision if it affects subsystem policy or closes an open ambiguity.

No final override is accepted before step 14.

---

## 13. Decision criteria for “final” quality

An override is final only if all of the following hold:

- compiles without hard type errors,
- does not introduce category-shape mismatch,
- does not introduce new `missing lock_*` warnings,
- does not depend on an invalid constructor-context assumption,
- does not reuse a helper across incompatible categories,
- preserves the Albanian lincat contract,
- is defensible from abstract signature + current codedump + default path + Albanian evidence,
- does not contradict the chosen subsystem strategy,
- does not rely on stale comments as primary evidence,
- and any remaining limitation is explicitly documented.

If any of those fail, the implementation remains provisional.

### 13.1 Provisional-quality rule
A patch may be kept provisionally if:
- it is clearly marked temporary,
- it is documented as compatibility/fallback,
- it does not pretend to settle a richer structural issue,
- and a follow-up obligation is recorded.

### 13.2 Rejection rule
Reject any patch that:
- compiles but introduces lock warnings,
- removes one local error but breaks dependent modules,
- hides a type mismatch through a compatibility helper without documentation,
- or depends on a constructor that is not verified in the current module.

---

## 14. Policy for `ExtendSqi` and companion ownership

### 14.1 Coordinator rule

`ExtendSqi.gf` is a thin coordinator.

Allowed contents:
- subsystem imports,
- override subtraction list,
- subsystem-to-function renamings.

Disallowed contents:
- new local helper logic,
- ad hoc coordinator-side record construction,
- unsupported list-family or VPS-family machinery,
- repair code that belongs in a companion module.

### 14.2 Companion ownership rule

Companion modules own Albanian-specific implementation logic.

Current subsystem families include:
- scaffolding,
- VP bridge,
- AP/CN conversion,
- existential,
- RNP,
- focus/preposition,
- lexical tail,
- helper inventory.

### 14.3 Unsupported inherited-family rule

The VPS/VPI/VPS2/VPI2/list-wrapper family remains inherited in the current cycle unless explicitly re-opened by architecture documents.

No local Albanian subsystem should quietly reintroduce that family.

### 14.4 Family-coherence rule

Subsystem families must be implemented and reviewed as families, not as isolated functions.

This applies especially to:
- the `RNP` family,
- the existential family,
- the AP/CN conversion family,
- the focus/preposition family,
- the VP/VPSlash bridge family.

If one member changes representation, the rest of the family must be checked immediately.

---

## 15. Maturity model

The Albanian grammar should be documented in three maturity levels:

1. **stable core modules** that define the language baseline,
2. **fallback modules** that compile but contain deliberate simplifications,
3. **active override modules** where type and shape discipline are still being repaired.

`GrammarSqi` and most core modules are closer to the first two levels.  
`ExtendSqi` remains in the third.

Implications:
- stable modules are preferred as evidence for category-safe constructor patterns,
- fallback modules may be used as current truth but must be labeled as simplified,
- active override modules require stronger validation discipline and more explicit documentation.

The symbol status ledger is the preferred support file for recording provisional and warning-state implementation facts.

---

## 16. Operational rules for future work

### 16.1 Category authority rule

The category authority remains `CatSqi`.

Any code that returns `CN`, `AP`, `NP`, `Pron`, or a list category must preserve the concrete Albanian shape defined there or in the relevant core/list module.

Any code that returns a shallow category should use the simplest correct composition rather than inventing richer local records.

### 16.2 Inheritance-first rule

Extension work must start from the inherited design.

Check `ExtendFunctor` and the abstract signature before writing local Albanian code.

Override only when Albanian genuinely needs it, and document the whole overridden family together.

### 16.3 Exact helper-type rule

A shared helper may be reused only when its **input and output categories match exactly** in the current codebase.

Category similarity is not enough.

An `A -> Str` helper is not automatically valid for an `AP -> Str` use site, and vice versa.

### 16.4 Constructor-availability rule

A documented lincat shape is not by itself a license to write `lin Cat { ... }` in any module.

Constructor availability must be checked in the **actual module context** and against the **current codedump/compiler reality**.

### 16.5 Current-codedump rule

When architecture docs, inferred category shape, and live compiler behavior pull apart, the authority order for concrete coding decisions is:

1. current compiler error and current source dump,
2. exact abstract signature,
3. current Albanian lincat and core constructor path,
4. architecture docs,
5. model-language comparison.

The docs remain the authority for architecture, but the current repository remains the authority for what compiles now.

### 16.6 Comment-authority rule

When comments disagree with current code or current compile behavior:
- treat the comment as stale until verified,
- do not use the comment as constructor evidence,
- and update the comment/documentation if the code is confirmed correct.

### 16.7 Support-doc synchronization rule

When a new implementation lesson changes:
- helper legality,
- constructor availability,
- stale comment handling,
- symbol maturity,
- or module extraction coverage,

update the relevant support docs alongside this policy or the decision log. No important lesson should remain only in transient discussion history.

---

## 17. Conflict-resolution procedure

When sources disagree during an Albanian repair pass, use this exact resolution order:

1. identify the exact abstract signature,
2. identify the current compiler error or current compile behavior,
3. inspect the current module source in the codedump,
4. inspect `ExtendFunctor` for inherited composition,
5. inspect Albanian lincats and core constructor modules,
6. inspect the relevant support docs:
   - helper registry,
   - shallow-category constructor matrix,
   - symbol status ledger,
   - stale comment tracker,
   - module extraction coverage,
7. inspect architecture/ownership docs,
8. inspect model languages only if still unresolved,
9. inspect comments last.

This procedure is mandatory for AI-assisted work.

---

## 18. Recommended reading and validation order

For maintainers and AI systems, the preferred order is:

1. current compile/audit output,
2. exact source file in the current codedump,
3. abstract signature,
4. `ExtendFunctor` default or gap,
5. Albanian lincat/core constructor modules,
6. relevant support docs,
7. subsystem architecture docs,
8. model-language comparison only if Albanian evidence is still missing.

This reading order is stricter than earlier broad guidance because it better reflects how real failures must now be debugged.

---

## 19. Policy for warnings and provisional states

### 19.1 Lock warnings are structural signals

Warnings such as `missing lock_AP` and `missing lock_CN` are not cosmetic. Treat them as evidence of category-shape damage until proved otherwise.

### 19.2 Provisional implementations must be marked

If a function compiles through a compatibility wrapper or approximation:
- label it `provisional`, `fallback`, or `temporary`,
- record the affected categories,
- record the reason it is not final.

### 19.3 No silent approximations

No approximation is accepted as final merely because the surface string looks plausible.

### 19.4 Status-ledger synchronization

If a symbol is known to be:
- blocked,
- warning-state,
- provisional,
- fallback-based,
- or under architectural review,

the symbol status ledger should record that fact. This policy file should not become a hidden alternative status tracker.

---

## 20. High-risk zones

Based on the current Albanian code and repair history, the highest-risk override zones are:

1. AP/CN conversion and predicate functions:
   - `ICompAP`
   - `N2VPSlash`
   - `AdjAsCN`
   - `AdjAsNP`
   - `CompoundAP`

2. Reflexive NP subsystem:
   - entire `RNP` family

3. Any function that currently relies on:
   - `apStr`
   - `cnStr`
   - compatibility wrappers used near rich-category boundaries

4. Structural closed-class items that look simple but may still be constructor-sensitive:
   - prepositions,
   - `DConj`,
   - conjunction-like items,
   - vocatives,
   - other lexical/functional elements with warnings or module-context uncertainty

5. Helper-selection boundaries:
   - `A` vs `AP`
   - `N` vs `CN`
   - `Pron` vs `NP`
   - `NP` vs `ListNP`
   - compatibility wrappers vs final rich-category builders

6. Stale comment zones:
   - files where comments describe older category defaults or older constructor assumptions

Policy for these zones:
- assume provisional until compile warnings are gone,
- require explicit evidence review before accepting AI-generated edits,
- require subsystem-aware review rather than isolated one-function review.

---

## 21. What this policy forbids

This policy forbids:

- inferring implementation from function name alone,
- flattening rich Albanian categories to strings for convenience,
- borrowing a constructor pattern from a different module without context verification,
- reusing helpers across near-types,
- trusting stale comments over code/compiler behavior,
- fixing one member of a family while leaving the representation inconsistent elsewhere,
- reintroducing unsupported inherited families into local Albanian code,
- treating model-language code as primary truth,
- using support documents as shortcuts that bypass abstract signature or compile checks.

---

## 22. Maintenance and update obligations

When this policy changes, the following must be checked for consistency:

- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`
- `ALBANIAN_LANGUAGE_ARCHITECTURE.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`

If a new implementation lesson changes concrete coding discipline, update the decision log and the relevant operational documents, not just chat notes.

---

## 23. Recommended companion documents

This policy is meant to be read together with:

- `ALBANIAN_SYNTAX_AND_CONSTRUCTOR_RULES.md`
- `ALBANIAN_IMPLEMENTATION_PATTERNS.md`
- `ALBANIAN_CATEGORY_AND_LINCAT_REFERENCE.md`
- `ALBANIAN_LEXICAL_AND_FUNCTIONAL_ELEMENTS.md`
- `ALBANIAN_FORBIDDEN_PATTERNS_AND_ANTI_DRIFT_RULES.md`
- `ALBANIAN_DECISION_LOG.md`
- `ALBANIAN_MINIMAL_TEST_SUITE_SPEC.md`
- `ALBANIAN_LANGUAGE_ARCHITECTURE.md`
- `ALBANIAN_HELPER_REGISTRY.md`
- `ALBANIAN_SHALLOW_CATEGORY_CONSTRUCTOR_MATRIX.md`
- `ALBANIAN_SYMBOL_STATUS_LEDGER.md`
- `ALBANIAN_STALE_COMMENT_TRACKER.md`
- `ALBANIAN_MODULE_EXTRACTION_COVERAGE.md`

The function of this file is policy-level control. It should not duplicate all the inventories, matrices, or ledgers that those companion documents hold.

---

## 24. Summary

The Albanian GF grammar should still be maintained as a layered RGL concrete syntax with strong category discipline, inheritance-first reasoning, subsystem ownership, and explicit anti-drift controls.

The architecture does not need rewriting.

What must remain strict is the operational method:

- start from the abstract signature,
- prefer inherited composition first,
- preserve the exact Albanian category shape,
- verify constructor availability in the actual module context,
- verify helper compatibility exactly,
- use the current codedump and current compiler behavior as decisive for concrete implementation,
- use support docs to refine, not replace, code evidence,
- and treat comments as secondary evidence only.

That is the policy required to prevent AI drift while keeping Albanian maintenance aligned with the real codebase.