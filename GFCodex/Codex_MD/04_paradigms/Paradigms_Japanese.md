# Paradigms: Japanese

#LParadigms

source [``../src/japanese/ParadigmsJpn.gf`` http://www.grammaticalframework.org/lib/src/japanese/ParadigmsJpn.gf]

|| Function  | Type  | Explanation ||
| ``mkN`` | ``(man`` ``:`` ``Str)`` ``->`` [N #N] ``----`` [AR #AR] ``15/11/2014`` | //-// |
| ``mkN`` | ``(man`` ``:`` ``Str)`` ``->`` ``(anim`` ``:`` ``Animateness)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``(kane,okane`` ``:`` ``Str)`` ``->`` ``(anim`` ``:`` ``Animateness)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``(man`` ``:`` ``Str)`` ``->`` ``(anim`` ``:`` ``Animateness)`` ``->`` ``(counter`` ``:`` ``Str)`` ``->`` ``(counterReplace`` ``:`` ``Bool)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``(man`` ``:`` ``Str)`` ``->`` ``(anim`` ``:`` ``Animateness)`` ``->`` ``(counter`` ``:`` ``Str)`` ``->`` ``(counterReplace`` ``:`` ``Bool)`` ``->`` | //-// |
| ``(men`` | ``Str)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``(kane,okane`` ``:`` ``Str)`` ``->`` ``(anim`` ``:`` ``Animateness)`` ``->`` ``(counter`` ``:`` ``Str)`` ``->`` | //-// |
| ``(counterReplace`` | ``Bool)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``(tsuma,okusan`` ``:`` ``Str)`` ``->`` ``(anim`` ``:`` ``Animateness)`` ``->`` ``(counter`` ``:`` ``Str)`` ``->`` | //-// |
| ``(counterReplace`` | ``Bool)`` ``->`` ``(tsumatachi`` ``:`` ``Str)`` ``->`` [N #N] | //-// |
| ``mkN2`` | ``(man`` ``:`` ``Str)`` ``->`` ``(anim`` ``:`` ``Animateness)`` ``->`` ``(counter`` ``:`` ``Str)`` ``->`` ``(counterReplace`` ``:`` ``Bool)`` ``->`` | //-// |
| ``(men`` | ``Str)`` ``->`` ``(prep`` ``:`` ``Str)`` ``->`` [N2 #N2] | //-// |
| ``mkN3`` | ``(distance`` ``:`` ``Str)`` ``->`` ``(prep1:`` ``Str)`` ``->`` ``(prep2:`` ``Str)`` ``->`` ``(anim`` ``:`` ``Animateness)`` ``->`` [N3 #N3] | //-// |
| ``mkPN`` | ``(paris`` ``:`` ``Str)`` ``->`` [PN #PN] | //-// |
| ``mkPN`` | ``(jon,jonsan`` ``:`` ``Str)`` ``->`` [PN #PN] | //-// |
| ``mkPron`` | ``(kare`` ``:`` ``Str)`` ``->`` ``(Pron1Sg`` ``:`` ``Bool)`` ``->`` ``(anim`` ``:`` ``Animateness)`` ``->`` [Pron #Pron] | //-// |
| ``mkPron`` | ``(boku,watashi`` ``:`` ``Str)`` ``->`` ``(Pron1Sg`` ``:`` ``Bool)`` ``->`` ``(anim`` ``:`` ``Animateness)`` ``->`` [Pron #Pron] | //-// |
| ``mkA`` | ``(ookina`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(kekkonshiteiru,kikonno`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA2`` | ``(yasui`` ``:`` ``Str)`` ``->`` ``(prep`` ``:`` ``Str)`` ``->`` [A2 #A2] | //-// |
| ``mkA2`` | ``(pred`` ``:`` ``Str)`` ``->`` ``(attr`` ``:`` ``Str)`` ``->`` ``(prep`` ``:`` ``Str)`` ``->`` [A2 #A2] | //-// |
| ``mkV`` | ``(yomu`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(yomu`` ``:`` ``Str)`` ``->`` ``(group`` ``:`` ``ResJpn.VerbGroup)`` ``->`` [V #V] | //-// |
| ``mkV2`` | ``(yomu`` ``:`` ``Str)`` ``->`` [V2 #V2] ``----`` [AR #AR] ``15/11/2014`` | //-// |
| ``mkV2`` | ``(yomu,`` ``prep`` ``:`` ``Str)`` ``->`` ``(group`` ``:`` ``ResJpn.VerbGroup)`` ``->`` [V2 #V2] | //-// |
| ``mkV3`` | ``(yomu`` ``:`` ``Str)`` ``->`` [V3 #V3] | //-// |
| ``mkV3`` | ``(uru,`` ``p1,`` ``p2`` ``:`` ``Str)`` ``->`` ``(group`` ``:`` ``ResJpn.VerbGroup)`` ``->`` [V3 #V3] | //-// |
| ``mkVS`` | ``(yomu`` ``:`` ``Str)`` ``->`` [VS #VS] | //-// |
| ``mkVV`` | ``(yomu`` ``:`` ``Str)`` ``->`` [VV #VV] | //-// |
| ``mkV2V`` | ``(yomu`` ``:`` ``Str)`` ``->`` [V2V #V2V] | //-// |
| ``mkV2S`` | ``(yomu`` ``:`` ``Str)`` ``->`` [V2S #V2S] | //-// |
| ``mkVQ`` | ``(yomu`` ``:`` ``Str)`` ``->`` [VQ #VQ] | //-// |
| ``mkVA`` | ``(yomu`` ``:`` ``Str)`` ``->`` [VA #VA] | //-// |
| ``mkV2A`` | ``(yomu`` ``:`` ``Str)`` ``->`` [V2A #V2A] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] ``----`` [AR #AR] ``15/11/2014`` | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] ``----`` [AR #AR] ``15/11/2014`` | //-// |
| ``mkDet`` | ``Str`` ``->`` [Det #Det] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkInterj`` | ``Str`` ``->`` [Interj #Interj] | //-// |
| ``mkgoVV`` | [VV #VV] | //-// |
