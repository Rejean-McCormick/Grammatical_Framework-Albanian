# Type: Pol

- Meaning: polarity
- Example: positive, negative

## Producers (returns this type)
- Count: 3
- [PNeg](../by_function/PNeg.md) — `Pol`
- [PPos](../by_function/PPos.md) — `Pol`
- [UncontractedNeg](../by_function/UncontractedNeg.md) — `Pol`

## Consumers (takes this type as an argument)
- Count: 12
- [ComplGenVV](../by_function/ComplGenVV.md) — `VV -> Ant -> Pol -> VP -> VP`
- [CompVP](../by_function/CompVP.md) — `Ant -> Pol -> VP -> Comp`
- [MkVPS](../by_function/MkVPS.md) — `Temp -> Pol -> VP -> VPS`
- [MkVPS2](../by_function/MkVPS2.md) — `Temp -> Pol -> VPSlash -> VPS2`
- [SlashV2V (overload 1)](../by_function/SlashV2V__01.md) — `V2V -> Ant -> Pol -> VPS -> VPSlash`
- [UseCl](../by_function/UseCl.md) — `Temp -> Pol -> Cl -> S`
- [UseQCl](../by_function/UseQCl.md) — `Temp -> Pol -> QCl -> QS`
- [UseRCl](../by_function/UseRCl.md) — `Temp -> Pol -> RCl -> RS`
- [UseSlash](../by_function/UseSlash.md) — `Temp -> Pol -> ClSlash -> SSlash`
- [UttImpPl](../by_function/UttImpPl.md) — `Pol -> Imp -> Utt`
- [UttImpPol](../by_function/UttImpPol.md) — `Pol -> Imp -> Utt`
- [UttImpSg](../by_function/UttImpSg.md) — `Pol -> Imp -> Utt`
