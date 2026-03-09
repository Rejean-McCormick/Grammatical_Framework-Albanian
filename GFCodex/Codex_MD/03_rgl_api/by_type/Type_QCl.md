# Type: QCl

- Meaning: question clause, with all tenses
- Example: //why does she walk//

## Producers (returns this type)
- Count: 12
- [ExistIP](../by_function/ExistIP.md) — `IP -> QCl`
- [ExistIPAdv](../by_function/ExistIPAdv.md) — `IP -> Adv -> QCl`
- [how_far_QCl](../by_function/how_far_QCl.md) — `NP -> QCl`
- [how_old_QCl](../by_function/how_old_QCl.md) — `NP -> QCl`
- [QuestCl](../by_function/QuestCl.md) — `Cl -> QCl`
- [QuestIAdv](../by_function/QuestIAdv.md) — `IAdv -> Cl -> QCl`
- [QuestIComp](../by_function/QuestIComp.md) — `IComp -> NP -> QCl`
- [QuestQVP](../by_function/QuestQVP.md) — `IP -> QVP -> QCl`
- [QuestSlash](../by_function/QuestSlash.md) — `IP -> ClSlash -> QCl`
- [QuestVP](../by_function/QuestVP.md) — `IP -> VP -> QCl`
- [StrandQuestSlash](../by_function/StrandQuestSlash.md) — `IP -> ClSlash -> QCl`
- [what_name_QCl](../by_function/what_name_QCl.md) — `NP -> QCl`

## Consumers (takes this type as an argument)
- Count: 1
- [UseQCl](../by_function/UseQCl.md) — `Temp -> Pol -> QCl -> QS`
