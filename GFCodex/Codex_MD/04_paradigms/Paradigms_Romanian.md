# Paradigms: Romanian

#LParadigms

source [``../src/romanian/ParadigmsRon.gf`` http://www.grammaticalframework.org/lib/src/romanian/ParadigmsRon.gf]

|| Function  | Type  | Explanation ||
| ``NGender`` | [Type #Type] | //-// |
| ``masculine`` | [NGender #NGender] | //-// |
| ``feminine`` | [NGender #NGender] | //-// |
| ``neuter`` | [NGender #NGender] | //-// |
| ``Gender`` | [Type #Type] | //-// |
| ``Masculine`` | [Gender #Gender] | //-// |
| ``Feminine`` | [Gender #Gender] | //-// |
| ``Anim`` | [Type #Type] | //-// |
| ``animate`` | [Anim #Anim] | //-// |
| ``inanimate`` | ``Anim;`` | //-// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``Preposition`` | [Type #Type] | //-// |
| ``NCase`` | [Type #Type] | //-// |
| ``Acc`` | [NCase #NCase] | //-// |
| ``Dat`` | [NCase #NCase] | //-// |
| ``Gen`` | [NCase #NCase] | //-// |
| ``Nom`` | [NCase #NCase] | //-// |
| ``mkPrep`` | ``Str`` ``->`` ``NCase->`` [Bool #Bool] ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [NCase #NCase] ``->`` ``Prep;`` | //-// |
| ``noPrep`` | [NCase #NCase] ``->`` [Prep #Prep] | //-// |
| ``mkN`` | ``Str`` ``->`` [N #N] | //Singular, infers gender and Plural// |
| ``mkN`` | ``Str`` ``->`` ``Str`` ``->`` [NGender #NGender] ``->`` [N #N] | //worst case: Singular + Plural + gender// |
| ``mkN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [N #N] | //very irregular nouns - feminine// |
| ``mkN`` | ``Str`` ``->`` ``Str`` ``->`` [N #N] | //Singular + Plural, infers gender// |
| ``mkN`` | ``Str`` ``->`` [NGender #NGender] ``->`` [N #N] | //Singular + gender, infers Plural// |
| ``mkNR`` | ``Str`` ``->`` ``N;`` | //-// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //-// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //-// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //-// |
| ``mkPN`` | ``Str`` ``->`` ``Str`` ``->`` [Gender #Gender] ``->`` [Number #Number] ``->`` [PN #PN] | //-// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //-// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [Number #Number] ``->`` [PN #PN] | //-// |
| ``mkInAn`` | [PN #PN] ``->`` [PN #PN] | //-// |
| ``mkPropNoun`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //-// |
| ``mkA`` | ``Str`` ``->`` [A #A] | //regular adjectives// |
| ``mkA`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [A #A] ``--worst`` ``case`` | //all 4 forms are needed + form for adverb// |
| ``mkA`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [A #A] | //4 forms are needed// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //-// |
| ``mkV`` | ``Str`` ``->`` [V #V] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
