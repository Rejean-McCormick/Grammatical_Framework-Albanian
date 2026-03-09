# Paradigms: Basque

#LParadigms

source [``../src/basque/ParadigmsEus.gf`` http://www.grammaticalframework.org/lib/src/basque/ParadigmsEus.gf]

|| Function  | Type  | Explanation ||
| ``Number`` | [Type #Type] | //-// |
| ``sg`` | [Number #Number] | //-// |
| ``pl`` | [Number #Number] | //-// |
| ``AuxType`` | [Type #Type] | //-// |
| ``da`` | [AuxType #AuxType] | //-// |
| ``du`` | [AuxType #AuxType] | //-// |
| ``zaio`` | [AuxType #AuxType] | //-// |
| ``dio`` | [AuxType #AuxType] | //-// |
| ``Case`` | [Type #Type] | //-// |
| ``absolutive`` | [Case #Case] | //-// |
| ``ergative`` | [Case #Case] | //-// |
| ``dative`` | [Case #Case] | //-// |
| ``genitive`` | [Case #Case] | //-// |
| ``partitive`` | [Case #Case] | //-// |
| ``inessive`` | [Case #Case] | //-// |
| ``instrumental`` | [Case #Case] | //Instrumental :// |
| ``sociative`` | [Case #Case] | //Sociative/comitative : txakurrarekin `with the dog'// |
| ``Animacy`` | [Type #Type] | //-// |
| ``animate`` | [Animacy #Animacy] | //-// |
| ``inanim`` | [Animacy #Animacy] | //-// |
| ``mkN`` | ``Str`` ``->`` [N #N] | //-// |
| ``mkN`` | ``Str`` ``->`` [Bizi #Bizi] ``->`` [N #N] | //-// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //-// |
| ``mkN2`` | ``Str`` ``->`` [N2 #N2] | //-// |
| ``mkN2`` | ``Str`` ``->`` [Case #Case] ``->`` [N2 #N2] | //-// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //-// |
| ``mkN2`` | [N #N] ``->`` [Case #Case] ``->`` [N2 #N2] | //-// |
| ``mkN3`` | ``Str`` ``->`` [N3 #N3] | //-// |
| ``mkN3`` | ``Str`` ``->`` [Case #Case] ``->`` [Case #Case] ``->`` [N3 #N3] | //-// |
| ``mkN3`` | ``Str`` ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //-// |
| ``mkN3`` | [N #N] ``->`` [N3 #N3] | //-// |
| ``mkN3`` | [N #N] ``->`` [Case #Case] ``->`` [Case #Case] ``->`` [N3 #N3] | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //-// |
| ``mkA`` | ``Str`` ``->`` [A #A] | //-// |
| ``mkA`` | ``Str`` ``->`` [A #A] ``->`` [A #A] | //-// |
| ``mkA2`` | ``Str`` ``->`` [Prep #Prep] ``->`` [A2 #A2] | //-// |
| ``mkV`` | ``Str`` ``->`` [V #V] | //-// |
| ``mkV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //-// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //-// |
| ``mkV2`` | ``Str`` ``->`` [AuxType #AuxType] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | ``Str`` ``->`` [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkVA`` | ``Str`` ``->`` [VA #VA] | //-// |
| ``mkV2A`` | ``Str`` ``->`` [V2A #V2A] | //-// |
| ``mkVQ`` | ``Str`` ``->`` [VQ #VQ] | //-// |
| ``mkVS`` | ``Str`` ``->`` [VS #VS] | //-// |
| ``mkV2V`` | ``Str`` ``->`` [V2V #V2V] | //-// |
| ``mkV2S`` | ``Str`` ``->`` [V2S #V2S] | //-// |
| ``mkV2Q`` | ``Str`` ``->`` [V2Q #V2Q] | //-// |
| ``mkV3`` | ``Str`` ``->`` [V3 #V3] | //-// |
| ``izanV`` | ``Str`` ``->`` [Verb #Verb] | //-// |
| ``egonV`` | ``Str`` ``->`` [Verb #Verb] | //-// |
| ``ukanV`` | ``Str`` ``->`` [Verb #Verb] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | ``Str`` ``->`` ``(complCase`` ``:`` ``Case)`` ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | ``Str`` ``->`` ``(complCase`` ``:`` ``Case)`` ``->`` ``(affixed`` ``:`` ``Bool)`` ``->`` [Prep #Prep] | //-// |
| ``affixPrep`` | ``Str`` ``->`` [Case #Case] ``->`` [Prep #Prep] | //-// |
| ``locPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkConj`` | ``(_,_`` ``:`` ``Str)`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mkSubj`` | ``Str`` ``->`` [Bool #Bool] ``->`` [Subj #Subj] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
