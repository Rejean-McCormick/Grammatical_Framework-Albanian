# Paradigms: Punjabi

#LParadigms

source [``../src/punjabi/ParadigmsPnb.gf`` http://www.grammaticalframework.org/lib/src/punjabi/ParadigmsPnb.gf]

|| Function  | Type  | Explanation ||
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``singular`` | ``Number;`` | //-// |
| ``plural`` | ``Number;`` | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` ``N2;`` | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` ``Str->`` [N3 #N3] | //-// |
| ``mkCmpdNoun`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //-// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //-// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //-// |
| ``personalPN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [PPerson #PPerson] ``->`` [Pron #Pron] | //-// |
| ``demoPN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Quant #Quant] | //-// |
| ``mkDet`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Det #Det] | //-// |
| ``mkIP`` | ``(x1,x2,x3,x4:Str)`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [IP #IP] | //-// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //-// |
| ``mkA`` | ``Str->`` [A #A] | //-// |
| ``mkA`` | ``Str`` ``->`` ``Str`` ``->`` [A2 #A2] | //-// |
| ``mkV`` | ``Str`` ``->`` [V #V] | //-// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` ``Str`` ``->`` [V2 #V2] | //-// |
| ``mkV3`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` ``V3;`` | //-// |
| ``mkV2V`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` [Bool #Bool] ``->`` [V2V #V2V] | //-// |
| ``compoundV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //-// |
| ``compoundV`` | ``Str`` ``->`` [V2 #V2] ``->`` [V #V] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkQuant1`` | [Pron #Pron] ``->`` [Quant #Quant] | //-// |
| ``mkIQuant`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [IQuant #IQuant] | //-// |
| ``mkQuant1`` | [Pron #Pron] ``->`` [Quant #Quant] | //-// |
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
