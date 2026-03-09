# Paradigms: French

#LParadigms

source [``../src/french/ParadigmsFre.gf`` http://www.grammaticalframework.org/lib/src/french/ParadigmsFre.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``accusative`` | [Prep #Prep] | //direct object case// |
| ``genitive`` | [Prep #Prep] | //genitive, constructed with "de"// |
| ``dative`` | [Prep #Prep] | //dative, usually constructed with "à"// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] | //simple preposition (other than "de" and "à")// |
| ``mkPrep`` | ``Str`` ``->`` [Prep #Prep] ``->`` [Prep #Prep] | //complex preposition e.g. "à côté de"// |
| ``mkN`` | ``(cheval`` ``:`` ``Str)`` ``->`` [N #N] | //predictable, with variations like cheval-chevaux// |
| ``mkN`` | ``(oeil,yeux`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //worst-case noun// |
| ``mkN`` | [N #N] ``->`` ``Str`` ``->`` [N #N] | //compound noun, e.g. numéro + de téléphone// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //e.g. fille + genitive// |
| ``mkN3`` | [N #N] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //e.g. connection + genitive + dative// |
| ``mkPN`` | ``Str`` ``->`` [PN #PN] | //feminine if ends with "e", otherwise masculine// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //gender deviant from the simple rule// |
| ``mkPN`` | [N #N] ``->`` [PN #PN] | //gender inherited from noun// |
| ``mkA`` | ``(cher`` ``:`` ``Str)`` ``->`` [A #A] | //predictable, e.g. cher-chère// |
| ``mkA`` | ``(sec,seche`` ``:`` ``Str)`` ``->`` [A #A] | //unpredictable feminine// |
| ``mkA`` | ``(banal,banale,banaux`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(banal,banale,banaux,banalement`` ``:`` ``Str)`` ``->`` [A #A] | //worst-case adjective// |
| ``mkA`` | [A #A] ``->`` [A #A] ``->`` [A #A] | //irregular comparison, e.g. bon-meilleur// |
| ``prefixA`` | [A #A] ``->`` [A #A] | //adjective that comes before noun, e.g. petit// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //e.g. supérieur + dative// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //ordinary adverb// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //sentential adverb, e.g. toujours// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //modify adjective, e.g. très// |
| ``mkV`` | ``(finir`` ``:`` ``Str)`` ``->`` [V #V] | //regular 1/2/3 conjugation// |
| ``mkV`` | ``(jeter,jette`` ``:`` ``Str)`` ``->`` [V #V] | //1st and 2nd conjugation variations// |
| ``mkV`` | ``(jeter,jette,jettera`` ``:`` ``Str)`` ``->`` [V #V] | //1st conjugation variations// |
| ``mkV`` | ``(tenir,tiens,tenons,tiennent,tint,tiendra,tenu`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(tenir,tiens,tient,tenons,tenez,tiennent,tienne,tenions,tiensI,tint,tiendra,tenu`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV`` | [V2 #V2] ``->`` [V #V] | //make 2-place to 1-place (e.g. from IrregFre)// |
| ``mkV`` | [V #V] ``->`` ``Str`` ``->`` [V #V] | //-// |
| ``etreV`` | [V #V] ``->`` [V #V] | //force auxiliary to be être (default avoir)// |
| ``reflV`` | [V #V] ``->`` [V #V] | //reflexive, implies auxiliary être, e.g. se demander// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //direct transitive// |
| ``mkV2`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2 #V2] | //e.g. se fier + genitive// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //donner (+ accusative + dative)// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //placer (+ accusative) + dans// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //parler + dative + genitive// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``subjVS`` | [V #V] ``->`` [VS #VS] | //-// |
| ``mkVV`` | [V #V] ``->`` [VV #VV] | //plain infinitive: "je veux parler"// |
| ``deVV`` | [V #V] ``->`` [VV #VV] | //"j'essaie de parler"// |
| ``aVV`` | [V #V] ``->`` [VV #VV] | //"j'arrive à parler"// |
| ``mkV2S`` | [V #V] ``->`` [V2S #V2S] | //-// |
| ``mkV2S`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2S #V2S] | //-// |
| ``mkV2V`` | [V #V] ``->`` [V2V #V2V] | //-// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //-// |
| ``mkVA`` | [V #V] ``->`` [VA #VA] | //-// |
| ``mkV2A`` | [V #V] ``->`` [V2A #V2A] | //-// |
| ``mkV2A`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2A #V2A] | //-// |
| ``mkVQ`` | [V #V] ``->`` [VQ #VQ] | //-// |
| ``mkV2Q`` | [V #V] ``->`` [Prep #Prep] ``->`` [V2Q #V2Q] | //-// |
