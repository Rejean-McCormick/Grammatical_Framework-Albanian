# ALBANIAN_EXTENDSQI_OVERRIDE_MATRIX

Status: target matrix for the current development cycle  
Scope: `GF/lib/src/albanian/ExtendSqi.gf` and its companion extension modules  
Authority order: current codedump > Albanian architecture docs > `ExtendFunctor` default path > model-language comparison

---

## 1. Fixed architectural decisions

This matrix assumes the following decisions are already locked for this cycle:

- `ExtendSqi.gf` is a **thin coordinator**.
- Companion modules align to `ExtendSqi.gf`, not the other way around.
- The VPS/VPI/VPS2/VPI2/list-family remains **inherited from `ExtendFunctor`** in this cycle.
- No `ExtendSqiVPS.gf` will be introduced in this cycle.
- No local override is accepted unless there is Albanian-specific evidence or a clear structural need.
- Each override family must be coherent as a family; no one-off drift.

---

## 2. Coordinator module

### File
- `GF/lib/src/albanian/ExtendSqi.gf`

### Role
Thin wiring layer only.

### Allowed contents
- subsystem imports
- override subtraction list
- subsystem-to-function renamings

### Disallowed contents
- new local helper logic
- local ad hoc record construction
- local VPS/VPI/VPS2/VPI2/list-family machinery
- repair code that belongs in companion modules

---

## 3. Inherited families for this cycle

These remain inherited from `ExtendFunctor` and must **not** be reintroduced as local Albanian override machinery in `ExtendSqi.gf`.

### Entire inherited family
- `VPS`
- `ListVPS`
- `VPI`
- `ListVPI`
- `VPS2`
- `ListVPS2`
- `VPI2`
- `ListVPI2`
- `X`
- `ListComp`
- `ListImp`

### Inherited functions
- `MkVPS`
- `ConjVPS`
- `PredVPS`
- `SQuestVPS`
- `QuestVPS`
- `RelVPS`
- `MkVPI`
- `ConjVPI`
- `ComplVPIVV`
- `MkVPS2`
- `ConjVPS2`
- `ComplVPS2`
- `ReflVPS2`
- `MkVPI2`
- `ConjVPI2`
- `ComplVPI2`
- `BaseVPS`
- `ConsVPS`
- `BaseVPI`
- `ConsVPI`
- `BaseVPS2`
- `ConsVPS2`
- `BaseVPI2`
- `ConsVPI2`
- `BaseComp`
- `ConsComp`
- `ConjComp`
- `BaseImp`
- `ConsImp`
- `ConjImp`

### Rationale
This family previously failed when it was partially localized. In this cycle, maturity is better served by stable inheritance than by half-complete local machinery.

---

## 4. Override matrix by subsystem

Legend:
- **Owner** = module that must implement the function in this cycle
- **Mode** = `override` or `inherit`
- **Priority** = execution order for this cycle
- **Evidence required** = what must be checked before accepting the implementation

---

### 4.1 Scaffolding subsystem

**Owner modules**
- `GF/lib/src/albanian/ExtendSqiScaffolding.gf`
- `GF/lib/src/albanian/ExtendSqiHelpers.gf`

**Coordinator touchpoint**
- `GF/lib/src/albanian/ExtendSqi.gf`

**Priority**
1

| Function | Mode | Owner | Evidence required | Acceptance rule |
|---|---|---|---|---|
| `GenNP` | override | `ExtendSqiScaffolding.gf` | abstract signature + Albanian lincat shape | no flattening, compiles cleanly |
| `GenIP` | override | `ExtendSqiScaffolding.gf` | signature + current codedump | safe IQuant shape |
| `GenRP` | override | `ExtendSqiScaffolding.gf` | signature + CN/Num ownership | RP shape preserved |
| `GenModNP` | override | `ExtendSqiScaffolding.gf` | signature + Albanian modifier behavior | placeholder only if justified |
| `GenModIP` | override | `ExtendSqiScaffolding.gf` | signature + Albanian modifier behavior | placeholder only if justified |
| `PiedPipingQuestSlash` | override | `ExtendSqiScaffolding.gf` | abstract + current lincats | QS shape preserved |
| `PiedPipingRelSlash` | override | `ExtendSqiScaffolding.gf` | abstract + current lincats | RS shape preserved |
| `StrandQuestSlash` | override | `ExtendSqiScaffolding.gf` | abstract + current lincats | QS shape preserved |
| `StrandRelSlash` | override | `ExtendSqiScaffolding.gf` | abstract + current lincats | RS shape preserved |
| `EmptyRelSlash` | override | `ExtendSqiScaffolding.gf` | abstract + current lincats | RS shape preserved |
| `ProDrop` | override | `ExtendSqiScaffolding.gf` | pronoun record shape | no clitic field loss |
| `AdAdV` | override | `ExtendSqiScaffolding.gf` | AdA/Adv/AdV shapes | no category flattening |
| `PositAdVAdj` | override | `ExtendSqiScaffolding.gf` | `A` category evidence | no wrong resource type leakage |
| `IAdvAdv` | override | `ExtendSqiScaffolding.gf` | IAdv/Adv shapes | safe coercion only |
| `CompS` | override | `ExtendSqiScaffolding.gf` | `Comp` record shape | only valid `Comp` fields |
| `CompQS` | override | `ExtendSqiScaffolding.gf` | `Comp` record shape | only valid `Comp` fields |
| `CompVP` | override | `ExtendSqiScaffolding.gf` | abstract signature + `CommonX` contract | no `TenseSqi` leakage |
| `UttAccIP` | override | `ExtendSqiScaffolding.gf` | `Utt` shape | no lock-field damage |
| `UttDatIP` | override | `ExtendSqiScaffolding.gf` | `Utt` shape | no lock-field damage |
| `UttAccNP` | override | `ExtendSqiScaffolding.gf` | NP case behavior | only valid case use |
| `UttDatNP` | override | `ExtendSqiScaffolding.gf` | NP case behavior | only valid case use |
| `UttAdV` | override | `ExtendSqiScaffolding.gf` | `Utt` shape | safe utterance coercion |
| `UttVPShort` | override | `ExtendSqiScaffolding.gf` | `Utt` shape | safe utterance coercion |
| `ComplBareVS` | override | `ExtendSqiScaffolding.gf` | VS/VP shape | no tense-side drift |
| `SlashBareV2S` | override | `ExtendSqiScaffolding.gf` | VPSlash shape | no partial records |
| `ComplDirectVS` | override | `ExtendSqiScaffolding.gf` | VS/VP/Utt shapes | no partial records |
| `ComplDirectVQ` | override | `ExtendSqiScaffolding.gf` | VQ/VP/Utt shapes | no partial records |
| `FrontComplDirectVS` | override | `ExtendSqiScaffolding.gf` | Cl shape | no partial records |
| `FrontComplDirectVQ` | override | `ExtendSqiScaffolding.gf` | Cl shape | no partial records |
| `PredIAdvVP` | override | `ExtendSqiScaffolding.gf` | QCl shape | no partial records |
| `ApposNP` | override | `ExtendSqiScaffolding.gf` | NP record shape | agreement preserved |
| `ComplGenVV` | override | `ExtendSqiScaffolding.gf` | abstract signature + `CommonX` contract | no `TenseSqi` leakage |
| `CompoundN` | override | `ExtendSqiScaffolding.gf` | N shape | no ad hoc flattening |
| `GerundCN` | override | `ExtendSqiScaffolding.gf` | CN helper ownership | uses helper, not ad hoc CN |
| `GerundNP` | override | `ExtendSqiScaffolding.gf` | NP helper ownership | uses helper, not ad hoc NP |
| `GerundAdv` | override | `ExtendSqiScaffolding.gf` | Adv shape | no wrong-case leakage |
| `UncontractedNeg` | override | `ExtendSqiScaffolding.gf` | abstract signature + polarity record shape | `CommonX`-side contract only |
| `TPastSimple` | override | `ExtendSqiScaffolding.gf` | abstract signature + tense record shape | `CommonX`-side contract only |
| `ComplSlashPartLast` | override | `ExtendSqiScaffolding.gf` | VPSlash/VP/NP shape | no partial records |
| `DetNPMasc` | override | `ExtendSqiScaffolding.gf` | Det/NP agreement | gender agreement preserved |
| `DetNPFem` | override | `ExtendSqiScaffolding.gf` | Det/NP agreement | gender agreement preserved |
| `UseComp_estar` | override | `ExtendSqiScaffolding.gf` | VP/Comp shape | no bogus copula logic |
| `UseComp_ser` | override | `ExtendSqiScaffolding.gf` | VP/Comp shape | no bogus copula logic |
| `SubjRelNP` | override | `ExtendSqiScaffolding.gf` | NP/RS shape | agreement preserved |
| `SubjunctRelCN` | override | `ExtendSqiScaffolding.gf` | CN/RS shape | category shape preserved |

**Required outcome**
This subsystem compiles with no contract-shape errors and no accidental `TenseSqi`/`CommonX` leakage.

---

### 4.2 Existential subsystem

**Owner modules**
- `GF/lib/src/albanian/ExtendSqiExistential.gf`

**Coordinator touchpoint**
- `GF/lib/src/albanian/ExtendSqi.gf`

**Priority**
5

| Function | Mode | Owner | Evidence required | Acceptance rule |
|---|---|---|---|---|
| `ExistS` | override | `ExtendSqiExistential.gf` | abstract signature + constructor path | constructor-based composition |
| `ExistNPQS` | override | `ExtendSqiExistential.gf` | abstract signature + constructor path | constructor-based composition |
| `ExistIPQS` | override | `ExtendSqiExistential.gf` | abstract signature + constructor path | constructor-based composition |
| `ExistCN` | override | `ExtendSqiExistential.gf` | abstract signature + CN behavior | no ad hoc flattening |
| `ExistMassCN` | override | `ExtendSqiExistential.gf` | abstract signature + CN behavior | no ad hoc flattening |
| `ExistPluralCN` | override | `ExtendSqiExistential.gf` | abstract signature + CN behavior | no ad hoc flattening |
| `ExistsNP` | override | `ExtendSqiExistential.gf` | abstract signature + constructor path | constructor-based composition |

---

### 4.3 AP/CN subsystem

**Owner modules**
- `GF/lib/src/albanian/ExtendSqiAPCN.gf`

**Audit spillover modules**
- `GF/lib/src/albanian/AdjectiveSqi.gf`
- `GF/lib/src/albanian/NounSqi.gf`

**Coordinator touchpoint**
- `GF/lib/src/albanian/ExtendSqi.gf`

**Priority**
4

| Function | Mode | Owner | Evidence required | Acceptance rule |
|---|---|---|---|---|
| `ICompAP` | override | `ExtendSqiAPCN.gf` | abstract signature + AP shape | AP shape preserved |
| `CompBareCN` | override | `ExtendSqiAPCN.gf` | abstract signature + CN shape | CN shape preserved |
| `CompIQuant` | override | `ExtendSqiAPCN.gf` | abstract signature + IQuant/Comp behavior | category shape preserved |
| `PredAPVP` | override | `ExtendSqiAPCN.gf` | AP/VP predicate behavior | no flattening |
| `AdjAsCN` | override | `ExtendSqiAPCN.gf` | AP→CN conversion evidence | only justified Albanian conversion |
| `AdjAsNP` | override | `ExtendSqiAPCN.gf` | AP→NP conversion evidence | only justified Albanian conversion |
| `CardCNCard` | override | `ExtendSqiAPCN.gf` | numeral/CN integration | no partial records |

---

### 4.4 Focus/preposition subsystem

**Owner modules**
- `GF/lib/src/albanian/ExtendSqiFocusPrep.gf`

**Audit spillover modules**
- `GF/lib/src/albanian/AdverbSqi.gf`

**Coordinator touchpoint**
- `GF/lib/src/albanian/ExtendSqi.gf`

**Priority**
7

| Function | Mode | Owner | Evidence required | Acceptance rule |
|---|---|---|---|---|
| `FocusObj` | override | `ExtendSqiFocusPrep.gf` | abstract signature + focus behavior | no string-only hacks |
| `FocusAdv` | override | `ExtendSqiFocusPrep.gf` | abstract signature + focus behavior | Adv shape preserved |
| `FocusAdV` | override | `ExtendSqiFocusPrep.gf` | abstract signature + focus behavior | AdV shape preserved |
| `FocusAP` | override | `ExtendSqiFocusPrep.gf` | abstract signature + focus behavior | AP shape preserved |
| `PrepCN` | override | `ExtendSqiFocusPrep.gf` | abstract signature + prep ownership | if shared, migrate logic toward `AdverbSqi` |

---

### 4.5 VP bridge subsystem

**Owner modules**
- `GF/lib/src/albanian/ExtendSqiVPBridge.gf`

**Coordinator touchpoint**
- `GF/lib/src/albanian/ExtendSqi.gf`

**Priority**
3

| Function | Mode | Owner | Evidence required | Acceptance rule |
|---|---|---|---|---|
| `PresPartAP` | override | `ExtendSqiVPBridge.gf` | participial/AP evidence | AP shape preserved |
| `EmbedPresPart` | override | `ExtendSqiVPBridge.gf` | participial embedding evidence | no ad hoc flattening |
| `PastPartAP` | override | `ExtendSqiVPBridge.gf` | participial/AP evidence | AP shape preserved |
| `PastPartAgentAP` | override | `ExtendSqiVPBridge.gf` | participial/AP evidence | AP shape preserved |
| `PassVPSlash` | override | `ExtendSqiVPBridge.gf` | abstract signature + VPSlash shape | no bare record mismatch |
| `PassAgentVPSlash` | override | `ExtendSqiVPBridge.gf` | abstract signature + VPSlash shape | no bare record mismatch |
| `NominalizeVPSlashNP` | override | `ExtendSqiVPBridge.gf` | nominalization evidence | no ad hoc NP construction |
| `ProgrVPSlash` | override | `ExtendSqiVPBridge.gf` | progressive evidence | category shape preserved |
| `A2VPSlash` | override | `ExtendSqiVPBridge.gf` | abstract signature + A2 bridge | no bare record mismatch |
| `N2VPSlash` | override | `ExtendSqiVPBridge.gf` | abstract signature + N2 bridge | no bare record mismatch |
| `AdvIsNP` | override | `ExtendSqiVPBridge.gf` | abstract signature + Adv/NP bridge | no ad hoc flattening |
| `AdvIsNPAP` | override | `ExtendSqiVPBridge.gf` | abstract signature + Adv/AP/NP bridge | no ad hoc flattening |
| `PurposeVP` | override | `ExtendSqiVPBridge.gf` | abstract signature + Adv bridge | no bare record mismatch |
| `WithoutVP` | override | `ExtendSqiVPBridge.gf` | abstract signature + Adv bridge | no bare record mismatch |
| `ByVP` | override | `ExtendSqiVPBridge.gf` | abstract signature + Adv bridge | no bare record mismatch |
| `InOrderToVP` | override | `ExtendSqiVPBridge.gf` | abstract signature + Adv bridge | no bare record mismatch |
| `CompoundAP` | override | `ExtendSqiVPBridge.gf` | abstract signature + AP bridge | AP shape preserved |

---

### 4.6 RNP subsystem

**Owner modules**
- `GF/lib/src/albanian/ExtendSqiRNP.gf`

**Audit spillover modules**
- `GF/lib/src/albanian/NounSqi.gf`

**Coordinator touchpoint**
- `GF/lib/src/albanian/ExtendSqi.gf`

**Priority**
6

| Function | Mode | Owner | Evidence required | Acceptance rule |
|---|---|---|---|---|
| `ReflRNP` | override | `ExtendSqiRNP.gf` | abstract signature + NP/VPSlash shapes | no ad hoc flattening |
| `ReflPron` | override | `ExtendSqiRNP.gf` | pronoun evidence | no partial records |
| `ReflPoss` | override | `ExtendSqiRNP.gf` | possessive/reflexive evidence | agreement preserved |
| `PredetRNP` | override | `ExtendSqiRNP.gf` | predeterminer evidence | NP shape preserved |
| `AdvRNP` | override | `ExtendSqiRNP.gf` | NP/prep attachment evidence | category shape preserved |
| `AdvRVP` | override | `ExtendSqiRNP.gf` | VP/prep attachment evidence | category shape preserved |
| `AdvRAP` | override | `ExtendSqiRNP.gf` | AP/prep attachment evidence | category shape preserved |
| `ReflA2RNP` | override | `ExtendSqiRNP.gf` | AP/reflexive evidence | category shape preserved |
| `PossPronRNP` | override | `ExtendSqiRNP.gf` | possessive pronoun evidence | agreement preserved |
| `ConjRNP` | override | `ExtendSqiRNP.gf` | NP coordination evidence | coherent list behavior |
| `Base_rr_RNP` | override | `ExtendSqiRNP.gf` | list behavior evidence | coherent list behavior |
| `Base_nr_RNP` | override | `ExtendSqiRNP.gf` | list behavior evidence | coherent list behavior |
| `Base_rn_RNP` | override | `ExtendSqiRNP.gf` | list behavior evidence | coherent list behavior |
| `Cons_rr_RNP` | override | `ExtendSqiRNP.gf` | list behavior evidence | coherent list behavior |
| `Cons_nr_RNP` | override | `ExtendSqiRNP.gf` | list behavior evidence | coherent list behavior |

---

### 4.7 Lexical tail subsystem

**Owner modules**
- `GF/lib/src/albanian/ExtendSqiLexicon.gf`

**Coordinator touchpoint**
- `GF/lib/src/albanian/ExtendSqi.gf`

**Priority**
8

| Function | Mode | Owner | Evidence required | Acceptance rule |
|---|---|---|---|---|
| `ReflPossPron` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | syntax clean, quant shape correct |
| `iFem_Pron` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | full pronoun record preserved |
| `youFem_Pron` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | full pronoun record preserved |
| `weFem_Pron` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | full pronoun record preserved |
| `youPlFem_Pron` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | full pronoun record preserved |
| `theyFem_Pron` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | full pronoun record preserved |
| `theyNeutr_Pron` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | full pronoun record preserved |
| `youPolFem_Pron` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | full pronoun record preserved |
| `youPolPl_Pron` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | full pronoun record preserved |
| `youPolPlFem_Pron` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | full pronoun record preserved |
| `UseDAP` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | NP shape preserved |
| `UseDAPMasc` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | NP shape preserved |
| `UseDAPFem` | override | `ExtendSqiLexicon.gf` | lexical ownership evidence | NP shape preserved |

---

## 5. Acceptance checks per subsystem

Every subsystem pass is accepted only if all of the following are true:

1. The companion module compiles with no hard errors.
2. `ExtendSqi.gf` still remains a thin coordinator.
3. No inherited VPS/VPI/VPS2/VPI2/list-family machinery has been reintroduced.
4. No category has been flattened to `Str` unless the Albanian lincat is truly string-shaped.
5. No new lock-field warnings are introduced.
6. No override is justified only by convenience; every override must have Albanian or structural evidence.
7. The family remains coherent as a family.

---

## 6. Current cycle execution order

1. Scaffolding boundary (`ExtendSqiScaffolding.gf`, `ExtendSqiHelpers.gf`)
2. Coordinator lock (`ExtendSqi.gf`)
3. VP bridge (`ExtendSqiVPBridge.gf`)
4. AP/CN (`ExtendSqiAPCN.gf`)
5. Existentials (`ExtendSqiExistential.gf`)
6. RNP (`ExtendSqiRNP.gf`)
7. Focus/prep (`ExtendSqiFocusPrep.gf`)
8. Lexical tail (`ExtendSqiLexicon.gf`)
9. Structural cleanup outside `Extend` (`StructuralSqi.gf`, `StructuralSqiClause.gf`)
10. Full validation through `GrammarSqi` and `SyntaxSqi`

---

## 7. What is not allowed in this cycle

- Reintroducing local `MkVPS` / `BaseVPS` / `BaseComp` / `BaseImp` machinery into `ExtendSqi.gf`
- Creating `ExtendSqiVPS.gf`
- Fixing a family by scattering ad hoc helpers into unrelated modules
- Accepting compile success if it depends on category-shape drift
- Leaving warnings unexplained in high-risk families

---

## 8. Final target state

At the end of this cycle:

- `ExtendSqi.gf` is a stable thin coordinator.
- Every local override belongs to one of the canonical companion modules.
- The VPS/VPI/VPS2/VPI2/list-family remains inherited and stable.
- All companion modules compile cleanly.
- Structural warnings are reduced to the point that Albanian behaves like a mature GF language rather than an exploratory extension layer.
