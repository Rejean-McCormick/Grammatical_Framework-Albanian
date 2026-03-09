# Type: Text

- Meaning: text consisting of several phrases
- Example: //He is here. Why?//

## Producers (returns this type)
- Count: 4
- [TEmpty](../by_function/TEmpty.md) — `Text`
- [TExclMark](../by_function/TExclMark.md) — `Phr -> Text -> Text`
- [TFullStop](../by_function/TFullStop.md) — `Phr -> Text -> Text`
- [TQuestMark](../by_function/TQuestMark.md) — `Phr -> Text -> Text`

## Consumers (takes this type as an argument)
- Count: 3
- [TExclMark](../by_function/TExclMark.md) — `Phr -> Text -> Text`
- [TFullStop](../by_function/TFullStop.md) — `Phr -> Text -> Text`
- [TQuestMark](../by_function/TQuestMark.md) — `Phr -> Text -> Text`
