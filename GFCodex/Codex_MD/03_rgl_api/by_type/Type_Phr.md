# Type: Phr

- Meaning: phrase in a text
- Example: //but be quiet please//

## Producers (returns this type)
- Count: 1
- [PhrUtt](../by_function/PhrUtt.md) — `PConj -> Utt -> Voc -> Phr`

## Consumers (takes this type as an argument)
- Count: 3
- [TExclMark](../by_function/TExclMark.md) — `Phr -> Text -> Text`
- [TFullStop](../by_function/TFullStop.md) — `Phr -> Text -> Text`
- [TQuestMark](../by_function/TQuestMark.md) — `Phr -> Text -> Text`
