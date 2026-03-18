# ALBANIAN_EVIDENCE_APPENDIX

## Purpose

This appendix collects the raw evidence that supports the Albanian language documentation set. It is not the place for policy decisions or interpretation-heavy design advice. Its job is to preserve the source facts, representative code excerpts, and debugging signals that the higher-level documents rely on.

This appendix is aligned to the uploaded Albanian codedump and the additional uploaded reference files in this conversation:

- `AlbanianGF_codedump.txt`
- `Extend.gf`
- `ExtendFunctor.gf`
- `GFCodex.txt`
- `Bulgarian.txt`
- `GermanGF_Codedump.txt`
- `ErrorLogAlbanian.txt`
- run logs from the March 17, 2026 debugging sequence

---

## 1. Source set and trust order

### 1.1 Primary Albanian sources

These are the authoritative sources for Albanian facts.

1. `albanian/CatSqi.gf`
2. `albanian/ResSqi.gf`
3. Albanian core syntax modules such as:
   - `albanian/NounSqi.gf`
   - `albanian/AdjectiveSqi.gf`
   - `albanian/VerbSqi.gf`
   - `albanian/SentenceSqi.gf`
   - `albanian/QuestionSqi.gf`
   - `albanian/ConjunctionSqi.gf`
   - `albanian/IdiomSqi.gf`
   - `albanian/StructuralSqi.gf`
4. Albanian extension/debugging modules:
   - `albanian/ExtendSqi.gf`
   - `albanian/ExtraSqi.gf`

### 1.2 Cross-language and API references

These are reference sources, not Albanian truth sources.

1. `Extend.gf`
2. `ExtendFunctor.gf`
3. `Bulgarian.txt`
4. `GermanGF_Codedump.txt`
5. `GFCodex.txt`

### 1.3 Debugging evidence

These establish what failed, when, and why.

- `ErrorLogAlbanian.txt`
- `run_20260317_084411_20260317_084437_02_raw.txt`
- `run_20260317_110213_20260317_110241_02_raw.txt`
- `run_20260317_143053_20260317_143145_02_raw.txt`

---

## 2. Albanian top-level architecture evidence

### 2.1 Public constructor surface: `SyntaxSqi`

**Source:** `SyntaxSqi.gf` in the root volume of the Albanian dump.

```gf
resource SyntaxSqi = open Prelude, Predef,
  CatSqi, ResSqi,
  NounSqi, AdjectiveSqi, PhraseSqi, StructuralSqi
in {

oper
  mkCN : N -> CN = UseN ;
  mkCN : AP -> CN -> CN = AdjCN ;
```

**Use:** Evidence that Albanian exposes a constructor-oriented public layer and that `SyntaxSqi` is meant to sit on top of `CatSqi`, `ResSqi`, and the main syntax modules.

### 2.2 Grammar aggregation: `GrammarSqi`

**Source:** `albanian/GrammarSqi.gf`

```gf
concrete GrammarSqi of Grammar =
  NounSqi,
  AdjectiveSqi,
  NumeralSqi,
  VerbSqi,
  SentenceSqi-[sep],
  QuestionSqi-[sep],
  RelativeSqi,
  ConjunctionSqi,
  IdiomSqi,
  TextSqi,
  PhraseSqi
  ** {
} ;
```

**Use:** Evidence for the actual Albanian core module spine.

---

## 3. Category and lincat evidence

### 3.1 Core category shapes from `CatSqi.gf`

**Source:** `albanian/CatSqi.gf`

```gf
lincat Prep = Compl ;

lincat IComp  = {s : Str} ;
lincat IP     = {s : Str} ;
lincat IDet   = {s : Str} ;
lincat IQuant = {s : Str} ;

lincat S       = {s : Str} ;
lincat QS      = {s : Str} ;
lincat RS      = {s : Str} ;
lincat SSlash  = {s : Str} ;
lincat Cl      = {s : Str} ;
lincat QCl     = {s : Str} ;
lincat RCl     = {s : Str} ;
lincat RP      = {s : Str} ;
lincat ClSlash = {s : Str} ;

lincat VP      = {s : Str} ;
lincat VPSlash = {s : Str} ;
lincat Comp    = {s : Str} ;

lincat AP    = {s : Species => Case => Gender => Number => Str} ;
lincat CN    = Noun ;
lincat Num   = {s : Str; n : Number} ;
lincat Quant = {s : Case => Gender => Number => Str; spec : Species} ;
lincat Det   = {s : Case => Gender => Str; spec : Species; n : Number} ;
lincat NP    = {s : Case => Str; a : Agr} ;
lincat Pron  = {s : Case => Str; acc_clit, dat_clit : Str; a : Agr} ;
```

**Use:** This is the primary evidence for the crucial Albanian split between string-valued clause/verb categories and structured nominal/adjectival categories.

### 3.2 Shared resource structures from `ResSqi.gf`

**Source:** `albanian/ResSqi.gf`

```gf
oper
  Compl : Type = {s : Str} ;

  mkCompl : Str -> Compl = \s -> {s = s} ;

  -- In CatSqi: Prep = Compl
  Prep : Type = Compl ;
  mkPrep : Str -> Prep = mkCompl ;
  noPrep : Prep = mkPrep [] ;
```

```gf
param
  Species = Indef | Def ;
  Case = Nom | Acc | Dat | Ablat ;
  Gender = Masc | Fem ;
```

```gf
oper
  Noun : Type = {s : Species => Case => Number => Str ; g : Gender} ;
```

```gf
oper
  Adj : Type = {s : Case => Gender => Number => Str ; clit : Bool} ;
```

**Use:** Evidence for Albanian `Prep`, `Noun`, `Adj`, and the main inflectional parameters.

---

## 4. Albanian core implementation patterns

### 4.1 Common noun composition from `NounSqi.gf`

**Source:** `albanian/NounSqi.gf`

```gf
DetCN det cn = {
  s = \\c => det.s ! c ! cn.g ++ cn.s ! det.spec ! c ! det.n ;
  a = agrgP3 cn.g det.n
  } ;
```

```gf
AdjCN ap cn = {
  s = \\spec,c,n => cn.s ! spec ! c ! n ++ ap.s ! spec ! c ! cn.g ! n ;
  g = cn.g
  } ;
```

**Use:** Evidence that Albanian preserves full noun-table shape when building `CN`.

### 4.2 Adjective phrase composition from `AdjectiveSqi.gf`

**Source:** `albanian/AdjectiveSqi.gf`

```gf
PositA a = {
  s = \\spec,c,g,n =>
        case a.clit of {
          True  => link_clitic ! spec ! c ! g ! n ++ a.s ! c ! g ! n ;
          False => a.s ! c ! g ! n
        }
} ;
```

```gf
ComplA2 a2 np = {
  s = \\spec,c,g,n =>
        (UseA2 a2).s ! spec ! c ! g ! n ++ a2.c2.s ++ np.s ! Acc
} ;
```

```gf
SentAP ap sc = {
  s = \\spec,c,g,n => ap.s ! spec ! c ! g ! n ++ "që" ++ sc.s
} ;
```

**Use:** Evidence that Albanian AP is a full agreement table and that AP-building functions preserve that shape.

### 4.3 Prepositional behavior from `AdverbSqi.gf`

**Source:** `albanian/AdverbSqi.gf`

```gf
npAfterPrep : CatSqi.Prep -> NP -> Str = \_,np ->
  np.s ! Acc ;
```

```gf
PrepNP p np = {s = p.s ++ npAfterPrep p np} ;
```

**Use:** Evidence that Albanian currently chooses accusative after prepositions and treats `Prep` as surface-string-like.

### 4.4 Bare noun helper from `ExtraSqi.gf`

**Source:** `albanian/ExtraSqi.gf`

```gf
cnBare : CN -> Str =
  \cn -> cn.s ! Indef ! Acc ! Sg ;
```

```gf
PrepCN prep cn = {s = prep.s ++ cnBare cn} ;
```

**Use:** Evidence for one Albanian fallback strategy for prep-plus-bare-noun constructions.

### 4.5 Existentials and idioms from `IdiomSqi.gf`

**Source:** `albanian/IdiomSqi.gf`

```gf
ExistIP ip =
  {s = ip.s ++ existV} ;

ExistNP np =
  {s = existV ++ idiomNpNom np} ;

ImpersCl vp =
  {s = vp.s} ;

ProgrVP vp =
  vp ** {s = progPart ++ vp.s} ;
```

**Use:** Evidence that the idiom layer already contains Albanian existential and impersonal defaults.

### 4.6 Clause assembly from `SentenceSqi.gf`

**Source:** `albanian/SentenceSqi.gf`

```gf
PredVP np vp       = {s = np.s ! Nom ++ sep ++ vp.s} ;
UseCl temp pol cl  = {s = cl.s} ;
UseQCl temp pol qcl = {s = qcl.s} ;
EmbedVP vp         = {s = vp.s} ;
```

**Use:** Evidence that many Albanian clausal categories are intentionally string-valued at the sentence layer.

### 4.7 Question defaults from `QuestionSqi.gf`

**Source:** `albanian/QuestionSqi.gf`

```gf
CompIP ip =
  {s = ip.s} ;
```

```gf
IdetCN idet cn =
  {s = idet.s ++ sep ++ cn.s ! Indef ! Nom ! Sg} ;
```

```gf
QuestCl cl =
  {s = cl.s} ;
```

**Use:** Evidence for how Albanian question syntax collapses some interrogative structures to strings while still reading full noun tables where needed.

### 4.8 Coordination preserves shape from `ConjunctionSqi.gf`

**Source:** `albanian/ConjunctionSqi.gf`

Representative patterns:

```gf
BaseNP x y =
  { init = \\c => x.s ! c ;
    last = \\c => y.s ! c ;
    a = x.a
  } ;
```

```gf
BaseCN x y =
  { init = \\sp,cse,n => x.s ! sp ! cse ! n ;
    last = \\sp,cse,n => y.s ! sp ! cse ! n ;
    g = x.g
  } ;
```

```gf
BaseAP x y =
  { init = \\sp,cse,g,n => x.s ! sp ! cse ! g ! n ;
    last = \\sp,cse,g,n => y.s ! sp ! cse ! g ! n
  } ;
```

**Use:** Evidence that Albanian list categories preserve the internal shape of the coordinated category.

### 4.9 Structural inventory from `StructuralSqi.gf`

**Source:** `albanian/StructuralSqi.gf`

Representative exports:

```gf
above_Prep = SC.above_Prep ;
after_Prep = SC.after_Prep ;
in_Prep = SC.in_Prep ;
on_Prep = SC.on_Prep ;
with_Prep = SC.with_Prep ;
without_Prep = SC.without_Prep ;
```

**Use:** Evidence that the Albanian structural lexicon delegates many fixed functional items through dedicated structural submodules.

---

## 5. Extend API evidence

### 5.1 Exact abstract signatures from `Extend.gf`

**Source:** `Extend.gf`

```gf
CompBareCN  : CN -> Comp ;
```

```gf
ExistS     : Temp -> Pol -> NP -> S ;
ExistNPQS  : Temp -> Pol -> NP -> QS ;
ExistIPQS  : Temp -> Pol -> IP -> QS ;
```

```gf
PrepCN     : Prep -> CN -> Adv ;
```

```gf
PredAPVP : AP -> VP -> Cl ;
```

```gf
AdjAsCN : AP -> CN ;
AdjAsNP : AP -> NP ;
```

```gf
ReflPoss : Num -> CN -> RNP ;
```

**Use:** Evidence for the exact abstract target categories. This is the source that settles category disputes.

### 5.2 Default implementation evidence from `ExtendFunctor.gf`

**Source:** `ExtendFunctor.gf`

```gf
lincat
  RNP = Grammar.NP ;
  RNPList = Grammar.ListNP ;
```

```gf
CompBareCN cn = CompCN cn ;
```

```gf
CompIQuant iquant = CompIP (IdetIP (IdetQuant iquant NumSg)) ;
```

```gf
PrepCN prep cn = PrepNP prep (MassNP cn) ;
```

```gf
ExistsNP = ExistNP ;
ExistCN cn = ExistNP (DetCN (DetQuant IndefArt NumSg) cn) ;
ExistMassCN cn = ExistNP (MassNP cn) ;
ExistPluralCN cn = ExistNP (DetCN (DetQuant IndefArt NumPl) cn) ;
```

```gf
AdvIsNP adv np = PredVP np (UseComp (CompAdv adv)) ;
AdvIsNPAP adv np ap = PredVP np (AdvVP (UseComp (CompAP ap)) adv) ;
```

```gf
PredAPVP ap vp = ImpersCl (UseComp (CompAP (SentAP ap (EmbedVP vp)))) ;
```

```gf
ExistS t p np = UseCl t p (ExistNP np) ;
ExistNPQS t p np = UseQCl t p (QuestCl (ExistNP np)) ;
ExistIPQS t p np = UseQCl t p (ExistIP np) ;
```

**Use:** Evidence for what should be inherited or mirrored compositionally rather than re-invented in `ExtendSqi`.

---

## 6. Current Albanian extension evidence

### 6.1 Current override surface from `albanian/ExtendSqi.gf`

**Source:** `albanian/ExtendSqi.gf`

Representative facts visible in the uploaded snapshot:

- `ExtendSqi` is instantiated as `CatSqi ** ExtendFunctor - [ ... ] with (Grammar = GrammarSqi)`.
- It removes and overrides many families at once, including:
  - existentials,
  - focus constructions,
  - AP/CN conversion functions,
  - `PrepCN`,
  - `PredAPVP`,
  - `AdjAsCN`,
  - `AdjAsNP`,
  - the full `RNP` family.

**Use:** Evidence that `ExtendSqi` is a coordinated override zone rather than a place for isolated one-off patches.

### 6.2 Snapshot helpers in `ExtendSqi`

Representative helper patterns in the uploaded snapshot include:

```gf
cnStr : CN -> Str = \cn -> cn.s ! Indef ! Nom ! Sg ;
apStr : AP -> Str = \ap -> ap.s ! Indef ! Nom ! Masc ! Sg ;
```

```gf
apConst : Str -> AP =
  \w -> lin AP {s = \\spec,cas,g,n => w} ;
```

```gf
cnConst : Str -> Gender -> CN =
  \w,g -> lin CN {s = \\spec,cas,n => w ; g = g} ;
```

**Use:** Evidence for the flattening helpers that repeatedly caused later drift and lock-field warnings.

---

## 7. Model-language evidence

### 7.1 Bulgarian as the minimal RNP subsystem reference

**Source:** `Bulgarian.txt`

Representative excerpts:

```gf
ReflPron =
      { s  = \\role => "себе си";
        gn = GSg Masc;
        isPron = True
      } ;
```

```gf
ReflPoss num cn =
      { s = \\role => ... ;
        ...
      } ;
```

```gf
PredetRNP pred rnp = {
    s  = \\c => pred.s ! rnp.gn ++ rnp.s ! c ;
    gn = rnp.gn ;
    isPron = False
  } ;
```

**Use:** Evidence that the reflexive noun phrase family is a coherent subsystem in at least one relatively compact model language and should not be debugged function-by-function in isolation.

### 7.2 German as the richer subsystem reference

**Source:** `GermanGF_Codedump.txt`

Representative excerpt:

```gf
PrepCN prep cn = {
      s = prep.s ! GPl ++ cn.s ! Strong ! Sg ! prep.c ++ cn.adv ++ cn.rc ! Sg ++ cn.ext} ;
```

**Use:** Evidence that model languages preserve the full target category shape when they truly customize a subsystem.

---

## 8. Codex guidance evidence

**Source:** `GFCodex.txt`

```text
### Overloads (critical)
- Never choose overloads by name alone.
- Choose overload by matching the **full** `Type:` signature:
  - argument sequence (left of arrows) and return type (rightmost).
- If multiple overloads still match, prefer the one whose `Module:` aligns with the target language/module context.
```

**Use:** Evidence for the anti-drift rule that constructor choice must be based on exact signature and module context, not intuition or name resemblance.

---

## 9. Debugging chronology evidence

### 9.1 Initial hard issue: `PrepCN`

The early run state centered on `PrepCN` in `ExtendSqi.gf`. Later analysis and the uploaded `Extend.gf`/`ExtendFunctor.gf` established that `PrepCN` returns `Adv`, not `CN`, and that the default functor composition is `PrepNP prep (MassNP cn)`.

Relevant evidence:

- `Extend.gf`: `PrepCN : Prep -> CN -> Adv`
- `ExtendFunctor.gf`: `PrepCN prep cn = PrepNP prep (MassNP cn)`
- `AdverbSqi.gf`: `PrepNP p np = {s = p.s ++ npAfterPrep p np}` with accusative after prepositions
- `ExtraSqi.gf`: `cnBare : CN -> Str = \cn -> cn.s ! Indef ! Acc ! Sg`

### 9.2 Next hard issue: `ReflPoss` and `RNP`

The run from `08:44` reports:

```text
file_done=...ExtendSqi.gf exit_code=1 ... first_error=Happened in linearization of ReflPoss
```

The abstract and functor evidence showed:

- `ReflPoss : Num -> CN -> RNP`
- `RNP = Grammar.NP`
- `RNPList = Grammar.ListNP`

This established that Albanian’s flattened local `RNP = {s : Str}` strategy was misaligned with the default API.

### 9.3 Then: `RNPList` constructors

The run from `11:02` reports:

```text
Happened in linearization of Base_rr_RNP
  {init = \c => r1.s ! c; last = \c => r2.s ! c;
   a = r1.a} is not in the lincat of ListNP; try wrapping it with lin ListNP
```

**Use:** Evidence that once `RNP = NP` / `RNPList = ListNP` was restored, the remaining fix was to align the constructors to `ListNP` shape.

### 9.4 Current cluster: existentials, AP/CN locks, and `PredAPVP`

The latest uploaded run reports:

```text
Happened in linearization of ExistS
  record type expected in type checking instead of
    {s : Case => Str; a : {gn : GenNum; p : Person}} -> {s : Str}
```

```text
Happened in linearization of ExistNPQS
  record type expected in type checking instead of
    {s : Case => Str; a : {gn : GenNum; p : Person}} -> {s : Str}
```

```text
Happened in linearization of ExistIPQS
  record type expected in type checking instead of
    {s : Str} -> {s : Str}
```

```text
Happened in linearization of PredAPVP
  expected: {s : Str}
  inferred: {s : ResSqi.Species => ResSqi.Case => ParamX.Gender => ParamX.Number => Str; ...}
```

```text
Happened in linearization of CardCNCard
  missing record fields: s ...
  expected: {s : Str}
  inferred: {s : ResSqi.Species => ResSqi.Case => ParamX.Number => Str;
             g : ResSqi.Gender; lock_CN : {}}
```

The same latest run also reports:

- `CompBareCN` warning: missing `lock_CN`
- `AdvIsNPAP` warning: missing `lock_AP`
- `AdjAsNP` warning: missing `lock_AP`
- `AdjAsCN` warning: missing `lock_AP`
- `CompoundAP` warning: missing `lock_CN`

**Use:** Evidence that the active remaining issue is broader category-shape drift in the AP/CN/existential zone, not just one line.

---

## 10. Derived evidence statements for documentation authors

These statements are supported directly by the sources above and are safe to reuse in the main Albanian documentation set.

1. Albanian `CN` is not a flat string category; it is `Noun` with `s : Species => Case => Number => Str` and `g : Gender`.
2. Albanian `AP` is not a flat string category; it is a four-dimensional agreement table.
3. Albanian `Prep` is surface-string-like because `Prep = Compl = {s : Str}`.
4. Albanian commonly chooses accusative after prepositions in the current grammar snapshot.
5. Clause-level categories such as `Cl`, `QCl`, `S`, `VP`, and `Comp` are often intentionally string-valued in `CatSqi`.
6. `ExtendSqi` is an override surface over `ExtendFunctor`, not an independent base grammar.
7. When `ExtendFunctor` already provides a compositional implementation, Albanian should usually inherit or mirror that composition before inventing a local rewrite.
8. The `RNP` family must be treated as one subsystem.
9. Missing `lock_AP` / `lock_CN` warnings are evidence of category-shape mistakes, not merely cosmetic warnings.
10. Exact signature and module context must control constructor choice.

---

## 11. Maintenance notes for this appendix

When adding new evidence:

- prefer exact code excerpts over paraphrase,
- keep excerpts short and representative,
- record the source file name exactly,
- separate Albanian facts from model-language references,
- and record debugging evidence chronologically when it reflects design lessons.

If a main documentation file makes a strong architectural or implementation claim, that claim should be traceable back to one or more sections in this appendix.
