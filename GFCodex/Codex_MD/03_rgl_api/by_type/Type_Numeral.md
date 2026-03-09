# Type: Numeral

- Meaning: cardinal or ordinal in words
- Example: //five/fifth//

## Producers (returns this type)
- Count: 1
- [num](../by_function/num.md) — `Sub1000000 -> Numeral`

## Consumers (takes this type as an argument)
- Count: 3
- [NumNumeral](../by_function/NumNumeral.md) — `Numeral -> Card`
- [OrdNumeral](../by_function/OrdNumeral.md) — `Numeral -> Ord`
- [OrdNumeralSuperl](../by_function/OrdNumeralSuperl.md) — `Numeral -> A -> Ord`
