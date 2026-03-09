# Type: SC

- Meaning: embedded sentence or question
- Example: //that it rains//

## Producers (returns this type)
- Count: 4
- [EmbedPresPart](../by_function/EmbedPresPart.md) — `VP -> SC`
- [EmbedQS](../by_function/EmbedQS.md) — `QS -> SC`
- [EmbedS](../by_function/EmbedS.md) — `S -> SC`
- [EmbedVP](../by_function/EmbedVP.md) — `VP -> SC`

## Consumers (takes this type as an argument)
- Count: 3
- [PredSCVP](../by_function/PredSCVP.md) — `SC -> VP -> Cl`
- [SentAP](../by_function/SentAP.md) — `AP -> SC -> AP`
- [SentCN](../by_function/SentCN.md) — `CN -> SC -> CN`
