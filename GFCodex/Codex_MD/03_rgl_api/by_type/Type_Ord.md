# Type: Ord

- Meaning: ordinal number (used in Det)
- Example: //seventh//

## Producers (returns this type)
- Count: 5
- [OrdDigits](../by_function/OrdDigits.md) — `Digits -> Ord`
- [OrdNumeral](../by_function/OrdNumeral.md) — `Numeral -> Ord`
- [OrdNumeralSuperl](../by_function/OrdNumeralSuperl.md) — `Numeral -> A -> Ord`
- [OrdSuperl](../by_function/OrdSuperl.md) — `A -> Ord`
- [SymbOrd](../by_function/SymbOrd.md) — `Symb -> Ord`

## Consumers (takes this type as an argument)
- Count: 2
- [AdjOrd](../by_function/AdjOrd.md) — `Ord -> AP`
- [DetQuantOrd](../by_function/DetQuantOrd.md) — `Quant -> Num -> Ord -> Det`
