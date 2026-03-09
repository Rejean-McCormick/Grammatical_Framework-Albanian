# Paradigms: Portuguese

#LParadigms

source [``../src/portuguese/ParadigmsPor.gf`` http://www.grammaticalframework.org/lib/src/portuguese/ParadigmsPor.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``accusative`` | [Prep #Prep] | //direct object// |
| ``genitive`` | [Prep #Prep] | //preposition "de" and its contractions// |
| ``dative`` | [Prep #Prep] | //preposition "a" and its contractions// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Case #Case] ``->`` [Prep #Prep] | //-// |
| ``regN`` | ``Str`` ``->`` [N #N] | //-// |
| ``femN`` | [N #N] ``->`` [N #N] | //-// |
| ``mascN`` | [N #N] ``->`` [N #N] | //-// |
| ``mk2N`` | ``(bastão,`` ``bastões`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN`` | ``(luz`` ``:`` ``Str)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``(alemão,`` ``alemães`` ``:`` ``Str)`` ``->`` [N #N] | //-// |
| ``mkN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN`` | ``(bastão,bastões`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``compN`` | [N #N] ``->`` ``Str`` ``->`` [N #N] | //compound, e.g. "número" + "de telefone"// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //relational noun with prepositio// |
| ``deN2`` | [N #N] ``->`` [N2 #N2] | //relational noun with preposition "de"// |
| ``aN2`` | [N #N] ``->`` [N2 #N2] | //relational noun with preposition "a"// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //prepositions for two complements// |
| ``regPN`` | ``Str`` ``->`` [PN #PN] | //feminine for "-a", otherwise masculine// |
| ``mk2PN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //Pilar// |
| ``mkPN`` | ``(Anna`` ``:`` ``Str)`` ``->`` [PN #PN] | //-// |
| ``mkPN`` | ``(Pilar`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //-// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //-// |
| ``compADeg`` | [A #A] ``->`` [A #A] | //-// |
| ``regA`` | ``Str`` ``->`` [A #A] | //-// |
| ``mk2A`` | ``(único,unicamente`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mk5A`` | ``(preto,preta,pretos,pretas,pretamente`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkADeg`` | [A #A] ``->`` [A #A] ``->`` [A #A] | //-// |
| ``mkNonInflectA`` | [A #A] ``->`` ``Str`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(bobo`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(espanhol,espanhola`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(bobo,boba,bobos,bobas,bobamente`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(bom`` ``:`` ``A)`` ``->`` ``(melhor`` ``:`` ``A)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(blanco`` ``:`` ``A)`` ``->`` ``(hueso`` ``:`` ``Str)`` ``->`` [A #A] | //noninflecting component after the adjective// |
| ``prefixA`` | [A #A] ``->`` [A #A] | //adjective before noun (default after noun)// |
| ``prefA`` | [A #A] ``->`` [A #A] | //-// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. "casado" + dative// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //-// |
| ``regV`` | ``Str`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(pagar`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV`` | [Verbum #Verbum] ``->`` [V #V] | //-// |
| ``mkV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //-// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive verb// |
| ``special_ppV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //-// |
| ``dirV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mk2V2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //-// |
| ``v2V`` | [V2 #V2] ``->`` [V #V] | //-// |
| ``mkV3`` | ``Str`` ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``dirV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //-// |
| ``mmkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``subjVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``deVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``aVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
| ``mmkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //-// |
| ``mkV2S`` | [V #V] ``->`` [V2S #V2S] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkV2A`` | [V #V] ``->`` [V2A #V2A] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``V0`` | [Type #Type] | //-// |
| ``makeNP`` | ``Str`` ``->`` [Gender #Gender] ``->`` [Number #Number] ``->`` [NP #NP] | //-// |
| ``reflVerboV`` | [Verbum #Verbum] ``->`` [V #V] | //-// |
