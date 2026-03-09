# Type: Num

- Meaning: number determining element
- Example: //seven//

## Producers (returns this type)
- Count: 3
- [NumCard](../by_function/NumCard.md) — `Card -> Num`
- [NumPl](../by_function/NumPl.md) — `Num`
- [NumSg](../by_function/NumSg.md) — `Num`

## Consumers (takes this type as an argument)
- Count: 7
- [DetQuant](../by_function/DetQuant.md) — `Quant -> Num -> Det`
- [DetQuantOrd](../by_function/DetQuantOrd.md) — `Quant -> Num -> Ord -> Det`
- [GenModIP](../by_function/GenModIP.md) — `Num -> IP -> CN -> IP`
- [GenModNP](../by_function/GenModNP.md) — `Num -> NP -> CN -> NP`
- [GenRP](../by_function/GenRP.md) — `Num -> CN -> RP`
- [IdetQuant](../by_function/IdetQuant.md) — `IQuant -> Num -> IDet`
- [ReflPoss](../by_function/ReflPoss.md) — `Num -> CN -> RNP`
