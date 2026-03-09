# Type: IDet

- Meaning: interrogative determiner
- Example: //how many//

## Producers (returns this type)
- Count: 1
- [IdetQuant](../by_function/IdetQuant.md) — `IQuant -> Num -> IDet`

## Consumers (takes this type as an argument)
- Count: 2
- [IdetCN](../by_function/IdetCN.md) — `IDet -> CN -> IP`
- [IdetIP](../by_function/IdetIP.md) — `IDet -> IP`
