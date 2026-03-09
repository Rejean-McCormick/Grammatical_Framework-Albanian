# Paradigms: Russian

#LParadigms

source [``../src/russian/ParadigmsRus.gf`` http://www.grammaticalframework.org/lib/src/russian/ParadigmsRus.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``neuter`` | [Gender #Gender] | //-// |
| ``Case`` | [Type #Type] | //-// |
| ``nominative`` | [Case #Case] | //-// |
| ``genitive`` | [Case #Case] | //-// |
| ``dative`` | [Case #Case] | //-// |
| ``accusative`` | [Case #Case] | //-// |
| ``instructive`` | [Case #Case] | //-// |
| ``prepositional`` | [Case #Case] | //-// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``mkN`` | ``(karta`` ``:`` ``Str)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``(tigr`` ``:`` ``Str)`` ``->`` [Animacy #Animacy] ``->`` [N #N] | //-// |
| ``mkN`` | ``(nomSg,`` ``genSg,`` ``datSg,`` ``accSg,`` ``instSg,`` ``preposSg,`` ``prepos2Sg,`` ``nomPl,`` ``genPl,`` ``datPl,`` ``accPl,`` ``instPl,`` ``preposPl`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [Animacy #Animacy] ``->`` [N #N] | //-// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //-// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [Number #Number] ``->`` [Animacy #Animacy] ``->`` [PN #PN] | //"Иван", "Маша"// |
| ``nounPN`` | [N #N] ``->`` [PN #PN] | //-// |
| ``mkA`` | ``(positive`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(positive,`` ``comparative`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA2`` | [A #A] ``->`` ``Str`` ``->`` [Case #Case] ``->`` [A2 #A2] | //"делим на"// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Case #Case] ``->`` [Prep #Prep] | //as in German// |
| ``mkV`` | [Aspect #Aspect] ``->`` ``(presSg1,presSg2,presSg3,presPl1,presPl2,presPl3,pastSgMasc,imp,inf:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV2`` | [V #V] ``->`` ``Str`` ``->`` [Case #Case] ``->`` [V2 #V2] | //"войти в дом"; "в", accusative// |
| ``mkV3`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` [Case #Case] ``->`` [Case #Case] ``->`` [V3 #V3] | //"сложить письмо в конверт"// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2V`` | [V #V] ``->`` ``Str`` ``->`` [Case #Case] ``->`` [V2V #V2V] | //-// |
| ``mkV2S`` | [V #V] ``->`` ``Str`` ``->`` [Case #Case] ``->`` [V2S #V2S] | //-// |
| ``mkV2Q`` | [V #V] ``->`` ``Str`` ``->`` [Case #Case] ``->`` [V2Q #V2Q] | //-// |
| ``mkV2A`` | [V #V] ``->`` ``Str`` ``->`` [Case #Case] ``->`` [V2A #V2A] | //-// |
| ``dirV2`` | [V #V] ``->`` [V2 #V2] | //"видеть", "любить"// |
| ``tvDirDir`` | [V #V] ``->`` [V3 #V3] | //-// |
