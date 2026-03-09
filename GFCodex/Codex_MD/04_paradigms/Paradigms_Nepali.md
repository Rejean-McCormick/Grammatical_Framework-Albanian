# Paradigms: Nepali

#LParadigms

source [``../src/nepali/ParadigmsNep.gf`` http://www.grammaticalframework.org/lib/src/nepali/ParadigmsNep.gf]

|| Function  | Type  | Explanation ||
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``human`` | [NType #NType] | //-// |
| ``profession`` | [NType #NType] | //-// |
| ``living`` | [NType #NType] | //-// |
| ``regN`` | ``Str`` ``->`` [N #N] | //-// |
| ``regN`` | ``Str`` ``->`` [NPerson #NPerson] ``->`` [N #N] | //-// |
| ``regN`` | ``Str`` ``->`` [NType #NType] ``->`` [N #N] | //-// |
| ``regN`` | ``Str`` ``->`` [NType #NType] ``->`` [NPerson #NPerson] ``->`` [N #N] | //-// |
| ``mkNF`` | ``Str`` ``->`` [N #N] | //-// |
| ``mkNF`` | ``Str`` ``->`` [NPerson #NPerson] ``->`` [N #N] | //-// |
| ``mkNF`` | ``Str`` ``->`` [NType #NType] ``->`` [N #N] | //-// |
| ``mkNF`` | ``Str`` ``->`` [NType #NType] ``->`` [NPerson #NPerson] ``->`` [N #N] | //-// |
| ``mkNUC`` | ``Str`` ``->`` [N #N] | //-// |
| ``mkNUC`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkNUC`` | ``Str`` ``->`` [Gender #Gender] ``->`` [NType #NType] ``->`` [N #N] | //-// |
| ``mkNUC`` | ``Str`` ``->`` [Gender #Gender] ``->`` [NType #NType] ``->`` [NPerson #NPerson] ``->`` [N #N] | //-// |
| ``--mkNUC`` | ``Str`` ``->`` [NType #NType] ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` [N2 #N2] | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` [NType #NType] ``->`` [N2 #N2] | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` [NType #NType] ``->`` [NPerson #NPerson] ``->`` [N2 #N2] | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` ``N2;`` | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` ``Str->`` [N3 #N3] | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` ``Str->`` [NType #NType] ``->`` [N3 #N3] | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` ``Str->`` [N3 #N3] | //-// |
| ``mkCmpdNoun`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //-// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //-// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [NPerson #NPerson] ``->`` [PN #PN] | //-// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [NType #NType] ``->`` [NPerson #NPerson] ``->`` [PN #PN] | //-// |
| ``mkPron`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [NPerson #NPerson] ``->`` [Pron #Pron] | //-// |
| ``mkPron`` | ``(x1,_,_,_,_,_,x7`` ``:`` ``Str)`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [NPerson #NPerson] ``->`` [Pron #Pron] | //-// |
| ``demoPN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Quant #Quant] | //-// |
| ``mkDet`` | ``(s1,s2:Str)`` ``->`` [Number #Number] ``->`` [Det #Det] | //-// |
| ``mkDet`` | ``(s1,s2,s3,s4:Str)`` ``->`` [Number #Number] ``->`` [Det #Det] | //-// |
| ``mkIDetn`` | ``(s1,s2:Str)`` ``->`` [Number #Number] ``->`` [IDet #IDet] | //-// |
| ``mkIP`` | ``(x1,x2,x3,x4:Str)`` ``->`` [Number #Number] ``->`` [IP #IP] | //-// |
| ``mkA`` | ``Str->`` [A #A] | //-// |
| ``mkA`` | ``Str`` ``->`` ``Str`` ``->`` [A2 #A2] | //-// |
| ``mkV`` | ``Str`` ``->`` [V #V] | //-// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` ``Str`` ``->`` [V2 #V2] | //-// |
| ``mkV3`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` [V3 #V3] | //-// |
| ``mkV2V`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` [Bool #Bool] ``->`` [V2V #V2V] | //-// |
| ``compoundV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //-// |
| ``compoundV`` | ``Str`` ``->`` [V2 #V2] ``->`` [V #V] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //e.g. today// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //e.g. always// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //e.g. quite// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //e.g. approximately// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``noPrep`` | [Prep #Prep] | //-// |
| ``--mkQuant`` | [Pron #Pron] ``->`` [Quant #Quant] | //-// |
| ``mkQuant`` | ``(s1,s2,s3,s4:Str)`` ``->`` [Quant #Quant] | //-// |
| ``mkQuant`` | ``(s1,s2:Str)`` ``->`` [Quant #Quant] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //and (plural agreement)// |
| ``mkConj`` | ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //or (agrement number given as argument)// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] | //both ... and (plural)// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //either ... or (agrement number given as argument)// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mk2Conj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
