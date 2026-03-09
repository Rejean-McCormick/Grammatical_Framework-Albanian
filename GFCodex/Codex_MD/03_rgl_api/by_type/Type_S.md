# Type: S

- Meaning: declarative sentence
- Example: //she lived here//

## Producers (returns this type)
- Count: 9
- [AdvS](../by_function/AdvS.md) — `Adv -> S -> S`
- [ConjS](../by_function/ConjS.md) — `Conj -> ListS -> S`
- [ExtAdvS](../by_function/ExtAdvS.md) — `Adv -> S -> S`
- [ModSubjS](../by_function/ModSubjS.md) — `S -> Subj -> S -> S`
- [PredVPS](../by_function/PredVPS.md) — `NP -> VPS -> S`
- [RelS](../by_function/RelS.md) — `S -> RS -> S`
- [SSubjS](../by_function/SSubjS.md) — `S -> Subj -> S -> S`
- [SymbS](../by_function/SymbS.md) — `Symb -> S`
- [UseCl](../by_function/UseCl.md) — `Temp -> Pol -> Cl -> S`

## Consumers (takes this type as an argument)
- Count: 19
- [AdvS](../by_function/AdvS.md) — `Adv -> S -> S`
- [BaseS](../by_function/BaseS.md) — `S -> S -> ListS`
- [CleftAdv](../by_function/CleftAdv.md) — `Adv -> S -> Cl`
- [ComparAdvAdjS](../by_function/ComparAdvAdjS.md) — `CAdv -> A -> S -> Adv`
- [ComplBareVS](../by_function/ComplBareVS.md) — `VS -> S -> VP`
- [ComplVS](../by_function/ComplVS.md) — `VS -> S -> VP`
- [CompS](../by_function/CompS.md) — `S -> Comp`
- [ConsS](../by_function/ConsS.md) — `S -> ListS -> ListS`
- [EmbedS](../by_function/EmbedS.md) — `S -> SC`
- [ExtAdvS](../by_function/ExtAdvS.md) — `Adv -> S -> S`
- [FocusAdV](../by_function/FocusAdV.md) — `AdV -> S -> Utt`
- [FocusAdv](../by_function/FocusAdv.md) — `Adv -> S -> Utt`
- [ModSubjS](../by_function/ModSubjS.md) — `S -> Subj -> S -> S`
- [RelS](../by_function/RelS.md) — `S -> RS -> S`
- [SlashBareV2S](../by_function/SlashBareV2S.md) — `V2S -> S -> VPSlash`
- [SlashV2S](../by_function/SlashV2S.md) — `V2S -> S -> VPSlash`
- [SSubjS](../by_function/SSubjS.md) — `S -> Subj -> S -> S`
- [SubjS](../by_function/SubjS.md) — `Subj -> S -> Adv`
- [UttS](../by_function/UttS.md) — `S -> Utt`
