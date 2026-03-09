# Paradigms: Finnish

#LParadigms

source [``../src/finnish/ParadigmsFin.gf`` http://www.grammaticalframework.org/lib/src/finnish/ParadigmsFin.gf]

|| Function  | Type  | Explanation ||
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``Case`` | [Type #Type] | //-// |
| ``nominative`` | [Case #Case] | //e.g. "talo"// |
| ``genitive`` | [Case #Case] | //e.g. "talon"// |
| ``partitive`` | [Case #Case] | //e.g. "taloa"// |
| ``essive`` | [Case #Case] | //e.g. "talona"// |
| ``translative`` | [Case #Case] | //e.g. "taloksi"// |
| ``inessive`` | [Case #Case] | //e.g. "talossa"// |
| ``elative`` | [Case #Case] | //e.g. "talosta"// |
| ``illative`` | [Case #Case] | //e.g. "taloon"// |
| ``adessive`` | [Case #Case] | //e.g. "talolla"// |
| ``ablative`` | [Case #Case] | //e.g. "talolta"// |
| ``allative`` | [Case #Case] | //e.g. "talolle"// |
| ``infFirst`` | [InfForm #InfForm] | //e.g. "tehdä"// |
| ``infIness`` | [InfForm #InfForm] | //e.g. "tekemässä"// |
| ``infElat`` | [InfForm #InfForm] | //e.g. "tekemästä"// |
| ``infIllat`` | [InfForm #InfForm] | //e.g. "tekemään"// |
| ``infAdess`` | [InfForm #InfForm] | //e.g. "tekemällä"// |
| ``infPart`` | [InfForm #InfForm] | //e.g. "tekemistä"// |
| ``infPresPart`` | [InfForm #InfForm] | //e.g. "tekevän"// |
| ``infPresPartAgr`` | [InfForm #InfForm] | //e.g. "tekevänsä"// |
| ``prePrep`` | [Case #Case] ``->`` ``Str`` ``->`` [Prep #Prep] | //preposition, e.g. partitive "ilman"// |
| ``postPrep`` | [Case #Case] ``->`` ``Str`` ``->`` [Prep #Prep] | //postposition, e.g. genitive "takana"// |
| ``postGenPrep`` | ``Str`` ``->`` [Prep #Prep] | //genitive postposition, e.g. "takana"// |
| ``casePrep`` | [Case #Case] ``->`` [Prep #Prep] | //just case, e.g. adessive// |
| ``mkPrep`` | [Case #Case] ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | [Case #Case] ``->`` ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Case #Case] ``->`` [Prep #Prep] | //-// |
| ``accusative`` | [Prep #Prep] | //-// |
| ``NK`` | [Type #Type] | //Noun from DictFin (Kotus)// |
| ``AK`` | [Type #Type] | //Adjective from DictFin (Kotus)// |
| ``VK`` | [Type #Type] | //Verb from DictFin (Kotus)// |
| ``AdvK`` | [Type #Type] | //Adverb from DictFin (Kotus)// |
| ``mkN`` | ``(kukko`` ``:`` ``Str)`` ``->`` [N #N] | //predictable nouns, covers 82%// |
| ``mkN`` | ``(savi,savia`` ``:`` ``Str)`` ``->`` [N #N] | //different pl.part// |
| ``mkN`` | ``(vesi,veden,vesiä`` ``:`` ``Str)`` ``->`` [N #N] | //also different sg.gen// |
| ``mkN`` | ``(vesi,veden,vesiä,vettä`` ``:`` ``Str)`` ``->`` [N #N] | //also different sg.part// |
| ``mkN`` | ``(olo,n,a,na,oon,jen,ja,ina,issa,ihin`` ``:`` ``Str)`` ``->`` [N #N] | //worst case, 10 forms// |
| ``mkN`` | ``(pika`` ``:`` ``Str)`` ``->`` ``(juna`` ``:`` ``N)`` ``->`` [N #N] | //compound with invariable prefix// |
| ``mkN`` | ``(oma`` ``:`` ``N)`` ``->`` ``(tunto`` ``:`` ``N)`` ``->`` [N #N] | //compound with inflecting prefix// |
| ``mkN`` | [NK #NK] ``->`` [N #N] | //noun from DictFin (Kotus)// |
| ``mkN`` | [V #V] ``->`` [N #N] | //verbal noun: "tekeminen"// |
| ``exceptNomN`` | [N #N] ``->`` ``Str`` ``->`` [N #N] | //-// |
| ``separateN`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //-// |
| ``separateN`` | [N #N] ``->`` [N #N] ``->`` [N #N] | //-// |
| ``compN`` | [N #N] ``->`` [N #N] ``->`` [N #N] | //-// |
| ``genCompN`` | [N #N] ``->`` [N #N] ``->`` [N #N] | //-// |
| ``genCompN`` | [Number #Number] ``->`` [N #N] ``->`` [N #N] ``->`` [N #N] | //-// |
| ``genitiveCompoundN`` | [Number #Number] ``->`` [N #N] ``->`` [N #N] ``->`` [N #N] | //-// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //relational noun with genitive// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //relational noun another prep.// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //relation with two complements// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //predictable noun made into name// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //any noun made into name// |
| ``foreignPN`` | ``Str`` ``->`` [PN #PN] | //Dieppe-Dieppen// |
| ``mkA`` | ``Str`` ``->`` [A #A] | //regular noun made into adjective// |
| ``mkA`` | [N #N] ``->`` [A #A] | //any noun made into adjective// |
| ``mkA`` | [N #N] ``->`` ``(kivempi,kivin`` ``:`` ``Str)`` ``->`` [A #A] | //deviating comparison forms// |
| ``mkA`` | ``(hyva,prmpi,pras`` ``:`` ``N)`` ``->`` ``(hyvin,pmmin,prhten`` ``:`` ``Str)`` ``->`` [A #A] | //worst case adj// |
| ``mkA`` | [AK #AK] ``->`` [A #A] | //adjective from DictFin (Kotus)// |
| ``invarA`` | ``Str`` ``->`` [A #A] | //invariant adjective, e.g. "kelpo"// |
| ``prefixA`` | ``Str`` ``->`` [A #A] ``->`` [A #A] | //-// |
| ``mkA2`` | ``Str`` ``->`` [A2 #A2] | //e.g. "vihainen" (jollekin)// |
| ``mkA2`` | ``Str`` ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. "jaollinen" (mkPrep adessive)// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. "jaollinen" (mkPrep adessive)// |
| ``mkV`` | ``(huutaa`` ``:`` ``Str)`` ``->`` [V #V] | //predictable verbs, covers 90%// |
| ``mkV`` | ``(huutaa,huusi`` ``:`` ``Str)`` ``->`` [V #V] | //deviating past 3sg// |
| ``mkV`` | ``(huutaa,huudan,huusi`` ``:`` ``Str)`` ``->`` [V #V] | //also deviating pres. 1sg// |
| ``mkV`` | ``(huutaa,dan,taa,tavat,takaa,detaan,sin,si,sisi,tanut,dettu,tanee`` ``:`` ``Str)`` ``->`` [V #V] | //worst-case verb// |
| ``mkV`` | [VK #VK] ``->`` [V #V] | //verb from DictFin (Kotus)// |
| ``mkV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //hakata päälle (particle verb)// |
| ``mkV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //laimin+lyödä (prefixed verb)// |
| ``caseV`` | [Case #Case] ``->`` [V #V] ``->`` [V #V] | //deviating subj. case, e.g. genitive "täytyä"// |
| ``vOlla`` | [V #V] | //the verb "be"// |
| ``olla_V`` | [V #V] | //-// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //predictable direct transitive// |
| ``mkV2`` | ``Str`` ``->`` [Case #Case] ``->`` [V2 #V2] | //predictable with another case// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //direct transitive// |
| ``mkV2`` | [V #V] ``->`` [Case #Case] ``->`` [V2 #V2] | //complement just case// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //complement pre/postposition// |
| ``mkV2`` | [VK #VK] ``->`` [V2 #V2] | //direct transitive of Kotus verb// |
| ``mkV3`` | ``Str`` ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //e.g. puhua, allative, elative// |
| ``dirV3`` | [V #V] ``->`` [Case #Case] ``->`` [V3 #V3] | //siirtää, (accusative), illative// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //antaa, (accusative), (allative)// |
| ``mkVV`` | ``Str`` ``->`` [VV #VV] | //e.g. "yrittää" (puhua)// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //e.g. "alkaa" (puhua)// |
| ``mkVV`` | ``Str`` ``->`` [InfForm #InfForm] ``->`` [VV #VV] | //e.g. "ruveta" (puhumaan)// |
| ``mkVV`` | [V #V] ``->`` [InfForm #InfForm] ``->`` [VV #VV] | //e.g. "lakata" (puhumasta)// |
| ``mkVS`` | ``Str`` ``->`` [VS #VS] | //e.g. "väittää"// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //e.g. "sanoa"// |
| ``mkV2V`` | ``Str`` ``->`` [V2V #V2V] | //reg verb, partitive + infIllat// |
| ``mkV2V`` | [V #V] ``->`` [V2V #V2V] | //partitive + infillat// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //e.g. "käskeä" genitive + infFiilat// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [InfForm #InfForm] ``->`` [V2V #V2V] | //e.g. "kieltää" partitive infElat// |
| ``mkV2V`` | [V #V] ``->`` [Case #Case] ``->`` [InfForm #InfForm] ``->`` [V2V #V2V] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //e.g. "sanoa" allative// |
| ``mkVVf`` | [V #V] ``->`` [InfForm #InfForm] ``->`` [VV #VV] | //e.g. "ruveta" infIllat// |
| ``mkV2Vf`` | [V #V] ``->`` [Prep #Prep] ``->`` [InfForm #InfForm] ``->`` [V2V #V2V] | //e.g. "kieltää" partitive infElat// |
| ``mkVA`` | [V #V] ``->`` [Prep #Prep] ``->`` [VA #VA] | //e.g. "maistua" ablative// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //e.g. "maalata" accusative translative// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //e.g. "kysyä" ablative// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //-// |
| ``mkPConj`` | ``Str`` ``->`` [PConj #PConj] | //-// |
| ``mkSubj`` | ``Str`` ``->`` [Subj #Subj] | //-// |
| ``mkPredet`` | ``Str`` ``->`` [Predet #Predet] | //invariable Predet, such as "vain"// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
| ``mkDet`` | [Number #Number] ``->`` [N #N] ``->`` [Det #Det] | //-// |
| ``mkDet`` | ``(isNeg`` ``:`` ``Bool)`` ``->`` [Number #Number] ``->`` [N #N] ``->`` [Det #Det] | //use this with True to create a negative determiner// |
| ``mkDet`` | ``(isNeg`` ``:`` ``Bool)`` ``->`` [Number #Number] ``->`` [N #N] ``->`` [Case #Case] ``->`` [Det #Det] | //paljon + False + partitive, ei yhtään + True + partitive// |
| ``mkQuant`` | [N #N] ``->`` [Quant #Quant] | //-// |
| ``mkQuant`` | [N #N] ``->`` [N #N] ``->`` [Quant #Quant] | //-// |
| ``mkInterj`` | ``Str`` ``->`` [Interj #Interj] | //-// |
