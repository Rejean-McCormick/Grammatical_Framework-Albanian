# Paradigms: Spanish

#LParadigms

source [``../src/spanish/ParadigmsSpa.gf`` http://www.grammaticalframework.org/lib/src/spanish/ParadigmsSpa.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``accusative`` | [Prep #Prep] | //direct object// |
| ``genitive`` | [Prep #Prep] | //preposition "de" and its contractions// |
| ``dative`` | [Prep #Prep] | //preposition "a" and its contractions// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //other preposition// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] ``->`` [Prep #Prep] | //compound prepositions, e.g. "antes de", made as mkPrep "antes" genitive// |
| ``mkN`` | ``(luz`` ``:`` ``Str)`` ``->`` [N #N] | //predictable; feminine for "-a"/"-z", otherwise masculine// |
| ``mkN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //force gender// |
| ``mkN`` | ``(baston,bastones`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //worst case// |
| ``mkN`` | [N #N] ``->`` ``Str`` ``->`` [N #N] | //compound, e.g. "número" + "de teléfono"// |
| ``compN`` | [N #N] ``->`` ``Str`` ``->`` [N #N] | //compound, e.g. "número" + "de teléfono"// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //relational noun with preposition// |
| ``deN2`` | [N #N] ``->`` [N2 #N2] | //relational noun with preposition "de"// |
| ``aN2`` | [N #N] ``->`` [N2 #N2] | //relational noun with preposition "a"// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //prepositions for two complements// |
| ``mkPN`` | ``(Anna`` ``:`` ``Str)`` ``->`` [PN #PN] | //feminine for "-a"// |
| ``mkPN`` | ``(Pilar`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //force gender// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //gender from noun// |
| ``mkA`` | ``(util`` ``:`` ``Str)`` ``->`` [A #A] | //predictable adjective// |
| ``mkA`` | ``(espanol,espanola`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(solo,sola,solos,solas,solamente`` ``:`` ``Str)`` ``->`` [A #A] | //worst-case// |
| ``mkA`` | ``(bueno`` ``:`` ``A)`` ``->`` ``(mejor`` ``:`` ``A)`` ``->`` [A #A] | //special comparison (default with "mas")// |
| ``mkA`` | ``(blanco`` ``:`` ``A)`` ``->`` ``(hueso`` ``:`` ``Str)`` ``->`` [A #A] | //noninflecting component after the adjective// |
| ``prefixA`` | [A #A] ``->`` [A #A] | //adjective before noun (default after noun)// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. "casado" + dative// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //-// |
| ``mkV`` | ``(pagar`` ``:`` ``Str)`` ``->`` [V #V] | //regular in "-ar", "-er", ".ir"// |
| ``mkV`` | ``(mostrar,muestro`` ``:`` ``Str)`` ``->`` [V #V] | //regular with vowel alternation// |
| ``mkV`` | [Verbum #Verbum] ``->`` [V #V] | //import verb constructed with BeschSpa// |
| ``mkV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //particle verb// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive verb// |
| ``special_ppV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //deviant past participle, e.g. abrir - abierto// |
| ``mkV2`` | ``Str`` ``->`` [V2 #V2] | //regular, direct object// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //direct object// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //other object// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //donner (+ accusative + dative)// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //placer (+ accusative) + dans// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //parler + dative + genitive// |
| ``dirV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //e.g. dar,(accusative),a// |
| ``dirdirV3`` | [V #V] ``->`` [V3 #V3] | //e.g. dar,(dative),(accusative)// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``subjVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //plain infinitive: "quiero hablar"// |
| ``deVV`` | [V #V] ``->`` [VV #VV] | //"terminar de hablar"// |
| ``aVV`` | [V #V] ``->`` [VV #VV] | //"aprender a hablar"// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
| ``mkV2S`` | [V #V] ``->`` [V2S #V2S] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkV2A`` | [V #V] ``->`` [V2A #V2A] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
