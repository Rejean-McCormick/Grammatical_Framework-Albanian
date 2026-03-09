# Type: Det

- Meaning: determiner phrase
- Example: //those seven//

## Producers (returns this type)
- Count: 3
- [ConjDet](../by_function/ConjDet.md) — `Conj -> ListDAP -> Det`
- [DetQuant](../by_function/DetQuant.md) — `Quant -> Num -> Det`
- [DetQuantOrd](../by_function/DetQuantOrd.md) — `Quant -> Num -> Ord -> Det`

## Consumers (takes this type as an argument)
- Count: 5
- [CNSymbNP](../by_function/CNSymbNP.md) — `Det -> CN -> [Symb] -> NP`
- [CountNP](../by_function/CountNP.md) — `Det -> NP -> NP`
- [DetCN](../by_function/DetCN.md) — `Det -> CN -> NP`
- [DetDAP](../by_function/DetDAP.md) — `Det -> DAP`
- [DetNP](../by_function/DetNP.md) — `Det -> NP`
