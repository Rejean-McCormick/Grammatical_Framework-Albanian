# Paradigms: Arabic

#LParadigms

source [``../src/arabic/ParadigmsAra.gf`` http://www.grammaticalframework.org/lib/src/arabic/ParadigmsAra.gf]

|| Function  | Type  | Explanation ||
| ``Case`` | [Type #Type] | //-// |
| ``nom`` | [Case #Case] | //-// |
| ``acc`` | [Case #Case] | //-// |
| ``gen`` | [Case #Case] | //-// |
| ``Preposition`` | [Type #Type] | //-// |
| ``noPrep`` | [Preposition #Preposition] | //-// |
| ``casePrep`` | [Case #Case] ``->`` [Preposition #Preposition] | //-// |
| ``Gender`` | [Type #Type] | //-// |
| ``masc`` | [Gender #Gender] | //-// |
| ``fem`` | [Gender #Gender] | //-// |
| ``Number`` | [Type #Type] | //-// |
| ``sg`` | [Number #Number] | //-// |
| ``pl`` | [Number #Number] | //-// |
| ``Species`` | [Type #Type] | //-// |
| ``hum`` | [Species #Species] | //-// |
| ``nohum`` | [Species #Species] | //-// |
| ``Vowel`` | [Type #Type] | //-// |
| ``va`` | [Vowel #Vowel] | //-// |
| ``vi`` | [Vowel #Vowel] | //-// |
| ``vu`` | [Vowel #Vowel] | //-// |
| ``mkN`` | ``(sg`` ``:`` ``Str)`` ``->`` [N #N] | //non-human regular nouns// |
| ``mkN`` | [Species #Species] ``->`` [N #N] ``->`` [N #N] | //-// |
| ``mkN`` | ``(sg,pl`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [Species #Species] ``->`` [N #N] | //-// |
| ``mkN`` | [NTable #NTable] ``->`` [Gender #Gender] ``->`` [Species #Species] ``->`` [N #N] | //loan words, irregular// |
| ``mkN`` | ``(root,sgPatt,brokenPlPatt`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [Species #Species] ``->`` [N #N] | //broken plural// |
| ``mkN`` | [N #N] ``->`` ``(attr`` ``:`` ``Str)`` ``->`` [N #N] | //Compound noun with invariant attribute// |
| ``mkN`` | [N #N] ``->`` [N #N] ``->`` [N #N] | //Compound noun where attribute inflects in state and case. Attribute in singular.// |
| ``mkN`` | [Number #Number] ``->`` [N #N] ``->`` [N #N] ``->`` [N #N] | //Compound noun where attribute inflects in state and case. Attribute's number specified by 1st arg.// |
| ``dualN`` | [N #N] ``->`` [N #N] | //Force the plural of the N into dual (e.g. "twins")// |
| ``mkFullN`` | [NTable #NTable] ``->`` [Gender #Gender] ``->`` [Species #Species] ``->`` [N #N] | //-// |
| ``brkN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Gender #Gender] ``->`` [Species #Species] ``->`` [N #N] | //-// |
| ``sdfN`` | ``Str`` ``->`` ``Str`` ``->`` [Gender #Gender] ``->`` [Species #Species] ``->`` [N #N] | //-// |
| ``sdmN`` | ``Str`` ``->`` ``Str`` ``->`` [Gender #Gender] ``->`` [Species #Species] ``->`` [N #N] | //-// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //Fem Hum if ends with ة, otherwise Masc Hum// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //-// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [Species #Species] ``->`` [PN #PN] | //-// |
| ``mkFullPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [Species #Species] ``->`` [PN #PN] | //-// |
| ``mkN2`` | [N #N] ``->`` [Preposition #Preposition] ``->`` [N2 #N2] | //ready-made preposition// |
| ``mkN2`` | [N #N] ``->`` ``Str`` ``->`` [N2 #N2] | //preposition given as a string// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //no preposition// |
| ``mkN2`` | ``Str`` ``->`` [N2 #N2] | //no preposition, predictable inflection// |
| ``mkN3`` | [N #N] ``->`` [Preposition #Preposition] ``->`` [Preposition #Preposition] ``->`` [N3 #N3] | //ready-made prepositions// |
| ``mkN3`` | [N #N] ``->`` ``Str`` ``->`` ``Str`` ``->`` [N3 #N3] | //prepositions given as strings// |
| ``mkA`` | ``(root,sg`` ``:`` ``Str)`` ``->`` [A #A] | //adjective with sound plural; takes root string and sg. pattern string// |
| ``mkA`` | ``(root`` ``:`` ``Str)`` ``->`` [A #A] | //adjective with positive form aFCal// |
| ``mkA`` | ``(root,sg,pl`` ``:`` ``Str)`` ``->`` [A #A] | //adjective with broken plural// |
| ``degrA`` | ``(posit,compar,plur`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``sndA`` | ``(root,patt`` ``:`` ``Str)`` ``->`` [Adj #Adj] | //-// |
| ``clrA`` | ``(root`` ``:`` ``Str)`` ``->`` [Adj #Adj] | //forms adjectives of type aFCal// |
| ``nisbaA`` | ``Str`` ``->`` [Adj #Adj] | //forms relative adjectives by adding the suffix ِيّ// |
| ``mkA2`` | [A #A] ``->`` [Preposition #Preposition] ``->`` [A2 #A2] | //-// |
| ``mkA2`` | [A #A] ``->`` ``Str`` ``->`` [A2 #A2] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
| ``mkInterj`` | ``Str`` ``->`` [Interj #Interj] | //-// |
| ``mkSubj`` | ``Str`` ``->`` [Subj #Subj] | //Default order Subord (=noun first and in accusative)// |
| ``mkSubj`` | ``Str`` ``->`` [Order #Order] ``->`` [Subj #Subj] | //Specify word order// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Case #Case] ``->`` [Prep #Prep] | //-// |
| ``mkV`` | ``(imperfect`` ``:`` ``Str)`` ``->`` [V #V] | //The verb in Per3 Sg Masc imperfect tense gives the most information// |
| ``mkV`` | ``(root`` ``:`` ``Str)`` ``->`` ``(perf,impf`` ``:`` ``Vowel)`` ``->`` [V #V] | //verb form I ; vowel// |
| ``mkV`` | ``(root`` ``:`` ``Str)`` ``->`` [VerbForm #VerbForm] ``->`` [V #V] | //FormI .. FormX (no VII, IX) ; default vowels a u for I// |
| ``mkV`` | [V #V] ``->`` ``(particle`` ``:`` ``Str)`` ``->`` [V #V] | //V with a non-inflecting particle/phrasal verb// |
| ``reflV`` | [V #V] ``->`` [V #V] | //نَفْس in the proper case and with possessive suffix, e.g. نَفْسَكِ// |
| ``v1`` | ``Str`` ``->`` [Vowel #Vowel] ``->`` [Vowel #Vowel] ``->`` [V #V] | //Verb Form I : fa`ala, fa`ila, fa`ula// |
| ``v2`` | ``Str`` ``->`` [V #V] | //Verb Form II : fa``ala// |
| ``v3`` | ``Str`` ``->`` [V #V] | //Verb Form III : faa`ala// |
| ``v4`` | ``Str`` ``->`` [V #V] | //Verb Form IV : 'af`ala// |
| ``v5`` | ``Str`` ``->`` [V #V] | //Verb Form V : tafa``ala// |
| ``v6`` | ``Str`` ``->`` [V #V] | //Verb Form VI : tafaa`ala// |
| ``v7`` | ``Str`` ``->`` [V #V] | //Verb Form VII : infa`ala// |
| ``v8`` | ``Str`` ``->`` [V #V] | //Verb Form VIII ifta`ala// |
| ``v10`` | ``Str`` ``->`` [V #V] | //Verb Form X 'istaf`ala// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //No preposition// |
| ``mkV2`` | [V #V] ``->`` ``Str`` ``->`` [V2 #V2] | //Preposition as string, default case genitive// |
| ``mkV2`` | [V #V] ``->`` [Preposition #Preposition] ``->`` [V2 #V2] | //Ready-made preposition// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //Predictable verb conjugation, no preposition// |
| ``dirV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV3`` | [V #V] ``->`` [Preposition #Preposition] ``->`` [Preposition #Preposition] ``->`` [V3 #V3] | //speak, with, about// |
| ``mkV3`` | [V #V] ``->`` ``(to`` ``:`` ``Str)`` ``->`` ``(about:Str)`` ``->`` [V3 #V3] | //like above, but with strings as arguments (default complement case genitive)// |
| ``dirV3`` | [V #V] ``->`` [Preposition #Preposition] ``->`` [V3 #V3] | //give,_,to// |
| ``dirV3`` | [V #V] ``->`` ``(to`` ``:`` ``Str)`` ``->`` [V3 #V3] | //like above, but with string as argument (default complement case genitive)// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //give,_,_// |
| ``mkV0`` | [V #V] ``->`` [V0 #V0] | //-// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkV2S`` | [V #V] ``->`` ``Str`` ``->`` [V2S #V2S] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //-// |
| ``mkVV`` | [V #V] ``->`` ``Str`` ``->`` [VV #VV] | //-// |
| ``mkVV`` | [V #V] ``->`` [Preposition #Preposition] ``->`` [VV #VV] | //-// |
| ``mkVV`` | [V #V] ``->`` [Preposition #Preposition] ``->`` [Preposition #Preposition] ``->`` [VV #VV] | //-// |
| ``mkV2V`` | [V #V] ``->`` ``Str`` ``->`` ``Str`` ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Preposition #Preposition] ``->`` [Preposition #Preposition] ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [VV #VV] ``->`` [Preposition #Preposition] ``->`` [V2V #V2V] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkV2A`` | [V #V] ``->`` ``Str`` ``->`` [V2A #V2A] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` ``Str`` ``->`` [V2Q #V2Q] | //-// |
| ``mkAS`` | [A #A] ``->`` [AS #AS] | //-// |
| ``mkA2S`` | [A #A] ``->`` ``Str`` ``->`` [A2S #A2S] | //-// |
| ``mkAV`` | [A #A] ``->`` [AV #AV] | //-// |
| ``mkA2V`` | [A #A] ``->`` ``Str`` ``->`` [A2V #A2V] | //-// |
| ``V0`` | [Type #Type] | //-// |
