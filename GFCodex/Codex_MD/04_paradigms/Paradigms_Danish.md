# Paradigms: Danish

#LParadigms

source [``../src/danish/ParadigmsDan.gf`` http://www.grammaticalframework.org/lib/src/danish/ParadigmsDan.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``utrum`` | [Gender #Gender] | //"en" gender// |
| ``neutrum`` | [Gender #Gender] | //"et" gender// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //e.g. "til"// |
| ``noPrep`` | [Prep #Prep] | //empty string// |
| ``mkN`` | ``(bil`` ``:`` ``Str)`` ``->`` [N #N] | //regular noun: "en" gender with plural "-er" or "-r"// |
| ``mkN`` | ``(bil,bilen`` ``:`` ``Str)`` ``->`` [N #N] | //prediction from both singular indefinite and definite// |
| ``mkN`` | ``(bil,biler`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //prediction from both singular and plural plus gender// |
| ``mkN`` | ``(dreng,drengen,drenge,drengene`` ``:`` ``Str)`` ``->`` [N #N] | //almost worst case, gender guessed from Sg Def// |
| ``mkN`` | ``(dreng,drengen,drenge,drengene`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //worst case// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //e.g. datter + til// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //e.g. forbindelse + fra + til// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //utrum gender// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //other gender// |
| ``mkA`` | ``(fin`` ``:`` ``Str)`` ``->`` [A #A] | //regular adjective// |
| ``mkA`` | ``(fin,fint`` ``:`` ``Str)`` ``->`` [A #A] | //deviant neuter// |
| ``mkA`` | ``(galen,galet,galne`` ``:`` ``Str)`` ``->`` [A #A] | //also deviant plural// |
| ``mkA`` | ``(stor,stort,store,storre,storst`` ``:`` ``Str)`` ``->`` [A #A] | //worst case// |
| ``mkA`` | [A #A] ``->`` [A #A] | //force comparison with mer/mest// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. gift + med// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //after verb, e.g. "idag"// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //close to verb, e.g. "altid"// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //modify adjective, e.g. "meget"// |
| ``mkV`` | ``(snakke`` ``:`` ``Str)`` ``->`` [V #V] | //regular verb// |
| ``mkV`` | ``(leve,levde`` ``:`` ``Str)`` ``->`` [V #V] | //also give past tense// |
| ``mkV`` | ``(drikke,`` ``drakk,`` ``drukket`` ``:`` ``Str)`` ``->`` [V #V] | //theme of irregular verb// |
| ``mkV`` | ``(spise,spiser,spises,spiste,spist,spis`` ``:`` ``Str)`` ``->`` [V #V] | //worst case// |
| ``mkV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //particle verb, e.g. lukke + op// |
| ``vaereV`` | [V #V] ``->`` [V #V] | //force auxiliary "være"// |
| ``depV`` | [V #V] ``->`` [V #V] | //deponent, e.g. "undres"// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive, e.g. "forestille sig"// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //direct object// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //prepositional object// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //snakke, med, om// |
| ``dirV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //give,_,til// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //give,_,_// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
