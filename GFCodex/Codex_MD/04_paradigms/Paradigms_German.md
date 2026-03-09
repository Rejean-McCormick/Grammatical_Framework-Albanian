# Paradigms: German

#LParadigms

source [``../src/german/ParadigmsGer.gf`` http://www.grammaticalframework.org/lib/src/german/ParadigmsGer.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``neuter`` | [Gender #Gender] | //-// |
| ``Case`` | [Type #Type] | //-// |
| ``nominative`` | [Case #Case] | //-// |
| ``accusative`` | [Case #Case] | //-// |
| ``dative`` | [Case #Case] | //-// |
| ``genitive`` | [Case #Case] | //-// |
| ``vonDat_Case`` | [Case #Case] | //-// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``mkN`` | ``(Stufe`` ``:`` ``Str)`` ``->`` [N #N] | //die Stufe-Stufen, der Tisch-Tische// |
| ``mkN`` | ``(Bild,Bilder`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //sg and pl nom, and gender// |
| ``mkN`` | ``(Frau`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //masc: e, neutr: er, fem: en// |
| ``mkN`` | ``(x1,_,_,_,_,x6`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //worst case: mann, mann, manne, mannes, männer, männern// |
| ``mkN`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //Auto + Fahrer -> Autofahrer// |
| ``mkN`` | [N #N] ``->`` [N #N] ``->`` [N #N] | //Freiheit + Kampf -> Freiheitskampf// |
| ``changeCompoundN`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //kyrko + kyrka_N// |
| ``dative_eN`` | [N #N] ``->`` [N #N] | //-// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //noun + von// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //noun + other preposition// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //noun + two prepositions// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //regular name with genitive in "s", masculine// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //regular name with genitive in "s"// |
| ``mkPN`` | ``(nom,gen`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //name with other genitive// |
| ``mkPN`` | ``(nom,acc,dat,gen`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //name with all case forms// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //use the singular forms of a noun// |
| ``mkA`` | ``Str`` ``->`` [A #A] | //regular adjective, works for most cases// |
| ``mkA`` | ``(gut,besser,beste`` ``:`` ``Str)`` ``->`` [A #A] | //irregular comparison// |
| ``mkA`` | ``(gut,gute,besser,beste`` ``:`` ``Str)`` ``->`` [A #A] | //irregular positive if ending added// |
| ``invarA`` | ``Str`` ``->`` [A #A] | //invariable, e.g. prima// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. teilbar + durch// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //adverbs have just one form anyway// |
| ``mkPrep`` | ``Str`` ``->`` [Case #Case] ``->`` [Prep #Prep] | //e.g. "durch" + accusative// |
| ``mkPrep`` | [Case #Case] ``->`` ``Str`` ``->`` [Prep #Prep] | //postposition// |
| ``mkPrep`` | ``Str`` ``->`` [Case #Case] ``->`` ``Str`` ``->`` [Prep #Prep] | //both sides// |
| ``accPrep`` | [Prep #Prep] | //no string, just accusative case// |
| ``datPrep`` | [Prep #Prep] | //no string, just dative case// |
| ``genPrep`` | [Prep #Prep] | //no string, just genitive case// |
| ``von_Prep`` | [Prep #Prep] | //von + dative// |
| ``zu_Prep`` | [Prep #Prep] | //zu + dative, with contractions zum, zur// |
| ``anDat_Prep`` | [Prep #Prep] | //an + dative, with contraction am// |
| ``inDat_Prep`` | [Prep #Prep] | //in + dative, with contraction ins// |
| ``inAcc_Prep`` | [Prep #Prep] | //in + accusative, with contraction im// |
| ``mkV`` | ``(führen`` ``:`` ``Str)`` ``->`` [V #V] | //regular verb// |
| ``mkV`` | ``(sehen,sieht,sah,sähe,gesehen`` ``:`` ``Str)`` ``->`` [V #V] | //irregular verb theme// |
| ``mkV`` | ``(geben,`` ``gibt,`` ``gib,`` ``gab,`` ``gäbe,`` ``gegeben`` ``:`` ``Str)`` ``->`` [V #V] | //worst-case verb// |
| ``mkV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //movable prefix, e.g. auf+fassen, or fix prefix if one of be,er,ge,ver,zer// |
| ``no_geV`` | [V #V] ``->`` [V #V] | //no participle "ge", e.g. "bedeuten"// |
| ``fixprefixV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //add prefix such as "be"; implies no_ge// |
| ``seinV`` | [V #V] ``->`` [V #V] | //force "sein" as auxiliary// |
| ``habenV`` | [V #V] ``->`` [V #V] | //force "haben" as auxiliary// |
| ``reflV`` | [V #V] ``->`` [Case #Case] ``->`` [V #V] | //reflexive, with case// |
| ``compoundV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //verb with a separate "particle", e.g. "Trinkgeld geben"// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //direct object// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //preposition for complement// |
| ``mkV2`` | [V #V] ``->`` [Case #Case] ``->`` [V2 #V2] | //just case for complement// |
| ``accdatV3`` | [V #V] ``->`` [V3 #V3] | //geben + dat + acc (no prepositions)// |
| ``dirV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //senden + acc + nach (preposition on second arg)// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //geben + dat + acc// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //sprechen + mit + über// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``auxV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``auxV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkV2A`` | [V #V] ``->`` [V2A #V2A] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkV2S`` | [V #V] ``->`` [V2S #V2S] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [V2Q #V2Q] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //with zu// |
| ``auxVV`` | [V #V] ``->`` [VV #VV] | //without zu// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkVA`` | [V #V] ``->`` [Prep #Prep] ``->`` [VA #VA] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkInterj`` | ``Str`` ``->`` [Interj #Interj] | //-// |
