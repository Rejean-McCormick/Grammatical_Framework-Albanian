# Paradigms: Persian

#LParadigms

source [``../src/persian/ParadigmsPes.gf`` http://www.grammaticalframework.org/lib/src/persian/ParadigmsPes.gf]

|| Function  | Type  | Explanation ||
| ``animate`` | [Animacy #Animacy] | //-// |
| ``inanimate`` | [Animacy #Animacy] | //-// |
| ``singular`` | ``Number;`` | //-// |
| ``plural`` | ``Number;`` | //-// |
| ``mkN01`` | ``Str`` ``->`` [Animacy #Animacy] ``->`` [Noun #Noun] | //-// |
| ``mkN02`` | ``Str`` ``->`` [Animacy #Animacy] ``->`` [Noun #Noun] | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` ``N2;`` | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` ``Str->`` [N3 #N3] | //-// |
| ``mkCmpdNoun1`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //-// |
| ``mkCmpdNoun2`` | [N #N] ``->`` ``Str`` ``->`` [N #N] | //-// |
| ``mkPN`` | ``Str`` ``->`` [Animacy #Animacy] ``->`` [PN #PN] | //-// |
| ``personalPN`` | ``Str`` ``->`` [Number #Number] ``->`` [PPerson #PPerson] ``->`` [Pron #Pron] | //-// |
| ``demoPN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Quant #Quant] | //-// |
| ``mkDet`` | ``Str`` ``->`` [Number #Number] ``->`` [Det #Det] | //-// |
| ``mkDet`` | ``Str`` ``->`` [Number #Number] ``->`` [Bool #Bool] ``->`` [Det #Det] | //-// |
| ``mkIP`` | ``(x1,x2,x3,x4:Str)`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [IP #IP] | //-// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //-// |
| ``mkA`` | ``Str->`` [A #A] | //-// |
| ``mkA`` | ``Str->`` ``Str`` ``->`` [A #A] | //-// |
| ``mkA`` | ``Str`` ``->`` ``Str`` ``->`` [A2 #A2] | //-// |
| ``mkV`` | ``Str`` ``->`` ``Str`` ``->`` [V #V] | //-// |
| ``haveVerb`` | [V #V] | //-// |
| ``mkV_1`` | ``Str`` ``->`` [V #V] | //-// |
| ``mkV_2`` | ``Str`` ``->`` [V #V] | //-// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` ``Str`` ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` ``Str`` ``->`` [Bool #Bool] ``->`` [V2 #V2] | //-// |
| ``mkV3`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` ``V3;`` | //-// |
| ``mkV2V`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` [Bool #Bool] ``->`` [V2V #V2V] | //-// |
| ``compoundV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //-// |
| ``compoundV`` | ``Str`` ``->`` [V2 #V2] ``->`` [V #V] | //-// |
| ``invarV`` | ``Str`` ``->`` [V #V] | //for verbs like " بایستن " ("must"), which don't inflect// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkQuant`` | ``Str`` ``->`` ``Str`` ``->`` [Quant #Quant] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //and (plural agreement)// |
| ``mkConj`` | ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //or (agrement number given as argument)// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] | //both ... and (plural)// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //either ... or (agrement number given as argument)// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mk2Conj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //-// |
