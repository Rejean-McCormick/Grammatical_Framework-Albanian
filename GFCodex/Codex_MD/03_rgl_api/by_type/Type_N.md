# Type: N

- Meaning: common noun
- Example: //house//

## Producers (returns this type)
- Count: 3
- [CompoundN](../by_function/CompoundN.md) — `N -> N -> N`
- [monthN](../by_function/monthN.md) — `Month -> N`
- [weekdayN](../by_function/weekdayN.md) — `Weekday -> N`

## Consumers (takes this type as an argument)
- Count: 3
- [CompoundAP](../by_function/CompoundAP.md) — `N -> A -> AP`
- [CompoundN](../by_function/CompoundN.md) — `N -> N -> N`
- [UseN](../by_function/UseN.md) — `N -> CN`
