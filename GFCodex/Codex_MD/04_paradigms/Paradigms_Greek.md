# Paradigms: Greek

#LParadigms

source [``../src/greek/ParadigmsGre.gf`` http://www.grammaticalframework.org/lib/src/greek/ParadigmsGre.gf]

|| Function  | Type  | Explanation ||
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``neutral`` | [Gender #Gender] | //-// |
| ``accusative`` | [Case #Case] | //-// |
| ``genitive`` | [Case #Case] | //-// |
| ``indicative`` | [Mood #Mood] | //-// |
| ``conjunctive`` | [Mood #Mood] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``mkN`` | ``(dentro`` ``:`` ``Str)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``(s`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN`` | ``(s1,s2,s3,s4,p1,p2,p3,p4`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN`` | ``(s1,s2:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN1`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkNending`` | ``Str`` ``->`` ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] ``---η`` ``μητέρα`` ``+`` ``γενική`` | //-// |
| ``ofN2`` | [N #N] ``->`` [N2 #N2] | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //-// |
| ``mkPN`` | ``(anna`` ``:`` ``Str)`` ``->`` [PN #PN] | //-// |
| ``mkPN`` | ``(nm,gm,am,vm,pn,pa`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //-// |
| ``makeNP`` | ``(_,_,_:`` ``Str)`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [NP #NP] | //-// |
| ``makeNP`` | ``Str`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->Bool`` ``->`` [NP #NP] | //-// |
| ``mkpanta`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [NP #NP] | //-// |
| ``mkkati`` | ``Str`` ``->Number`` ``->`` [Gender #Gender] ``->`` [Bool #Bool] ``->`` [NP #NP] | //-// |
| ``mkA`` | ``(a`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(a,b:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkAd2`` | ``Str`` ``->`` [A #A] | //-// |
| ``mkAd3`` | ``Str`` ``->`` [A #A] | //-// |
| ``mkAd4`` | ``Str`` ``->`` [A #A] | //-// |
| ``mkAd5`` | ``Str`` ``->`` [A #A] | //-// |
| ``mkAdIrreg`` | ``Str`` ``->`` [A #A] | //-// |
| ``mkA1`` | ``Str`` ``->`` ``Str`` ``->`` [A #A] | //-// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //-// |
| ``mkA2V`` | [A #A] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` ``A2V;`` | //-// |
| ``mkAV`` | [A #A] ``->`` [AV #AV] | //-// |
| ``mkAS`` | [A #A] ``->`` [AS #AS] | //-// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //-// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``acc`` | [Prep #Prep] | //-// |
| ``gen`` | [Prep #Prep] | //-// |
| ``dat`` | [Prep #Prep] | //-// |
| ``prepse`` | [Prep #Prep] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Preposition #Preposition] | //-// |
| ``mkPrep2`` | ``Str`` ``->`` [Preposition #Preposition] | //-// |
| ``mkPrep3`` | ``Str`` ``->`` [Preposition #Preposition] | //-// |
| ``mkPrep4`` | ``Str`` ``->`` [Preposition #Preposition] | //-// |
| ``Preposition`` | [Type #Type] | //-// |
| ``mkPreposition`` | ``Str`` ``->`` [Preposition #Preposition] | //-// |
| ``mkPreposition2`` | ``Str`` ``->`` [Preposition #Preposition] | //-// |
| ``mkPreposition3`` | ``Str`` ``->`` [Preposition #Preposition] | //-// |
| ``mkPreposition4`` | ``Str`` ``->`` [Preposition #Preposition] | //-// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``mmkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //milaw, se, gia// |
| ``dirV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //dino,_,se// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //dino,_,_// |
| ``mmkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //-// |
| ``dirV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkV0`` | [V #V] ``->`` [V0 #V0] | //-// |
| ``V0`` | [Type #Type] | //-// |
| ``V0`` | [Type #Type] | //-// |
| ``mkNV`` | [Verb #Verb] ``->`` [V #V] | //-// |
| ``compoundV`` | [Verb #Verb] ``->`` ``Str`` ``->`` [V #V] | //-// |
