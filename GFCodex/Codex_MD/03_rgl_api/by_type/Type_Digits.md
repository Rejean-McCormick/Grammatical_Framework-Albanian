# Type: Digits

- Meaning: cardinal or ordinal in digits
- Example: //1,000/1,000th//

## Producers (returns this type)
- Count: 2
- [IDig](../by_function/IDig.md) — `Dig -> Digits`
- [IIDig](../by_function/IIDig.md) — `Dig -> Digits -> Digits`

## Consumers (takes this type as an argument)
- Count: 3
- [IIDig](../by_function/IIDig.md) — `Dig -> Digits -> Digits`
- [NumDigits](../by_function/NumDigits.md) — `Digits -> Card`
- [OrdDigits](../by_function/OrdDigits.md) — `Digits -> Ord`
