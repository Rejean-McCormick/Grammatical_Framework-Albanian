# Paradigms: Latvian

#LParadigms

source [``../src/latvian/ParadigmsLav.gf`` http://www.grammaticalframework.org/lib/src/latvian/ParadigmsLav.gf]

|| Function  | Type  | Explanation ||
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``nominative`` | [Case #Case] | //-// |
| ``genitive`` | [Case #Case] | //-// |
| ``dative`` | [Case #Case] | //-// |
| ``accusative`` | [Case #Case] | //-// |
| ``locative`` | [Case #Case] | //-// |
| ``second_conjugation`` | [Conjugation #Conjugation] | //-// |
| ``third_conjugation`` | [Conjugation #Conjugation] | //-// |
| ``active_voice`` | [Voice #Voice] | //-// |
| ``passive_voice`` | [Voice #Voice] | //-// |
| ``mkN`` | ``(lemma`` ``:`` ``Str)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``(lemma`` ``:`` ``Str)`` ``->`` [Bool #Bool] ``->`` [N #N] | //-// |
| ``mkN`` | ``(lemma`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN`` | ``(lemma`` ``:`` ``Str)`` ``->`` [Declension #Declension] ``->`` [N #N] | //-// |
| ``mkN`` | ``(lemma`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [Bool #Bool] ``->`` [N #N] | //-// |
| ``mkN`` | ``(lemma`` ``:`` ``Str)`` ``->`` [Declension #Declension] ``->`` [Bool #Bool] ``->`` [N #N] | //-// |
| ``mkN`` | ``(lemma`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [Declension #Declension] ``->`` [N #N] | //-// |
| ``mkN`` | ``(lemma`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [Declension #Declension] ``->`` [Bool #Bool] ``->`` [N #N] | //-// |
| ``mkN`` | ``(lemma`` ``:`` ``Str)`` ``->`` [PN #PN] | //-// |
| ``mkN`` | ``(lemma`` ``:`` ``Str)`` ``->`` [Number #Number] ``->`` [PN #PN] | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [Bool #Bool] ``->`` [N2 #N2] | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //-// |
| ``mkA`` | ``(lemma`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(lemma`` ``:`` ``Str)`` ``->`` [AType #AType] ``->`` [A #A] | //-// |
| ``mkA`` | ``(v`` ``:`` ``V)`` ``->`` [Voice #Voice] ``->`` [A #A] | //-// |
| ``mkAS`` | [A #A] ``->`` [AS #AS] | //-// |
| ``mkAV`` | [A #A] ``->`` [AV #AV] | //-// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //-// |
| ``mkA2S`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2S #A2S] | //-// |
| ``mkA2V`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2V #A2V] | //-// |
| ``mkV`` | ``Str`` ``->`` [V #V] | //-// |
| ``mkV`` | ``Str`` ``->`` [Case #Case] ``->`` [V #V] | //-// |
| ``mkV`` | ``Str`` ``->`` [Conjugation #Conjugation] ``->`` [V #V] | //-// |
| ``mkV`` | ``Str`` ``->`` [Conjugation #Conjugation] ``->`` [Case #Case] ``->`` [V #V] | //-// |
| ``mkV`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [V #V] | //-// |
| ``mkV`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Case #Case] ``->`` [V #V] | //-// |
| ``--mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``--mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //-// |
| ``mkVS`` | [V #V] ``->`` [Subj #Subj] ``->`` [VS #VS] | //-// |
| ``mkVS`` | [V #V] ``->`` [Subj #Subj] ``->`` [Case #Case] ``->`` [VS #VS] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkVQ`` | [V #V] ``->`` [Case #Case] ``->`` [VQ #VQ] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``mkVV`` | [V #V] ``->`` [Case #Case] ``->`` [VV #VV] | //-// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Subj #Subj] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Case #Case] ``->`` [Case #Case] ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | [Case #Case] ``->`` [Prep #Prep] | //-// |
| ``nom_Prep`` | [Prep #Prep] | //-// |
| ``gen_Prep`` | [Prep #Prep] | //-// |
| ``dat_Prep`` | [Prep #Prep] | //-// |
| ``acc_Prep`` | [Prep #Prep] | //-// |
| ``loc_Prep`` | [Prep #Prep] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //-// |
| ``mkCAdv`` | ``Str`` ``->`` ``Str`` ``->`` [Degree #Degree] ``->`` [CAdv #CAdv] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mk2Conj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mkNumReg`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` ``{`` ``s`` ``:`` [DForm #DForm] ``=>`` [CardOrd #CardOrd] ``=>`` [Gender #Gender] ``=>`` [Case #Case] ``=>`` ``Str`` ``}`` | //-// |
| ``mkNumSpec`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` ``{`` ``s`` ``:`` [DForm #DForm] ``=>`` [CardOrd #CardOrd] ``=>`` [Gender #Gender] ``=>`` [Case #Case] ``=>`` ``Str`` ``}`` | //-// |
| ``simts`` | [CardOrd #CardOrd] ``=>`` [Gender #Gender] ``=>`` [Number #Number] ``=>`` [Case #Case] ``=>`` ``Str`` | //-// |
| ``tuukstotis`` | [CardOrd #CardOrd] ``=>`` [Gender #Gender] ``=>`` [Number #Number] ``=>`` [Case #Case] ``=>`` ``Str`` | //-// |
