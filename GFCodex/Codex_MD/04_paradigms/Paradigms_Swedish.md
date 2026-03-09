# Paradigms: Swedish

#LParadigms

source [``../src/swedish/ParadigmsSwe.gf`` http://www.grammaticalframework.org/lib/src/swedish/ParadigmsSwe.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``utrum`` | [Gender #Gender] | //the "en" gender// |
| ``neutrum`` | [Gender #Gender] | //the "ett" gender// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //e.g. "till"// |
| ``noPrep`` | [Prep #Prep] | //empty string// |
| ``mkN`` | ``(apa`` ``:`` ``Str)`` ``->`` [N #N] | //predictable nouns: apa-apor, rike-riken, or bil-bilar// |
| ``mkN`` | ``(nyckel,nycklar`` ``:`` ``Str)`` ``->`` [N #N] | //singular and plural suffice for most nouns// |
| ``mkN`` | ``(museum,museet,museer,museerna`` ``:`` ``Str)`` ``->`` [N #N] | //worst case for nouns// |
| ``mkN`` | ``(museum,museet,museer,museerna`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //even worse case for nouns// |
| ``mkN`` | ``(regering,`` ``makt`` ``:`` ``N)`` ``->`` [N #N] | //regeringsmakt, using the co form of regering// |
| ``mkN`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //över + flöde// |
| ``changeCompoundN`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //kyrko + kyrka_N// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //e.g. summan - av// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //e.g. syster - till// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //e.g. flyg - från - till// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //default gender utrum// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //set other gender// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //get inflection and gender from a noun// |
| ``mkPN`` | ``(jesus,jesu`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //irregular genitive// |
| ``mkA`` | ``(billig`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(bred,brett`` ``:`` ``Str)`` ``->`` [A #A] | //predictable adjective// |
| ``mkA`` | ``(tung,tyngre,tyngst`` ``:`` ``Str)`` ``->`` [A #A] | //irregular comparison// |
| ``mkA`` | ``(god,gott,goda,battre,bast`` ``:`` ``Str)`` ``->`` [A #A] | //very irregular// |
| ``mkA`` | ``(liten,litet,lilla,sma,mindre,minst,minsta`` ``:`` ``Str)`` ``->`` [A #A] | //worst case// |
| ``compoundA`` | [A #A] ``->`` [A #A] | //force comparison by mera - mest// |
| ``invarA`` | ``Str`` ``->`` [A #A] | //e.g. äkta// |
| ``irregAdv`` | [A #A] ``->`` ``Str`` ``->`` [A #A] | //adverb irreg// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. delbar - med// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //postverbal, e.g. här// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //preverbal, e.g. alltid// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //modify adjective, e.g. tämligen// |
| ``mkV`` | ``(stämmer`` ``:`` ``Str)`` ``->`` [V #V] | //predictable verb: use present indicative// |
| ``mkV`` | ``(slita,`` ``slet`` ``:`` ``Str)`` ``->`` [V #V] | //i/e/i, u/ö/u, u/a/u// |
| ``mkV`` | ``(dricka,drack,druckit`` ``:`` ``Str)`` ``->`` [V #V] | //the theme of an irregular verb// |
| ``mkV`` | ``(gå,går,gå,gick,gått,gången`` ``:`` ``Str)`` ``->`` [V #V] | //worst case// |
| ``mkV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //particle verb, e.g. passa - på// |
| ``depV`` | [V #V] ``->`` [V #V] | //deponent verb, e.g. andas// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive verb, e.g. ångra sig// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //direct transitive// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //preposition for complement// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //direct ditransitive// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //preposition for last argument// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //prepositions for both complements// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkV2S`` | [V #V] ``->`` [V2S #V2S] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``auxVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``mkV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``auxV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkV2A`` | [V #V] ``->`` [V2A #V2A] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [V2Q #V2Q] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
| ``mkInterj`` | ``Str`` ``->`` [Interj #Interj] | //-// |
