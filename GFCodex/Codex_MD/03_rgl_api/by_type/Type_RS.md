# Type: RS

- Meaning: relative
- Example: //in which she lived//

## Producers (returns this type)
- Count: 2
- [ConjRS](../by_function/ConjRS.md) — `Conj -> ListRS -> RS`
- [UseRCl](../by_function/UseRCl.md) — `Temp -> Pol -> RCl -> RS`

## Consumers (takes this type as an argument)
- Count: 6
- [BaseRS](../by_function/BaseRS.md) — `RS -> RS -> ListRS`
- [CleftNP](../by_function/CleftNP.md) — `NP -> RS -> Cl`
- [ConsRS](../by_function/ConsRS.md) — `RS -> ListRS -> ListRS`
- [RelCN](../by_function/RelCN.md) — `CN -> RS -> CN`
- [RelNP](../by_function/RelNP.md) — `NP -> RS -> NP`
- [RelS](../by_function/RelS.md) — `S -> RS -> S`
