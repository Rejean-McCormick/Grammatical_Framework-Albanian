# Type: Quant

- Meaning: quantifier ('nucleus' of Det)
- Example: //this/these//

## Producers (returns this type)
- Count: 4
- [DefArt](../by_function/DefArt.md) — `Quant`
- [GenNP](../by_function/GenNP.md) — `NP -> Quant`
- [IndefArt](../by_function/IndefArt.md) — `Quant`
- [PossPron](../by_function/PossPron.md) — `Pron -> Quant`

## Consumers (takes this type as an argument)
- Count: 2
- [DetQuant](../by_function/DetQuant.md) — `Quant -> Num -> Det`
- [DetQuantOrd](../by_function/DetQuantOrd.md) — `Quant -> Num -> Ord -> Det`
