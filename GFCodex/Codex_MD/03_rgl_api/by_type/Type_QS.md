# Type: QS

- Meaning: question
- Example: //where did she live//

## Producers (returns this type)
- Count: 1
- [UseQCl](../by_function/UseQCl.md) — `Temp -> Pol -> QCl -> QS`

## Consumers (takes this type as an argument)
- Count: 5
- [ComplVQ](../by_function/ComplVQ.md) — `VQ -> QS -> VP`
- [CompQS](../by_function/CompQS.md) — `QS -> Comp`
- [EmbedQS](../by_function/EmbedQS.md) — `QS -> SC`
- [SlashV2Q](../by_function/SlashV2Q.md) — `V2Q -> QS -> VPSlash`
- [UttQS](../by_function/UttQS.md) — `QS -> Utt`
