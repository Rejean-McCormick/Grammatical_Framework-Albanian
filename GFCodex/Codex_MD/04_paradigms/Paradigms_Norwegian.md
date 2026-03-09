# Paradigms: Norwegian

#LParadigms

source [``../src/norwegian/ParadigmsNor.gf`` http://www.grammaticalframework.org/lib/src/norwegian/ParadigmsNor.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``masculine`` | [Gender #Gender] | //the "en" gender// |
| ``feminine`` | [Gender #Gender] | //the "ei" gender// |
| ``neutrum`` | [Gender #Gender] | //the "et" gender// |
| ``utrum`` | [Gender #Gender] | //the "en" gender, same as masculine// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //e.g. "etter"// |
| ``noPrep`` | [Prep #Prep] | //empty string// |
| ``mkN`` | ``Str`` ``->`` [N #N] | //predictable noun, feminine for "-e" otherwise masculine// |
| ``mkN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //force gender// |
| ``mkN`` | ``(dreng,drengen,drenger,drengene`` ``:`` ``Str)`` ``->`` [N #N] | //worst case, gender guessed// |
| ``mkN`` | ``(dreng,drengen,drenger,drengene`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //worst case// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //e.g. datter + til// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //e.g forbindelse + fra + til// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //masculine// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //force gender// |
| ``mkA`` | ``(fin`` ``:`` ``Str)`` ``->`` [A #A] | //predictable adjective// |
| ``mkA`` | ``(fin,fint`` ``:`` ``Str)`` ``->`` [A #A] | //deviant neuter// |
| ``mkA`` | ``(galen,galet,galne`` ``:`` ``Str)`` ``->`` [A #A] | //also plural deviant// |
| ``mkA`` | ``(stor,stort,store,storre,storst`` ``:`` ``Str)`` ``->`` [A #A] | //worst case// |
| ``mkA`` | [A #A] ``->`` [A #A] | //comparison with mer/mest, e.g. "norsk"// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. gift + med// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //e.g. her// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //e.g. altid// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //e.g. mye// |
| ``mkV`` | ``(snakke`` ``:`` ``Str)`` ``->`` [V #V] | //regular verb (first conjugation)// |
| ``mkV`` | ``(leve,levde`` ``:`` ``Str)`` ``->`` [V #V] | //other past tense// |
| ``mkV`` | ``(drikke,`` ``drakk,`` ``drukket`` ``:`` ``Str)`` ``->`` [V #V] | //theme of irregular verb// |
| ``mkV`` | ``(spise,spiser,spises,spiste,spist,spis`` ``:`` ``Str)`` ``->`` [V #V] | //worst case// |
| ``mkV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //verb with particle, e.g. lukke + opp// |
| ``vaereV`` | [V #V] ``->`` [V #V] | //force "være" as auxiliary (default "have")// |
| ``depV`` | [V #V] ``->`` [V #V] | //deponent, e.g "trives"// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive, e.g. "forestille seg"// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //regular, direct object// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //direct object// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //preposition for complement// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //snakke, med, om// |
| ``dirV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //gi,_,til// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //gi,_,_// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
