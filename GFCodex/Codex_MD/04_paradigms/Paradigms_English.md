# Paradigms: English

#LParadigms

source [``../src/english/ParadigmsEng.gf`` http://www.grammaticalframework.org/lib/src/english/ParadigmsEng.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``human`` | [Gender #Gender] | //-// |
| ``nonhuman`` | [Gender #Gender] | //-// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``npNumber`` | [NP #NP] ``->`` [Number #Number] | //exctract the number of a noun phrase// |
| ``mkN`` | ``(flash`` ``:`` ``Str)`` ``->`` [N #N] | //plural s, incl. flash-flashes, fly-flies// |
| ``mkN`` | ``(man,men`` ``:`` ``Str)`` ``->`` [N #N] | //irregular plural// |
| ``mkN`` | ``(man,men,man's,men's`` ``:`` ``Str)`` ``->`` [N #N] | //irregular genitives// |
| ``mkN`` | [Gender #Gender] ``->`` [N #N] ``->`` [N #N] | //default nonhuman// |
| ``mkN`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //e.g. baby + boom// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //e.g. wife of (default prep. to)// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //e.g. access to// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //e.g. connection from x to y// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //-// |
| ``mkA`` | ``(happy`` ``:`` ``Str)`` ``->`` [A #A] | //regular adj, incl. happy-happier, rude-ruder// |
| ``mkA`` | ``(fat,fatter`` ``:`` ``Str)`` ``->`` [A #A] | //irreg. comparative// |
| ``mkA`` | ``(good,better,best,well`` ``:`` ``Str)`` ``->`` [A #A] | //completely irreg.// |
| ``compoundA`` | [A #A] ``->`` [A #A] | //force comparison with more/most// |
| ``simpleA`` | [A #A] ``->`` [A #A] | //force comparison with -er,-est// |
| ``irregAdv`` | [A #A] ``->`` ``Str`` ``->`` [A #A] | //adverb irreg, e.g. "fast"// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //absent from// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //e.g. today// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //e.g. always// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //e.g. quite// |
| ``mkCAdv`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [CAdv #CAdv] | //more than/no more than// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //e.g. approximately// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //e.g. "in front of"// |
| ``mkPost`` | ``Str`` ``->`` [Prep #Prep] | //e.g. "ago"// |
| ``noPrep`` | [Prep #Prep] | //no preposition// |
| ``mkV`` | ``(cry`` ``:`` ``Str)`` ``->`` [V #V] | //regular, incl. cry-cries, kiss-kisses etc// |
| ``mkV`` | ``(stop,`` ``stopped`` ``:`` ``Str)`` ``->`` [V #V] | //reg. with consonant duplication// |
| ``mkV`` | ``(drink,`` ``drank,`` ``drunk`` ``:`` ``Str)`` ``->`` [V #V] | //ordinary irregular// |
| ``mkV`` | ``(go,`` ``goes,`` ``went,`` ``gone,`` ``going`` ``:`` ``Str)`` ``->`` [V #V] | //totally irregular// |
| ``mkV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //fix compound, e.g. under+take// |
| ``partV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //with particle, e.g. switch + on// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive e.g. behave oneself// |
| ``us_britishV`` | ``Str`` ``->`` [V #V] | //travel - traveled/travelled// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //transitive, e.g. hit// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //with preposiiton, e.g. believe in// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //ditransitive, e.g. give,_,_// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //two prepositions, e.g. speak, with, about// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //sentence-compl e.g. say (that S)// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //e.g. tell (NP) (that S)// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //e.g. want (to VP)// |
| ``infVV`` | [V #V] ``->`` [VV #VV] | //e.g. want (to VP)// |
| ``ingVV`` | [V #V] ``->`` [VV #VV] | //e.g. start (VPing)// |
| ``mkV2V`` | ``Str`` ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //e.g. want (noPrep NP) (to VP)// |
| ``ingV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //e.g. prevent (noPrep NP) (from VP-ing)// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //e.g. become (AP)// |
| ``mkV2A`` | [V #V] ``->`` [V2A #V2A] | //e.g. paint (NP) (AP)// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //backwards compatibility// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //e.g. strike (NP) as (AP)// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //e.g. wonder (QS)// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //e.g. ask (NP) (QS)// |
| ``mkInterj`` | ``Str`` ``->`` [Interj #Interj] | //-// |
