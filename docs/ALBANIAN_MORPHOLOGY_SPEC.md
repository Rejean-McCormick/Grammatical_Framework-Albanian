# ALBANIAN_MORPHOLOGY_SPEC

## Status and scope

This document describes the **morphological system implemented in the Albanian GF codedump** used in this conversation. It is not a general linguistic grammar of Albanian; it is a specification of the morphology that the current GF implementation expects and exposes.

The document is written to support:

- consistent coding in `GF/lib/src/albanian/*`
- non-drifting AI edits
- safe reuse of paradigm builders and lincat shapes
- debugging of category-shape errors that actually come from morphology-aware records

This document is authoritative for morphology-facing implementation work unless a more specific source file in the Albanian core modules contradicts it.

## Source basis

Primary implementation sources:

- `albanian/ResSqi.gf`
- `albanian/CatSqi.gf`
- `albanian/NounSqi.gf`
- `albanian/AdjectiveSqi.gf`
- `albanian/VerbSqi.gf`
- `albanian/NumeralSqi.gf`
- `albanian/ParadigmsSqi.gf`
- `albanian/MorphoSqi.gf`
- `albanian/DocumentationSqi.gf`

Secondary support sources:

- `SyntaxSqi.gf`
- `ConjunctionSqi.gf`
- `ConstructionSqi.gf`

## 1. Morphological primitives

### 1.1 Species

Albanian nominal and adjectival morphology is sensitive to:

- `Indef`
- `Def`

In the code this is the `Species` parameter.

### 1.2 Case

The core case inventory implemented by the grammar is:

- `Nom`
- `Acc`
- `Dat`
- `Ablat`

Important consequence: all case-bearing categories should be treated as four-way systems in code, even where surface distinctions collapse.

### 1.3 Gender

The grammar implements two genders:

- `Masc`
- `Fem`

### 1.4 Number

The grammar uses standard GF number:

- `Sg`
- `Pl`

### 1.5 Person

Finite verbal paradigms use standard GF person:

- `P1`
- `P2`
- `P3`

### 1.6 Tense / finite-series inventory

The Albanian verb resource exposes the following finite tense axis inside `Indicative`:

- `Pres`
- `Past`
- `Imperfect`
- `Aorist`

In addition, the verb record separately stores:

- `Imperative`
- `participle`
- `pres_optative`
- `perf_optative`
- `pres_admirative`
- `imperf_admirative`

## 2. Core morphology-bearing record types

### 2.1 Noun

The core noun record is:

- `s : Species => Case => Number => Str`
- `g : Gender`

This means every full noun paradigm potentially stores **16 surface forms** plus lexical gender.

#### Practical rule

Any function returning `CN` / `Noun` must preserve:

- the full `Species => Case => Number` table
- gender `g`

Never replace a `Noun` with a flat `{s : Str}` approximation.

### 2.2 Adjective

The core adjective record is:

- `s : Case => Gender => Number => Str`
- `clit : Bool`

So adjectives are **not** directly species-sensitive at the lexical level. Species enters at the AP layer through clitic/linking behavior.

#### Practical rule

A lexical adjective is not the same thing as an AP. `Adj` stores case/gender/number inflection plus a Boolean controlling whether a linking clitic must surface.

### 2.3 Verb

The core verb record contains:

- `Indicative : Tense => Number => Person => Str`
- `Imperative : Number => Str`
- `participle : Str`
- `pres_optative : Number => Person => Str`
- `perf_optative : Number => Person => Str`
- `pres_admirative : Number => Person => Str`
- `imperf_admirative : Number => Person => Str`

#### Practical rule

The grammar treats verbs as large inflectional records. Do not reduce a `Verb` to only one present-tense form unless you are explicitly building a surface fallback.

### 2.4 Pronoun

The pronoun record is:

- `s : Case => Str`
- `acc_clit : Str`
- `dat_clit : Str`
- `a : Agr`

This means personal pronouns combine:

- full case forms
- clitic forms for accusative and dative use
- agreement features

### 2.5 Quantifier

The quantifier record is:

- `s : Case => Gender => Number => Str`
- `spec : Species`

Quantifiers are therefore full morphology-bearing items, not plain strings.

### 2.6 Determiner

The determiner record is:

- `s : Case => Gender => Str`
- `n : Number`
- `spec : Species`

Determinants do not store their own number-indexed string table; number is stored separately in `n` and is used downstream when combining with nouns.

### 2.7 Agreement

Agreement is represented as:

- `GenNum = GSg Gender | GPl`
- `Agr = {gn : GenNum ; p : Person}`

Utility operations:

- `genNum : Gender -> Number -> GenNum`
- `agrgP3 : Gender -> Number -> Agr`

#### Practical rule

Most nominal builders in the Albanian code create third-person agreement with `agrgP3`.

## 3. Nominal morphology

### 3.1 Noun paradigm structure

The noun system distinguishes:

- definite vs indefinite
- nominative, accusative, dative, ablative
- singular vs plural
- lexical gender

`mkNoun` in `ResSqi.gf` explicitly takes 16 strings, ordered as:

1. Indef Nom Sg
2. Indef Nom Pl
3. Indef Acc Sg
4. Indef Acc Pl
5. Indef Dat Sg
6. Indef Dat Pl
7. Indef Ablat Sg
8. Indef Ablat Pl
9. Def Nom Sg
10. Def Nom Pl
11. Def Acc Sg
12. Def Acc Pl
13. Def Dat Sg
14. Def Dat Pl
15. Def Ablat Sg
16. Def Ablat Pl

followed by gender.

### 3.2 Definite/indefinite behavior

The implementation treats definiteness as a built-in part of noun inflection, not as something produced only by an article layer.

That means:

- definiteness is lexically visible in noun tables
- articles and determiners choose or constrain `Species`, but the noun still stores both paradigms

### 3.3 Noun combination with determiners

`DetCN` in `NounSqi.gf` combines a determiner with a noun as:

- determiner form indexed by case and noun gender
- noun form indexed by determiner species, case, and determiner number

This confirms the key design rule:

> the noun is the morphology-heavy element; the determiner selects species and number and contributes its own case/gender-sensitive surface material.

### 3.4 Adjective modification of nouns

`AdjCN` in `NounSqi.gf` preserves the noun table and appends an AP form chosen by:

- species
n- case
- noun gender
- number

This is the normal Albanian pattern for morphology-preserving CN modification.

### 3.5 Paradigm inventory

`ParadigmsSqi.gf` routes many noun stems through large families of suffix-sensitive paradigms such as `mkN001`, `mkN206`, etc. `MorphoSqi.gf` then defines the full inflection tables.

Implication:

- noun morphology is highly pattern-driven
- the correct coding practice is to reuse paradigm builders, not hard-code ad hoc nouns unless necessary

### 3.6 Morphology documentation support

`DocumentationSqi.gf` confirms that noun inflection is documented as a 2 × 4 × 2 system:

- Indef / Def
- Nom / Acc / Dat / Ablat
- Sg / Pl

## 4. Adjectival morphology

### 4.1 Lexical adjective structure

A lexical adjective (`Adj`) stores:

- case
- gender
- number
- clitic requirement (`clit`)

There is no lexical species axis on `Adj` itself.

### 4.2 AP structure

At the category level, `AP` is represented as:

- `s : Species => Case => Gender => Number => Str`

So AP is the species-sensitive adjectival layer, whereas lexical `Adj` is not.

### 4.3 Linking clitic behavior

`AdjectiveSqi.gf` shows that positive adjectives are linearized with optional insertion of `link_clitic` depending on `a.clit`.

Therefore:

- clitic-sensitive adjectives are not fully represented by their stem alone
- AP formation must preserve the `Species/Case/Gender/Number` interface and may need to insert the linker

### 4.4 Comparative formation

`ComparA` in `AdjectiveSqi.gf` is formed with:

- prefix `më`
- adjective form with normal clitic logic
- separator `se`
- comparison NP in nominative

So the implemented comparative strategy is analytic rather than inflectional.

### 4.5 A2 behavior

`ComplA2` combines an adjectival complement frame with:

- the positive/base A2 form
- complement preposition/string `c2.s`
- NP in accusative

### 4.6 Adjective documentation support

`DocumentationSqi.gf` confirms the adjective inflection table is organized by:

- Nom / Acc / Dat / Ablat
- Masc / Fem
- Sg / Pl

and computes displayed forms using the clitic rule.

## 5. Determiners, quantifiers, and articles

### 5.1 Indefinite article

`NounSqi.gf` defines `IndefArt` as:

- singular: `një`
- plural: empty string
- `spec = Indef`

### 5.2 Definite article

`DefArt` contributes no overt surface string in `NounSqi.gf`, but sets:

- `spec = Def`

This fits the general architecture where definiteness is largely realized inside the noun table.

### 5.3 Quantifier morphology

Quantifiers are full case/gender/number tables with a fixed `spec` value.

#### Practical rule

Quantifiers must not be flattened to `Str` when they still participate in nominal morphology.

## 6. Pronouns and clitics

### 6.1 Pronoun morphology

The Albanian pronoun resource stores four case forms:

- nominative
- accusative
- dative
- ablative

as well as:

- accusative clitic
- dative clitic
- agreement record

### 6.2 Pronoun creation rule

`mkPron` in `ResSqi.gf` confirms that full pronoun creation always provides both full forms and clitic forms.

### 6.3 Morphological implication

Any pronoun-level extension should preserve:

- case table
- clitic fields
- agreement

Do not replace a `Pron` with an `NP` unless the abstraction explicitly demands `NP`.

## 7. Verbal morphology

### 7.1 Verb paradigm shape

The verb resource stores a rich finite system, not just a present-tense lexeme.

Implemented subparadigms:

- Indicative: `Pres`, `Past`, `Imperfect`, `Aorist`
- Imperative
- Participle
- Present optative
- Perfect optative
- Present admirative
- Imperfect admirative

### 7.2 Predicative default in syntax

`VerbSqi.gf` frequently uses:

- present indicative
- singular
- third person

as the default finite stem for surface predicate-building.

This is a **syntax-layer convenience**, not a claim that the morphological resource is only 3sg-present-based.

### 7.3 Copula behavior

`VerbSqi.gf` defines a copular surface constant:

- `copula = "është"`

and uses it in `UseCopula` and `UseComp`.

### 7.4 Reflexive/passive-like morphology in syntax

`VerbSqi.gf` uses:

- `reflClit = "u"`

for reflexive/passive-like surface constructions in:

- `ReflVP`
- `PassV2`

This is a syntax–morphology interface rule worth preserving.

## 8. Prepositions and complement morphology bridge

`Compl` and `Prep` are both implemented as:

- `{s : Str}`

That means prepositions do not themselves encode case government as a typed feature.

Instead, case selection is imposed in syntax. For example, `AdverbSqi.gf` uses accusative after prepositions in its default `PrepNP` path.

#### Practical rule

Prepositions are surface-only in this grammar; case government lives in constructors, not in `Prep` records.

## 9. Numeral morphology

### 9.1 Numeral strategy

`NumeralSqi.gf` uses a largely analytic/compositional numeral system with:

- digit forms
- teen forms
- tens
- hundreds
- thousands

### 9.2 Digit-form axis

A digit stores:

- `unit`
- `teen`
- `ten`

via the local parameter `DForm = unit | teen | ten`.

### 9.3 Irregular numerals

The implementation explicitly treats some items as irregular, including:

- `2` → `njëzet` at the tens level
- `3` → `tridhjetë`
- `4` → `dyzet`

### 9.4 Number feature on digits

Digit strings also carry grammatical `Number`, which is used in the digit/decimal machinery.

## 10. Paradigm engineering policy

### 10.1 MorphoSqi is the inflectional backbone

`MorphoSqi.gf` contains the actual large paradigm inventory and full-form tables.

### 10.2 ParadigmsSqi is the public selection layer

`ParadigmsSqi.gf` chooses among many paradigm constructors based on suffix patterns and stem shapes.

### 10.3 Best-practice rule

When adding lexical items:

1. prefer existing public paradigm constructors
2. only add new low-level inflectional patterns in `MorphoSqi.gf` when genuinely necessary
3. keep `ResSqi.gf` record shapes stable

## 11. Documentation-facing inflection coverage

`DocumentationSqi.gf` provides inflection views for at least:

- nouns
- adjectives
- verbs

This is useful as a validation layer because it shows which morphological distinctions the grammar considers primary enough to display.

## 12. Implementation rules for morphology-safe coding

### 12.1 Preserve full record shapes

Do not flatten these categories to strings unless the target category is explicitly `{s : Str}`:

- `Noun` / `CN`
- `Adj` / `AP`
- `Verb`
- `Pron`
- `Quant`
- `Det`

### 12.2 Nouns are species-sensitive

Any noun-preserving transformation must preserve:

- `Species`
- `Case`
- `Number`
- `Gender`

### 12.3 Adjectives are clitic-sensitive

Any AP-building transformation that uses lexical adjectives must respect `a.clit` and the `link_clitic` system.

### 12.4 Default predicative fallbacks are not general paradigms

Using forms such as:

- `Indef/Nom/Masc/Sg` for AP
- `Indef/Nom/Sg` for CN
- `Pres/Sg/P3` for V

is acceptable only when building a deliberately predicative or citation-like fallback.

It is not acceptable as a substitute for a full category-preserving constructor.

### 12.5 Determiners and definiteness are coupled to noun morphology

Do not model Albanian definiteness as only an external article phenomenon. In the implemented grammar, definite vs indefinite morphology is built into noun inflection itself.

## 13. Known implementation constraints

- `DocumentationSqi.gf` does not currently linearize every inflection-view category.
- The documentation module warns about `Pres` / `Past` renaming ambiguity because both `ResSqi` and `ParamX` expose those atoms.
- `ParadigmsSqi.gf` contains large case-based dispatch logic and scan warnings for untyped case patterns, but it compiles successfully in the provided runs.

These are documentation/tooling constraints, not evidence that the morphology design is invalid.

## 14. Morphology quick reference

### Noun

- table axes: `Species × Case × Number`
- extra field: `Gender`

### Adjective

- lexical axes: `Case × Gender × Number`
- extra field: `clit : Bool`
- AP layer adds `Species`

### Verb

- indicative axes: `Tense × Number × Person`
- extra finite/non-finite series: imperative, participle, optative, admirative

### Pronoun

- axes: `Case`
- extras: accusative clitic, dative clitic, agreement

### Quantifier

- axes: `Case × Gender × Number`
- extra field: `Species`

### Determiner

- axes: `Case × Gender`
- extra fields: `Number`, `Species`

## 15. File-level responsibilities

- `ResSqi.gf` — core morphology-bearing record types and primitive builders
- `MorphoSqi.gf` — low-level inflectional paradigms
- `ParadigmsSqi.gf` — public paradigm selection and lexical builders
- `NounSqi.gf` — determiner/noun/AP-to-CN composition respecting noun morphology
- `AdjectiveSqi.gf` — AP realization, clitic logic, comparison
- `VerbSqi.gf` — verbal predicate-building from full verb paradigms
- `NumeralSqi.gf` — numeral composition
- `DocumentationSqi.gf` — displayed inflection model

## 16. Anti-drift rules

- Never infer Albanian morphology from English-oriented examples.
- Never replace full nominal or adjectival tables with a single citation form in reusable code.
- Never ignore `Species` when touching `CN`, `Det`, or `Quant`.
- Never ignore `clit` when touching lexical adjectives.
- Never treat `Prep` as case-bearing in the type system; case selection is constructor-side in this grammar.
- Prefer paradigm reuse over handcrafted lexical tables.

## 17. Minimum validation checklist

After any morphology-related change, verify at least:

1. noun code still preserves `Species => Case => Number`
2. adjective code still respects `clit`
3. pronoun code preserves case forms and clitics
4. verb code does not destroy the multi-series verb record
5. determinant/quantifier code still agrees with noun gender/number/species
6. no new category-shape warnings appear from flattening morphology-bearing records

## 18. Recommended future expansion

This spec can later be extended with:

- explicit paradigm classes grouped by noun/adjective/verb subtypes
- a section on irregular lexemes and suppletion
- full numeral agreement notes
- a clitic-placement micro-spec
- examples extracted from `ParadigmsSqi.gf`

