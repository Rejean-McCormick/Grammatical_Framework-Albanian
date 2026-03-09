# Paradigms: Dutch

#LParadigms

source [``../src/dutch/ParadigmsDut.gf`` http://www.grammaticalframework.org/lib/src/dutch/ParadigmsDut.gf]

|| Function  | Type  | Explanation ||
| ``de`` | [Gender #Gender] | //non-neutrum// |
| ``het`` | [Gender #Gender] | //neutrum// |
| ``nominative`` | [Case #Case] | //nominative of nouns// |
| ``genitive`` | [Case #Case] | //genitive of nouns// |
| ``mkN`` | ``(bank`` ``:`` ``Str)`` ``->`` [N #N] | //de bank-banken, with some predictable exceptions// |
| ``mkN`` | ``(bit`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //if gender is not predictable// |
| ``mkN`` | ``(gat,`` ``gaten`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //worst-case for nouns// |
| ``mkN`` | ``(werk,`` ``plaats`` ``:`` ``N)`` ``->`` [N #N] | //compound werkplaats// |
| ``mkN`` | ``(station,`` ``hal`` ``:`` ``N)`` ``->`` [Case #Case] ``->`` [N #N] | //compound stationshal// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //relational noun with preposition van// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //other preposition than van// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //e.g. afstand + van + naar// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //proper name// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //proper name from noun// |
| ``mkA`` | ``(vers`` ``:`` ``Str)`` ``->`` [A #A] | //regular adjective// |
| ``mkA`` | ``(tweed,tweede`` ``:`` ``Str)`` ``->`` [A #A] | //with deviant second form// |
| ``mkA`` | ``(goed,goede,goeds,beter,best`` ``:`` ``Str)`` ``->`` [A #A] | //irregular adjective// |
| ``invarA`` | ``Str`` ``->`` [A #A] | //adjective with just one form// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. getrouwd + met// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``van_Prep`` | [Prep #Prep] | //-// |
| ``te_Prep`` | [Prep #Prep] | //-// |
| ``mkV`` | ``(aaien`` ``:`` ``Str)`` ``->`` [V #V] | //regular verb// |
| ``mkV`` | ``(aaien,aait`` ``:`` ``Str)`` ``->`` [V #V] | //regular verb with third person sg pres (giving stem)// |
| ``mkV`` | ``(breken,brak,gebroken`` ``:`` ``Str)`` ``->`` [V #V] | //theme of irregular verb// |
| ``mkV`` | ``(breken,brak,braken,gebroken`` ``:`` ``Str)`` ``->`` [V #V] | //also past plural irregular// |
| ``mkV`` | ``(aai,aait,aaien,aaide,aaide,aaiden,geaaid`` ``:`` ``Str)`` ``->`` [V #V] | //almost worst-case verb, Sg2=Sg3// |
| ``mkV`` | ``(aai,aait,aait,aaien,aaide,aaide,aaiden,geaaid`` ``:`` ``Str)`` ``->`` [V #V] | //worst-case verb// |
| ``mkV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //add movable suffix, e.g. af + stappen// |
| ``no_geV`` | [V #V] ``->`` [V #V] | //no participle "ge", e.g. "vertrekken"// |
| ``fixprefixV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //add prefix such as "be"; implies no_ge// |
| ``zijnV`` | [V #V] ``->`` [V #V] | //force zijn as auxiliary (default hebben)// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive verb e.g. zich afvragen// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //geven,(accusative),(dative)// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //sturen,(accusative),naar// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //praten, met, over// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //with "te"// |
| ``auxVV`` | [V #V] ``->`` [VV #VV] | //without "te"// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``auxV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``auxV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkV2S`` | [V #V] ``->`` [V2S #V2S] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkV2A`` | [V #V] ``->`` [V2A #V2A] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [V2Q #V2Q] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
