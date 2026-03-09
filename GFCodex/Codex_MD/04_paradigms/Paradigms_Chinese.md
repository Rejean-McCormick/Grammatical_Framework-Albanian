# Paradigms: Chinese

#LParadigms

source [``../src/chinese/ParadigmsChi.gf`` http://www.grammaticalframework.org/lib/src/chinese/ParadigmsChi.gf]

|| Function  | Type  | Explanation ||
| ``mkN`` | ``(man`` ``:`` ``Str)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``(man`` ``:`` ``Str)`` ``->`` ``Str`` ``->`` [N #N] | //-// |
| ``mkN2`` | ``Str`` ``->`` [N2 #N2] | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //-// |
| ``mkPN`` | ``(john`` ``:`` ``Str)`` ``->`` [PN #PN] | //-// |
| ``foreignPN`` | ``(john`` ``:`` ``Str)`` ``->`` [PN #PN] | //-// |
| ``mkA`` | ``(small`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(small`` ``:`` ``Str)`` ``->`` [Bool #Bool] ``->`` [A #A] | //-// |
| ``mkA2`` | ``Str`` ``->`` [A2 #A2] | //-// |
| ``mkA2`` | [A #A] ``->`` [A2 #A2] | //-// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //-// |
| ``mkV`` | ``(walk`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(walk,out`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(arrive`` ``:`` ``Str)`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(arrive`` ``:`` ``Str)`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [V #V] | //-// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //-// |
| ``mkV3`` | ``Str`` ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``mkVV`` | ``Str`` ``->`` [VV #VV] | //-// |
| ``mkVQ`` | ``Str`` ``->`` [VQ #VQ] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkVS`` | ``Str`` ``->`` [VS #VS] | //-// |
| ``mkVS`` | ``Str`` ``->`` ``Str`` ``->`` [VS #VS] | //-// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkVA`` | ``Str`` ``->`` [VA #VA] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [V2Q #V2Q] | //-// |
| ``mkV2Q`` | ``Str`` ``->`` [V2Q #V2Q] | //-// |
| ``mkV2V`` | ``Str`` ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``mkV2S`` | ``Str`` ``->`` [V2S #V2S] | //-// |
| ``mkV2S`` | [V #V] ``->`` [V2S #V2S] | //-// |
| ``mkV2A`` | ``Str`` ``->`` [V2A #V2A] | //-// |
| ``mkV2A`` | [V #V] ``->`` [V2A #V2A] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkAdv`` | ``Str`` ``->`` ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [AdvType #AdvType] ``->`` [Adv #Adv] | //-// |
| ``mkAdv`` | [Adv #Adv] ``->`` [AdvType #AdvType] ``->`` [Adv #Adv] | //To fix the AdvType in an Adv produced by SyntaxChi.mkAdv// |
| ``AdvType`` | [Type #Type] | //-// |
| ``placeAdvType`` | [AdvType #AdvType] | //without "在" included// |
| ``zai_placeAdvType`` | [AdvType #AdvType] | //with "在" included// |
| ``timeAdvType`` | [AdvType #AdvType] | //-// |
| ``mannerAdvType`` | [AdvType #AdvType] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | ``Str`` ``->`` ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | ``Str`` ``->`` ``Str`` ``->`` [AdvType #AdvType] ``->`` [Prep #Prep] | //-// |
| ``mkInterj`` | ``Str`` ``->`` [Interj #Interj] | //-// |
| ``emptyPrep`` | [Preposition #Preposition] | //-// |
| ``mkpNP`` | ``Str`` ``->`` ``CatChi.NP`` | //-// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //-// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //-// |
| ``mkSubj`` | ``Str`` ``->`` [Subj #Subj] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``(both,and`` ``:`` ``Str)`` ``->`` [Conj #Conj] | //-// |
| ``mkpDet`` | ``Str`` ``->`` [Det #Det] | //-// |
| ``mkQuant`` | ``Str`` ``->`` [Quant #Quant] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
| ``mkNum`` | ``Str`` ``->`` [Num #Num] | //-// |
| ``mkPredet`` | ``Str`` ``->`` [Predet #Predet] | //-// |
| ``mkIDet`` | ``Str`` ``->`` [IDet #IDet] | //-// |
| ``mkPConj`` | ``Str`` ``->`` [PConj #PConj] | //-// |
| ``mkRP`` | ``Str`` ``->`` [RP #RP] | //-// |
