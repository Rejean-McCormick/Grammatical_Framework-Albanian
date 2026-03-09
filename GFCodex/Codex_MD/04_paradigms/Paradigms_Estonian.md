# Paradigms: Estonian

#LParadigms

source [``../src/estonian/ParadigmsEst.gf`` http://www.grammaticalframework.org/lib/src/estonian/ParadigmsEst.gf]

|| Function  | Type  | Explanation ||
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``Case`` | [Type #Type] | //-// |
| ``nominative`` | [Case #Case] | //e.g. "karp"// |
| ``genitive`` | [Case #Case] | //e.g. "karbi"// |
| ``partitive`` | [Case #Case] | //e.g. "karpi"// |
| ``illative`` | [Case #Case] | //e.g. "karbisse/karpi"// |
| ``inessive`` | [Case #Case] | //e.g. "karbis"// |
| ``elative`` | [Case #Case] | //e.g. "karbist"// |
| ``allative`` | [Case #Case] | //e.g. "karbile"// |
| ``adessive`` | [Case #Case] | //e.g. "karbil"// |
| ``ablative`` | [Case #Case] | //e.g. "karbilt"// |
| ``translative`` | [Case #Case] | //e.g. "karbiks"// |
| ``terminative`` | [Case #Case] | //e.g. "karbini"// |
| ``essive`` | [Case #Case] | //e.g. "karbina"// |
| ``abessive`` | [Case #Case] | //e.g. "karbita"// |
| ``comitative`` | [Case #Case] | //e.g. "karbiga"// |
| ``infDa`` | [InfForm #InfForm] | //e.g. "lugeda"// |
| ``infDes`` | [InfForm #InfForm] | //e.g. "lugedes"// |
| ``infMa`` | [InfForm #InfForm] | //e.g. "lugema"// |
| ``infMas`` | [InfForm #InfForm] | //e.g. "lugemas"// |
| ``infMaks`` | [InfForm #InfForm] | //e.g. "lugemaks"// |
| ``infMast`` | [InfForm #InfForm] | //e.g. "lugemast"// |
| ``infMata`` | [InfForm #InfForm] | //e.g. "lugemata"// |
| ``prePrep`` | [Case #Case] ``->`` ``Str`` ``->`` [Prep #Prep] | //preposition, e.g. abessive "ilma"// |
| ``postPrep`` | [Case #Case] ``->`` ``Str`` ``->`` [Prep #Prep] | //postposition, e.g. genitive "taga"// |
| ``postGenPrep`` | ``Str`` ``->`` [Prep #Prep] | //genitive postposition, e.g. "taga"// |
| ``casePrep`` | [Case #Case] ``->`` [Prep #Prep] | //just case, e.g. adessive// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //just one word, default number Sg: e.g. "ja"// |
| ``mkConj`` | ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] ``--just`` ``one`` ``word`` ``+`` ``number:`` ``e.g.`` ``"ja"`` [Pl #Pl] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] ``--two`` ``words,`` ``default`` ``number:`` ``e.g.`` ``"nii"`` ``"kui"`` | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] ``--two`` ``words`` ``+`` ``number:`` ``e.g.`` ``"nii"`` ``"kui"`` [Pl #Pl] | //-// |
| ``mkPConj`` | ``Str`` ``->`` [PConj #PConj] | //-// |
| ``mkN`` | ``(ema`` ``:`` ``Str)`` ``->`` [N #N] | //predictable nouns, covers 90%// |
| ``mkN`` | ``(tukk,tuku`` ``:`` ``Str)`` ``->`` [N #N] | //sg nom,gen: unpredictable stem vowel// |
| ``mkN`` | ``(tukk,tuku,tukku`` ``:`` ``Str)`` ``->`` [N #N] | //sg nom,gen,part// |
| ``mkN`` | ``(pank,panga,panka,panku`` ``:`` ``Str)`` ``->`` [N #N] | //sg nom,gen,part, pl.part// |
| ``mkN`` | ``(oun,ouna,ouna,ounasse,ounte,ounu`` ``:`` ``Str)`` ``->`` [N #N] | //worst case, 6 forms// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //relational noun with genitive// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //relational noun another prep.// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //relation with two complements// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //predictable noun made into name// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //any noun made into name// |
| ``mkA`` | ``Str`` ``->`` [A #A] | //regular noun made into adjective// |
| ``mkA`` | [N #N] ``->`` [A #A] | //any noun made into adjective// |
| ``mkA`` | [N #N] ``->`` ``(infl`` ``:`` ``Infl)`` ``->`` [A #A] | //noun made into adjective, agreement type specified// |
| ``mkA`` | [N #N] ``->`` ``(parem,`` ``parim`` ``:`` ``Str)`` ``->`` [A #A] | //deviating comparison forms// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. "vihane" (postGenPrep "peale")// |
| ``invA`` | ``Str`` ``->`` [A #A] | //invariable adjectives, such as genitive attributes ; no agreement to head, no comparison forms.// |
| ``mkV`` | ``(lugema`` ``:`` ``Str)`` ``->`` [V #V] | //predictable verbs, covers 90 %// |
| ``mkV`` | ``(lugema,lugeda`` ``:`` ``Str)`` ``->`` [V #V] | //ma infinitive, da infinitive// |
| ``mkV`` | ``(lugema,lugeda,loeb`` ``:`` ``Str)`` ``->`` [V #V] | //ma, da, present sg 3// |
| ``mkV`` | ``(lugema,lugeda,loeb,loetakse`` ``:`` ``Str)`` ``->`` [V #V] ``--ma,`` ``da,`` ``pres`` ``sg`` ``3,`` ``pres`` ``passive`` | //-// |
| ``mkV`` | ``(tegema,teha,teeb,tehakse,tehke,tegi,teinud,tehtud`` ``:`` ``Str)`` ``->`` [V #V] | //worst-case verb, 8 forms// |
| ``mkV`` | ``(saama`` ``:`` ``V)`` ``->`` ``(aru`` ``:`` ``Str)`` ``->`` [V #V] | //multi-word verbs// |
| ``caseV`` | [Case #Case] ``->`` [V #V] ``->`` [V #V] | //deviating subj. case, e.g. allative "meeldima"// |
| ``vOlema`` | [V #V] | //the verb "be"// |
| ``vMinema`` | [V #V] | //the verb "go"// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //predictable direct transitive// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //direct transitive// |
| ``mkV2`` | [V #V] ``->`` [Case #Case] ``->`` [V2 #V2] | //complement just case// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //complement pre/postposition// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //e.g. rääkima, allative, elative// |
| ``mkV3`` | ``Str`` ``->`` [V3 #V3] | //string, default cases accusative + allative// |
| ``dirV3`` | [V #V] ``->`` [Case #Case] ``->`` [V3 #V3] | //liigutama, (accusative), illative// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //andma, (accusative), (allative)// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkVS`` | ``Str`` ``->`` [VS #VS] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //e.g. "ütlema" allative// |
| ``mkV2S`` | ``Str`` ``->`` [V2S #V2S] ``--default`` ``(mkV`` ``foo)`` ``allative`` | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //e.g. "hakkama"// |
| ``mkVV`` | ``Str`` ``->`` [VV #VV] | //-// |
| ``mkVVf`` | [V #V] ``->`` [InfForm #InfForm] ``->`` [VV #VV] | //e.g. "hakkama" infMa// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //e.g. "käskima" adessive// |
| ``mkV2V`` | ``Str`` ``->`` [V2V #V2V] | //e.g. "käskima" adessive// |
| ``mkV2Vf`` | [V #V] ``->`` [Prep #Prep] ``->`` [InfForm #InfForm] ``->`` [V2V #V2V] | //e.g. "keelama" partitive infMast// |
| ``mkVA`` | [V #V] ``->`` [Prep #Prep] ``->`` [VA #VA] | //e.g. "muutuma" translative// |
| ``mkVA`` | ``Str`` ``->`` [VA #VA] | //string, default case translative// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //e.g. "värvima" genitive translative// |
| ``mkV2A`` | ``Str`` ``->`` [V2A #V2A] | //string, default cases genitive and translative// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkVQ`` | ``Str`` ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //e.g. "küsima" ablative// |
