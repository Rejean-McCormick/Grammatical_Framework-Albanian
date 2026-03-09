# Type: RCl

- Meaning: relative clause, with all tenses
- Example: //in which she lives//

## Producers (returns this type)
- Count: 5
- [EmptyRelSlash](../by_function/EmptyRelSlash.md) — `ClSlash -> RCl`
- [RelCl](../by_function/RelCl.md) — `Cl -> RCl`
- [RelSlash](../by_function/RelSlash.md) — `RP -> ClSlash -> RCl`
- [RelVP](../by_function/RelVP.md) — `RP -> VP -> RCl`
- [StrandRelSlash](../by_function/StrandRelSlash.md) — `RP -> ClSlash -> RCl`

## Consumers (takes this type as an argument)
- Count: 1
- [UseRCl](../by_function/UseRCl.md) — `Temp -> Pol -> RCl -> RS`
