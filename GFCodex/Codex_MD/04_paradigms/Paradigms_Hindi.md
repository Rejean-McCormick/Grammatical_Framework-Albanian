# Paradigms: Hindi

#LParadigms

source [``../src/hindi/ParadigmsHin.gf`` http://www.grammaticalframework.org/lib/src/hindi/ParadigmsHin.gf]

|| Function  | Type  | Explanation ||
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``singular`` | ``Number;`` | //-// |
| ``plural`` | ``Number;`` | //-// |
| ``mkN`` | ``Str`` ``->`` [N #N] | //-// |
| ``mkN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN`` | ``(x1,_,_,_,_,x6`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` ``N2;`` | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` ``Str->`` [N3 #N3] | //-// |
| ``mkCmpdNoun`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //-// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //-// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //-// |
| ``personalPN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [UPerson #UPerson] ``->`` [Pron #Pron] | //-// |
| ``demoPN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Quant #Quant] | //-// |
| ``mkDet`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Det #Det] | //-// |
| ``mkIP`` | ``(x1,x2,x3:Str)`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [IP #IP] | //-// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //-// |
| ``mkA`` | ``Str->`` [A #A] | //-// |
| ``mkA`` | ``Str`` ``->`` ``Str`` ``->`` [A2 #A2] | //-// |
| ``mkA`` | [A #A] ``->`` ``Str`` ``->`` [A2 #A2] | //-// |
| ``mkIrregA`` | ``Str`` ``->`` [A #A] | //-// |
| ``mkA2`` | [A #A] ``->`` ``Str`` ``->`` [A2 #A2] | //-// |
| ``mkV`` | ``Str`` ``->`` [V #V] | //-// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` ``Str`` ``->`` [V2 #V2] | //-// |
| ``mkV3`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` ``V3;`` | //-// |
| ``mkV2V`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` [Bool #Bool] ``->`` [V2V #V2V] | //-// |
| ``dirV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //-// |
| ``compoundV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //-// |
| ``compoundV`` | ``Str`` ``->`` [V2 #V2] ``->`` [V #V] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkPrep`` | ``Str`` ``->`` ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkIQuant`` | ``(s1,_,_,_,_,_,_,_,_,_,_,s12:Str)`` ``->`` [IQuant #IQuant] | //-// |
| ``mkQuant`` | [Pron #Pron] ``->`` [Quant #Quant] | //-// |
| ``mkQuant`` | [Pron #Pron] ``->`` [Quant #Quant] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //and (plural agreement)// |
| ``mkConj`` | ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //or (agrement number given as argument)// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] | //both ... and (plural)// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //either ... or (agrement number given as argument)// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mk2Conj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mkVS`` | [V #V] ``->`` ``VS;`` | //e.g drna// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //e.g janna// |
| ``mkInterj`` | ``Str`` ``->`` [Interj #Interj] | //-// |
