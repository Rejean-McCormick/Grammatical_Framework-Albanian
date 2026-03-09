# Type: Card

- Meaning: cardinal number
- Example: //seven//

## Producers (returns this type)
- Count: 4
- [AdNum](../by_function/AdNum.md) — `AdN -> Card -> Card`
- [NumDigits](../by_function/NumDigits.md) — `Digits -> Card`
- [NumNumeral](../by_function/NumNumeral.md) — `Numeral -> Card`
- [SymbNum](../by_function/SymbNum.md) — `Symb -> Card`

## Consumers (takes this type as an argument)
- Count: 9
- [AdNum](../by_function/AdNum.md) — `AdN -> Card -> Card`
- [CNNumNP](../by_function/CNNumNP.md) — `CN -> Card -> NP`
- [has_age_VP](../by_function/has_age_VP.md) — `Card -> VP`
- [n_units_AP](../by_function/n_units_AP.md) — `Card -> CN -> A -> AP`
- [n_units_of_NP](../by_function/n_units_of_NP.md) — `Card -> CN -> NP -> NP`
- [NumCard](../by_function/NumCard.md) — `Card -> Num`
- [NumPN](../by_function/NumPN.md) — `Card -> PN`
- [timeunitAdv](../by_function/timeunitAdv.md) — `Card -> Timeunit -> Adv`
- [UttCard](../by_function/UttCard.md) — `Card -> Utt`
