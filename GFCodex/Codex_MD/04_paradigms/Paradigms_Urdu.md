# Paradigms: Urdu

#LParadigms

source [``../src/urdu/ParadigmsUrd.gf`` http://www.grammaticalframework.org/lib/src/urdu/ParadigmsUrd.gf]

|| Function  | Type  | Explanation ||
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``singular`` | ``Number;`` | //-// |
| ``plural`` | ``Number;`` | //-// |
| ``mkN`` | ``Str`` ``->`` [N #N] | //Regular nouns like lRka, gender is judged from noun ending// |
| ``mkN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //nouns whose gender is irregular like Admy// |
| ``mkN`` | ``(x1,_,_,_,_,x6`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //worst case// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` ``N2;`` | //e.g maN ky// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` ``Str`` ``->`` ``Str->`` [N3 #N3] | //e.g faSlh - sE - ka// |
| ``mkCmpdNoun`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //e.g t-alb elm// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //-// |
| ``personalPN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [UPerson #UPerson] ``->`` [Pron #Pron] | //-// |
| ``demoPN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Quant #Quant] | //-// |
| ``mkDet`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Det #Det] | //-// |
| ``mkIP`` | ``(x1,x2,x3:Str)`` ``->`` [Number #Number] ``->`` [Gender #Gender] ``->`` [IP #IP] | //-// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //-// |
| ``mkA`` | ``Str->`` [A #A] | //e.g ach'a// |
| ``mkA`` | ``Str`` ``->`` ``Str`` ``->`` [A2 #A2] | //e.g sE Xady krna// |
| ``mkA2`` | [A #A] ``->`` ``Str`` ``->`` [A2 #A2] | //-// |
| ``mkCompoundA`` | ``Str`` ``->`` ``Str`` ``->`` [A #A] | //e.g dra hwa// |
| ``mkV`` | ``Str`` ``->`` [V #V] | //regular verbs like swna// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //e.g pyna// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //e.g pyna// |
| ``mkV2`` | [V #V] ``->`` ``Str`` ``->`` [V2 #V2] | //e.g bnd krna// |
| ``dirV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV3`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` ``V3;`` | //e.g bycna// |
| ``mkV2V`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` [Bool #Bool] ``->`` [V2V #V2V] | //e.g eltja krna - sE - kw// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //-// |
| ``compoundV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //e.g barX hwna// |
| ``compoundV`` | ``Str`` ``->`` [V2 #V2] ``->`` [V #V] | //e.g bnd krna// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //e.g yhaN// |
| ``mkAdv`` | ``Str`` ``->`` ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkPrep`` | ``Str`` ``->`` ``Str`` ``->`` [Prep #Prep] | //e.g ka - ky// |
| ``mkIQuant`` | ``Str`` ``->`` [IQuant #IQuant] | //-// |
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

%!include: synopsis-additional.txt

%!include: synopsis-browse.txt

=An Example of Usage=

%!include: synopsis-example.txt

=Table of Contents=

%%toc
