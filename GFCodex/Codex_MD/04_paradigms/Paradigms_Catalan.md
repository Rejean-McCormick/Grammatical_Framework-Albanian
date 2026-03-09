# Paradigms: Catalan

#LParadigms

source [``../src/catalan/ParadigmsCat.gf`` http://www.grammaticalframework.org/lib/src/catalan/ParadigmsCat.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``accusative`` | [Prep #Prep] | //direct object// |
| ``genitive`` | [Prep #Prep] | //preposition "de"// |
| ``dative`` | [Prep #Prep] | //preposition "a"// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //other preposition// |
| ``mkN`` | ``(llum`` ``:`` ``Str)`` ``->`` [N #N] | //regular, with heuristics for plural and gender// |
| ``mkN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //force gender// |
| ``mkN`` | ``(disc,discos`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //worst case// |
| ``compN`` | [N #N] ``->`` ``Str`` ``->`` [N #N] | //compound, e.g. "número" + "de telèfon"// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //e.g. filla + genitive// |
| ``deN2`` | [N #N] ``->`` [N2 #N2] | //relation with genitive// |
| ``aN2`` | [N #N] ``->`` [N2 #N2] | //relation with dative// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //e.g. connexió + genitive + dative// |
| ``mkPN`` | ``(Anna`` ``:`` ``Str)`` ``->`` [PN #PN] | //feminine for "-a", otherwise masculine// |
| ``mkPN`` | ``(Pilar`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //force gender// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //-// |
| ``mkA`` | ``(sol`` ``:`` ``Str)`` ``->`` [A #A] | //regular// |
| ``mkA`` | ``(fort,forta,forts,fortes,fortament`` ``:`` ``Str)`` ``->`` [A #A] | //worst case// |
| ``mkA`` | ``(bo`` ``:`` ``A)`` ``->`` ``(millor`` ``:`` ``A)`` ``->`` [A #A] | //special comparison (default with "mas")// |
| ``prefixA`` | [A #A] ``->`` [A #A] | //adjective before noun (default: after)// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. "casat" + dative// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
| ``mkV`` | ``(cantar`` ``:`` ``Str)`` ``->`` [V #V] | //regular in models I, IIa, IIb// |
| ``mkV`` | ``(servir,serveixo`` ``:`` ``Str)`` ``->`` [V #V] ``--inchoative`` ``verbs`` ``and`` ``"re"`` ``verbs`` ``whose`` ``1st`` ``person`` ``ends`` ``in`` ``c`` | //-// |
| ``mkV`` | [Verbum #Verbum] ``->`` [V #V] | //use verb constructed in BeschCat// |
| ``mkV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //particle verb// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive verb// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //regular verb, direct object// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //any verb, direct object// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //preposition for complement// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //parlar, a, de// |
| ``dirV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //donar,(accusative),a// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //donar,(dative),(accusative)// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``subjVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //plain infinitive: "vull parlar"// |
| ``deVV`` | [V #V] ``->`` [VV #VV] | //"acabar de parlar"// |
| ``aVV`` | [V #V] ``->`` [VV #VV] | //"aprendre a parlar"// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
