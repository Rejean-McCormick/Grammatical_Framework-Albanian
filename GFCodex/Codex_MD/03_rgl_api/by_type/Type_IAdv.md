# Type: IAdv

- Meaning: interrogative adverb
- Example: //why//

## Producers (returns this type)
- Count: 4
- [AdvIAdv](../by_function/AdvIAdv.md) — `IAdv -> Adv -> IAdv`
- [ConjIAdv](../by_function/ConjIAdv.md) — `Conj -> ListIAdv -> IAdv`
- [IAdvAdv](../by_function/IAdvAdv.md) — `Adv -> IAdv`
- [PrepIP](../by_function/PrepIP.md) — `Prep -> IP -> IAdv`

## Consumers (takes this type as an argument)
- Count: 8
- [AddAdvQVP](../by_function/AddAdvQVP.md) — `QVP -> IAdv -> QVP`
- [AdvIAdv](../by_function/AdvIAdv.md) — `IAdv -> Adv -> IAdv`
- [AdvQVP](../by_function/AdvQVP.md) — `VP -> IAdv -> QVP`
- [BaseIAdv](../by_function/BaseIAdv.md) — `IAdv -> IAdv -> ListIAdv`
- [CompIAdv](../by_function/CompIAdv.md) — `IAdv -> IComp`
- [ConsIAdv](../by_function/ConsIAdv.md) — `IAdv -> ListIAdv -> ListIAdv`
- [QuestIAdv](../by_function/QuestIAdv.md) — `IAdv -> Cl -> QCl`
- [UttIAdv](../by_function/UttIAdv.md) — `IAdv -> Utt`
