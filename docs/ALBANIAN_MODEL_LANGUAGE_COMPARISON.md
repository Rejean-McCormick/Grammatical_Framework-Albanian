# ALBANIAN_MODEL_LANGUAGE_COMPARISON

## Purpose

This document defines how model languages should be used when implementing or repairing the Albanian GF concrete syntax.

It is not a "copy from another language" guide. It is a controlled comparison guide whose goal is to:

- choose the right reference language for each subsystem;
- prefer inherited `ExtendFunctor` / `GrammarSqi` constructor paths when they already exist;
- prevent drift from Albanian lincat shapes and category contracts;
- separate reusable structural ideas from language-specific surface details.

## Source precedence

Model-language comparison is never the first source of truth.

Use this precedence order:

1. `abstract/Extend.gf` and exact abstract signatures;
2. `common/ExtendFunctor.gf` and inherited default compositions;
3. Albanian core lincats and constructors (`CatSqi.gf`, `ResSqi.gf`, `NounSqi.gf`, `AdjectiveSqi.gf`, `AdverbSqi.gf`, `ConjunctionSqi.gf`, `ExtraSqi.gf`, etc.);
4. model languages;
5. local Albanian repair choices.

## Albanian baseline relevant to comparison

Albanian comparison must start from the Albanian category shapes, not from another language.

Key facts:

- `Prep = Compl = {s : Str}`.
- `CN = Noun`, with `s : Species => Case => Number => Str` and `g : Gender`.
- `NP = {s : Case => Str; a : Agr}`.
- `ListNP = {init : Case => Str ; last : Case => Str ; a : Agr}`.
- Albanian preposition use already follows `PrepNP p np = {s = p.s ++ npAfterPrep p np}`.
- Albanian helper patterns such as `cnCaseIndef` and `cnCaseWithDet` show that noun tables should normally be preserved and projected carefully, not flattened arbitrarily.

These shapes make Albanian much closer to an NP/ListNP-based implementation strategy than to a language with very rich custom noun-phrase side fields.

## Master comparison rules

### Rule 1: compare by subsystem, not by function name alone

Do not search for a model-language function with the same name and copy it directly.

Always compare at subsystem level:

- existential family;
- AP/CN conversion family;
- preposition/adverb family;
- reflexive noun phrase (`RNP`) family;
- compound/nominalization family;
- participial family.

### Rule 2: prefer functor defaults over model-language customizations

If `ExtendFunctor` already provides a composition path, use that path before looking at Bulgarian or German.

Examples of functor-provided composition paths that matter for Albanian repair:

- `CompBareCN` through `CompCN`;
- `AdvIsNP` through `UseComp` + `CompAdv`;
- `AdvIsNPAP` through `AdvVP` + `UseComp` + `CompAP`;
- existential constructors through `ExistNP` / `MassNP` / determiner-based NP construction;
- inherited `RNP = Grammar.NP` and `RNPList = Grammar.ListNP`.

### Rule 3: use model languages to justify structure, not surface strings

A model language is useful when it shows:

- whether a subsystem must be redesigned as a whole;
- whether a category must preserve a richer record shape;
- whether a default functor implementation is intentionally overridden;
- what kinds of fields must remain coherent across a family.

A model language is not useful as a source of:

- Albanian word order;
- Albanian case assignment;
- Albanian article behavior;
- Albanian clitic placement;
- Albanian gender defaults.

### Rule 4: when model languages disagree, choose the structurally smaller one first

When Bulgarian and German both implement a subsystem, prefer:

- Bulgarian first when the subsystem can be modeled with a smaller, cleaner record;
- German second when the subsystem clearly needs richer fields or when the subsystem is tightly integrated with clause-level or heavy-NP behavior.

## Role of ExtendFunctor and abstract Extend

`ExtendFunctor` is the primary model for Albanian `ExtendSqi` because Albanian concretely inherits it and only subtracts selected implementations.

`ExtendFunctor` already encodes several intended constructor paths, including:

- `CompBareCN -> CompCN`;
- `CompIQuant -> CompIP + IdetIP + IdetQuant + NumSg`;
- `AdvIsNP -> UseComp + CompAdv`;
- `AdvIsNPAP -> AdvVP + UseComp + CompAP`;
- existential constructions through `ExistNP` and `MassNP`;
- inherited `RNP = Grammar.NP` and `RNPList = Grammar.ListNP`.

Therefore, for Albanian:

- if a function exists in `ExtendFunctor` as a good composition path, that path is the default choice;
- only move to Bulgarian or German if Albanian has evidence that the functor path is insufficient.

## Bulgarian as model language

### Bulgarian is the primary comparison language for the RNP family

Bulgarian defines a compact but explicit `RNP` subsystem:

- `RNP = {s : Role => Str; gn : GenNum; isPron : Bool}`;
- `ReflPron`, `ReflPoss`, `PredetRNP`, `AdvRNP`, `AdvRVP`, `AdvRAP`, `ReflA2RNP`, `PossPronRNP`, and list/coordination behavior are implemented together.

This makes Bulgarian the best structural guide when Albanian needs to reason about:

- whether the reflexive NP family should be treated as one subsystem;
- what minimal metadata is needed in an RNP-like structure;
- how possessive/reflexive noun-phrase logic interacts with agreement and list coordination.

### What Albanian should copy from Bulgarian

Copy these ideas:

- treat the whole `RNP` family as a coherent subsystem;
- keep agreement-related metadata coherent across `ReflPron`, `ReflPoss`, `PredetRNP`, `AdvRNP`, `ConjRNP`, and list constructors;
- prefer constructor-based composition for `PossPronRNP` rather than raw string concatenation.

### What Albanian should not copy from Bulgarian

Do not copy:

- Bulgarian `Role` directly into Albanian if Albanian is inheriting `NP`/`ListNP` from `ExtendFunctor`;
- Bulgarian case labels or pronoun forms;
- Bulgarian article/species logic;
- Bulgarian AP or VP surface order.

### Bulgarian in AP comparison

Bulgarian is also a useful model for AP preservation because `SentAP` keeps AP structure intact and extends it compositionally instead of flattening it to a single string. This is valuable for Albanian when deciding whether AP-producing functions should preserve full AP shape.

## German as model language

### German is the primary comparison language for rich custom overrides

German is the best model when the question is not "what is the smallest possible design?" but rather:

- when is a full custom override justified;
- how to preserve a rich category shape across a subsystem;
- how to integrate reflexive noun phrases into clause and VP machinery.

German `ExtendGer` explicitly removes defaults for many functions that Albanian has also been struggling with, including:

- `ICompAP`, `PrepCN`, `AdvIsNP`, `RNP`, `RNPList`, parts of the `RNP` family, `CardCNCard`, and others.

German also shows a rich `RNP` implementation:

- `RNP = {s : Agr => Case => Str ; rc, ext : Str ; isPron : Bool}`;
- `RNPList = {s1, s2 : Agr => Case => Str}`.

### What Albanian should copy from German

Copy these ideas:

- full subsystem redesign is legitimate when the default composition is structurally insufficient;
- when a category is redesigned, the whole family must stay coherent;
- reflexive NP behavior may need to interact with VP insertion, prepositions, and coordination as one design.

German is especially useful for understanding:

- why `PrepCN` can be a real language-specific override;
- why `RNP` must be treated structurally, not as isolated strings;
- why AP values such as `SentAP` should extend an existing AP record rather than collapse it.

### What Albanian should not copy from German

Do not copy:

- German field inventory (`rc`, `ext`, weight, heavy NP behavior, article-gluing behavior) unless Albanian lincats require it;
- German agreement tables where Albanian categories are simpler;
- German subject-case, preposition, or article mechanics.

### German caveat for Albanian

German also documents a useful warning: some functions are structurally tricky enough that even German avoids a full implementation in a naive style. `AdvRVP` is explicitly noted as difficult because the inserted reflexive-adverb material can depend on which nominal argument controls agreement. That is a sign that Albanian should not assume every `RNP`-related function has a trivial string solution.

## Subsystem-by-subsystem comparison policy

### 1. Preposition + nominal constructions

Primary reference order:

1. `ExtendFunctor`;
2. Albanian `ResSqi.gf` and `AdverbSqi.gf`;
3. German if a rich override is required.

Rationale:

- Albanian `Prep` is just `{s : Str}`;
- Albanian already handles preposition + NP through `PrepNP`;
- `ExtendFunctor` already uses constructor composition for related cases;
- German is only needed when the result category must preserve richer structure.

Policy:

- prefer constructor-based `PrepNP` / `MassNP` solutions;
- only implement a special Albanian `PrepCN` if the surface requirement cannot be achieved by the functor path;
- never return a CN-shaped record when the abstract result is `Adv`.

### 2. Existential family

Primary reference order:

1. `ExtendFunctor`;
2. Albanian NP/CN core;
3. model languages only if functor composition is insufficient.

Rationale:

The Albanian compile failures already showed that treating `ExistS`, `ExistNPQS`, and `ExistIPQS` as flat `{s : Str}` outputs is structurally wrong. The functor already points to `ExistNP`, `MassNP`, and clause/question constructors.

Policy:

- existential functions should be built through clause/question composition;
- do not hand-build them as raw strings unless the target category is really stringy.

### 3. AP/CN conversion and complement family

Primary reference order:

1. `ExtendFunctor`;
2. Albanian AP/CN lincats and Albanian core adjective/noun modules;
3. Bulgarian and German AP implementations.

This includes:

- `ICompAP`;
- `PredAPVP`;
- `AdjAsCN`;
- `AdjAsNP`;
- `CompoundAP`;
- `CompBareCN`;
- `AdvIsNPAP`;
- `CardCNCard`;
- `N2VPSlash`.

Rationale:

The Albanian compile logs repeatedly flagged these functions with `missing lock_AP` and `missing lock_CN` warnings or type mismatches, which is strong evidence that the current risk comes from flattening AP/CN structures instead of preserving their category shape.

Policy:

- use functor/default constructor paths whenever they exist;
- when a custom Albanian implementation is needed, preserve full AP/CN shape;
- use Bulgarian/German AP behavior as evidence that AP values should usually be extended structurally rather than reduced to one nominative singular string.

### 4. RNP family

Primary reference order:

1. `ExtendFunctor` for inheritance default;
2. Bulgarian for minimal structured custom design;
3. German for rich custom design.

This includes:

- `ReflPron`;
- `ReflPoss`;
- `PredetRNP`;
- `AdvRNP`;
- `AdvRVP`;
- `AdvRAP`;
- `ReflA2RNP`;
- `PossPronRNP`;
- `ConjRNP`;
- `Base_*_RNP` / `Cons_*_RNP`.

Policy:

- Albanian should first try the inherited `NP/ListNP` strategy from `ExtendFunctor`;
- if that proves insufficient, redesign the entire family together;
- do not mix inherited `NP` behavior with partial custom string-like `RNP` values.

Preferred comparison:

- Bulgarian answers the question "what is the smallest coherent custom RNP subsystem?";
- German answers the question "what does a rich, fully integrated custom RNP subsystem look like?".

## Explicit model-language priorities

### Use Bulgarian first when

- the problem is in `RNP` structure or list coordination;
- a smaller structural model is preferable;
- Albanian lincats are simpler than German ones.

### Use German first when

- the subsystem is already clearly a full custom override;
- the question is about preserving a rich category shape across a family;
- Albanian needs evidence that a whole-family redesign is legitimate.

### Use neither first when

- `ExtendFunctor` already provides the composition;
- the Albanian problem is simply a wrong return category or a flattened helper.

## Anti-drift rules for model-language use

1. Never copy a model-language implementation without first checking Albanian lincats.
2. Never copy by function name alone; match exact abstract signature and module context.
3. Never import German-specific side fields into Albanian unless Albanian categories require them.
4. Never use Bulgarian as proof that Albanian must abandon inherited `NP/ListNP` if `ExtendFunctor` already gives a workable design.
5. When a model language customizes a whole family, assume Albanian must keep that family coherent too.
6. When compile logs show `lock_AP` or `lock_CN` warnings in Albanian, treat that as evidence that the comparison target should preserve full category shape.

## Practical recommendations for Albanian repair work

### Default choice pattern

For every problematic function, follow this order:

1. check the exact abstract signature;
2. inspect the `ExtendFunctor` composition;
3. check Albanian core category shape;
4. compare Bulgarian if the issue is minimal structured reflexive NP behavior;
5. compare German if the issue is rich category preservation or whole-family redesign.

### Current Albanian hotspots where model comparison matters most

The Albanian snapshot and compile history show the most important comparison areas are:

- `PrepCN`;
- existential family (`ExistS`, `ExistNPQS`, `ExistIPQS`, `ExistCN`, `ExistMassCN`, `ExistPluralCN`, `ExistsNP`);
- AP/CN conversion family (`ICompAP`, `PredAPVP`, `AdjAsCN`, `AdjAsNP`, `CompoundAP`, `CompBareCN`, `CardCNCard`, `AdvIsNPAP`, `N2VPSlash`);
- `RNP` family.

These are exactly the places where Albanian has been vulnerable to category flattening, partial records, or subsystem drift.

## Final comparison policy

- `ExtendFunctor` is the primary model for Albanian `ExtendSqi`.
- Bulgarian is the primary custom-model language for `RNP`.
- German is the primary custom-model language for rich whole-family overrides and category-shape preservation.
- Albanian-specific morphology and syntax must always come from Albanian core modules, not from the model language.

