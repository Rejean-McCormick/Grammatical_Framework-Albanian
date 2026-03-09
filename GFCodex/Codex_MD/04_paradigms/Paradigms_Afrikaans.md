# Paradigms: Afrikaans

#LParadigms

source [``../src/afrikaans/ParadigmsAfr.gf`` http://www.grammaticalframework.org/lib/src/afrikaans/ParadigmsAfr.gf]

|| Function  | Type  | Explanation ||
| ``de`` | [Gender #Gender] | //non-neutrum// |
| ``het`` | [Gender #Gender] | //neutrum// |
| ``--die`` | [Gender #Gender] | //-// |
| ``mkN`` | ``(muis`` ``:`` ``Str)`` ``->`` [N #N] | //de muis-muisen, with some predictable exceptions// |
| ``mkN`` | ``(bit`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //if gender is not predictable// |
| ``mkN`` | ``(gat,gaten`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //worst-case for nouns// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //relational noun with preposition van// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //other preposition than van// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //e.g. afstand + van + naar// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //proper name// |
| ``mkA`` | ``(vers`` ``:`` ``Str)`` ``->`` [A #A] | //regular adjective// |
| ``mkA`` | ``(sag,`` ``sagte`` ``:`` ``Str)`` ``->`` [A #A] ``--"semi-irregular"`` | //-// |
| ``mkA`` | ``(goed,goede,goeds,beter,best`` ``:`` ``Str)`` ``->`` [A #A] | //irregular adjective// |
| ``invarA`` | ``Str`` ``->`` [A #A] | //adjective with just one form// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. getrouwd + met// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``van_Prep`` | [Prep #Prep] | //-// |
| ``te_Prep`` | [Prep #Prep] | //-// |
| ``mkV`` | ``(aaien`` ``:`` ``Str)`` ``->`` [V #V] | //regular verb// |
| ``mkV`` | ``(breken,brak,gebroken`` ``:`` ``Str)`` ``->`` [V #V] | //theme of irregular verb// |
| ``mkV`` | ``(breken,brak,braken,gebroken`` ``:`` ``Str)`` ``->`` [V #V] | //also past plural irregular// |
| ``mkV`` | ``(aai,aait,aaien,aaide,aaide,aaiden,geaaid`` ``:`` ``Str)`` ``->`` [V #V] | //worst-case verb// |
| ``mkV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //add movable suffix, e.g. af + stappen// |
| ``zijnV`` | [V #V] ``->`` [V #V] | //force zijn as auxiliary (default hebben)// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive verb e.g. zich afvragen// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //geven,(accusative),(dative)// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //sturen,(accusative),naar// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //praten, met, over// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
