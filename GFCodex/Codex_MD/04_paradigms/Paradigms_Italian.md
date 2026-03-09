# Paradigms: Italian

#LParadigms

source [``../src/italian/ParadigmsIta.gf`` http://www.grammaticalframework.org/lib/src/italian/ParadigmsIta.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``--Prep`` | [Type #Type] | //-// |
| ``accusative`` | [Prep #Prep] | //direct object// |
| ``genitive`` | [Prep #Prep] | //preposition "di" and its contractions// |
| ``dative`` | [Prep #Prep] | //preposition "a" and its contractions// |
| ``di_Prep`` | [Prep #Prep] | //-// |
| ``a_Prep`` | [Prep #Prep] | //-// |
| ``con_Prep`` | [Prep #Prep] | //preposition "con" and its contractions// |
| ``da_Prep`` | [Prep #Prep] | //preposition "da" and its contractions// |
| ``in_Prep`` | [Prep #Prep] | //preposition "in" and its contractions// |
| ``su_Prep`` | [Prep #Prep] | //preposition "su" and its contractions// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //simple preposition (other than a, di, con, da, in, su)// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] ``->`` [Prep #Prep] | //complex preposition e.g. "vicino a"// |
| ``mkN`` | ``(cane`` ``:`` ``Str)`` ``->`` [N #N] | //regular noun; fem for -"a", masc otherwise// |
| ``mkN`` | ``(carne`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //override default gender// |
| ``mkN`` | ``(uomo,uomini`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //worst case// |
| ``mkN`` | [N #N] ``->`` ``Str`` ``->`` [N #N] | //compound such as "numero" + "di telefono"// |
| ``mkN2`` | ``Str`` ``->`` [N2 #N2] | //regular with genitive, e.g. "figlio" + "di"// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //arbitrary noun and preposition// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //e.g. volo + da + per// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //femininne for "-a", otherwise masculine// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //set gender manually// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //get gender from noun// |
| ``mkA`` | ``(bianco`` ``:`` ``Str)`` ``->`` [A #A] | //predictable adjective// |
| ``mkA`` | ``(solo,sola,soli,sole,solamente`` ``:`` ``Str)`` ``->`` [A #A] | //irregular adjective// |
| ``mkA`` | [A #A] ``->`` [A #A] ``->`` [A #A] | //special comparison, e.g. buono - migliore// |
| ``prefixA`` | [A #A] ``->`` [A #A] | //adjective that comes before noun (default: after)// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. divisibile + per// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
| ``mkV`` | ``Str`` ``->`` [V #V] | //regular verbs in "-are"/"-ire"// |
| ``mkV`` | [Verbo #Verbo] ``->`` [V #V] | //verbs formed by BeschIta// |
| ``mkV`` | ``(udire,odo,ode,udiamo,udiro,udii,udisti,udi,udirono,odi,udito`` ``:`` ``Str)`` ``->`` [V #V] | //worst case// |
| ``mkV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //particle verb// |
| ``essereV`` | [V #V] ``->`` [V #V] | //force "essere" as auxiliary (default avere)// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive verb (implies essere)// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //regular verb, direct object// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //direct object// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //prepositional object// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //donner (+ accusative + dative)// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //placer (+ accusative) + dans// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //parler + dative + genitive// |
| ``dirV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //dare,_,a// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //dare,_,_// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``subjVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //plain infinitive: "voglio parlare"// |
| ``deVV`` | [V #V] ``->`` [VV #VV] | //"cerco di parlare"// |
| ``aVV`` | [V #V] ``->`` [VV #VV] | //"arrivo a parlare"// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
| ``mkV2S`` | [V #V] ``->`` [V2S #V2S] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkV2A`` | [V #V] ``->`` [V2A #V2A] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkPredet`` | ``Str`` ``->`` [Predet #Predet] | //-// |
