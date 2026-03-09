# Paradigms: Icelandic

#LParadigms

source [``../src/icelandic/ParadigmsIce.gf`` http://www.grammaticalframework.org/lib/src/icelandic/ParadigmsIce.gf]

|| Function  | Type  | Explanation ||
| ``Gender`` | [Type #Type] | //-// |
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``neuter`` | [Gender #Gender] | //-// |
| ``Number`` | [Type #Type] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``Case`` | [Type #Type] | //-// |
| ``nominative`` | [Case #Case] | //-// |
| ``accusative`` | [Case #Case] | //-// |
| ``dative`` | [Case #Case] | //-// |
| ``genitive`` | [Case #Case] | //-// |
| ``mkN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN`` | ``(_,_`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN`` | ``(_,_,_,_`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkN`` | ``(x1,_,_,_,_,_,_,x8`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkCompoundN`` | ``Str`` ``->`` [N #N] ``->`` [N #N] | //-// |
| ``mkNPlGen`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mk1N`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mk2N`` | ``(_,_`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mk3N`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] ``=\x,y,z,g`` ``->`` ``case`` ``g`` ``of`` ``{`` | //-// |
| ``mk4N`` | ``(_,_,_,_`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] ``=\a,b,c,d,g`` ``->`` ``case`` ``g`` ``of`` ``{`` | //-// |
| ``neutrNForms1`` | ``Str`` ``->`` [NForms #NForms] | //-// |
| ``neutrNForms2`` | ``(_,_`` ``:`` ``Str)`` ``->`` [NForms #NForms] | //-// |
| ``neutrNForms3`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [NForms #NForms] | //-// |
| ``neutrNForms4`` | ``(_,_,_,_`` ``:`` ``Str)`` ``->`` [NForms #NForms] | //-// |
| ``mascNForms1`` | ``Str`` ``->`` [NForms #NForms] | //-// |
| ``mascNForms2`` | ``(_,_`` ``:`` ``Str)`` ``->`` [NForms #NForms] | //-// |
| ``mascNForms3`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [NForms #NForms] ``=\nom,gen,pl`` ``->`` ``case`` ``<nom,gen,pl>`` ``of`` ``{`` | //-// |
| ``mascNForms4`` | ``(_,_,_,_`` ``:`` ``Str)`` ``->`` [NForms #NForms] | //-// |
| ``femNForms1`` | ``Str`` ``->`` [NForms #NForms] | //-// |
| ``femNForms2`` | ``(_,_`` ``:`` ``Str)`` ``->`` [NForms #NForms] | //-// |
| ``femNForms3`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [NForms #NForms] | //-// |
| ``femNForms4`` | ``(_,_,_,_`` ``:`` ``Str)`` ``->`` [NForms #NForms] | //-// |
| ``mk8N`` | ``(x1,_,_,_,_,_,_,x8`` ``:`` ``Str)`` ``->`` [Gender #Gender] ``->`` [N #N] | //-// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //-// |
| ``mkN2`` | [N #N] ``->`` [Preposition #Preposition] ``->`` [N2 #N2] | //-// |
| ``mkN3`` | [N #N] ``->`` ``(_,_`` ``:`` ``Preposition)`` ``->`` [N3 #N3] | //-// |
| ``mkA`` | ``Str`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(_,_`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mkA`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mk1A`` | ``Str`` ``->`` [A #A] | //-// |
| ``mk2A`` | ``(_,_`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``mk3A`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [A #A] | //-// |
| ``strongPosit1`` | ``Str`` ``->`` [AForms #AForms] | //-// |
| ``strongPosit2`` | ``(_,_`` ``:`` ``Str)`` ``->`` [AForms #AForms] | //-// |
| ``weakPosit`` | ``(_,_`` ``:`` ``Str)`` ``->`` [AForms #AForms] | //-// |
| ``compar1`` | ``Str`` ``->`` [AForms #AForms] | //-// |
| ``compar2`` | ``(_,_`` ``:`` ``Str)`` ``->`` [AForms #AForms] | //-// |
| ``weakSuperl`` | ``(_,_`` ``:`` ``Str)`` ``->`` [AForms #AForms] | //-// |
| ``strongSuperl1`` | ``Str`` ``->`` [AForms #AForms] | //-// |
| ``strongSuperl2`` | ``(_,_`` ``:`` ``Str)`` ``->`` [AForms #AForms] | //-// |
| ``regAAdv1`` | ``Str`` ``->`` ``Str`` | //-// |
| ``regAAdv2`` | ``(_,_`` ``:`` ``Str)`` ``->`` ``Str`` | //-// |
| ``addAdv`` | [A #A] ``->`` ``Str`` ``->`` [A #A] | //-// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //-// |
| ``mkV`` | ``Str`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(_,_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(_,_,_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mkV`` | ``(x1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,x59`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mk1V`` | ``Str`` ``->`` [V #V] | //-// |
| ``mk2V`` | ``(_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mk3V`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mk4V`` | ``(_,_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``mk5V`` | ``(_,_,_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``indsub1`` | ``Str`` ``->`` [MForms #MForms] | //-// |
| ``indsub2`` | ``(_,_`` ``:`` ``Str)`` ``->`` [MForms #MForms] | //-// |
| ``indsub3`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [MForms #MForms] | //-// |
| ``impSg`` | ``Str`` ``->`` ``Str`` | //-// |
| ``impPl`` | ``Str`` ``->`` ``Str`` | //-// |
| ``sup`` | ``Str`` ``->`` ``Str`` | //-// |
| ``presPart`` | ``Str`` ``->`` ``Str`` | //-// |
| ``strongPP`` | ``Str`` ``->`` [AForms #AForms] | //-// |
| ``weakPP`` | ``Str`` ``->`` [AForms #AForms] | //-// |
| ``irregV`` | ``Str`` ``->`` [V #V] | //-// |
| ``irregV`` | ``(_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``irregV`` | ``(_,_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``irregV`` | ``(_,_,_,_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``irregV`` | [MForms #MForms] ``->`` ``(_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``irreg1V`` | ``Str`` ``->`` [V #V] | //-// |
| ``irreg2V`` | ``(_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``irreg4V`` | ``(_,_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``irreg6V`` | ``(_,_,_,_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``irreg9V`` | [MForms #MForms] ``->`` ``(_,_`` ``:`` ``Str)`` ``->`` [V #V] | //-// |
| ``impIrregSg`` | ``Str`` ``->`` ``Str`` | //-// |
| ``irregindsub`` | ``Str`` ``->`` [MForms #MForms] | //-// |
| ``irregindsub3`` | ``(_,_,_`` ``:`` ``Str)`` ``->`` [MForms #MForms] | //-// |
| ``irregindsub5`` | ``(_,_,_,_,_`` ``:`` ``Str)`` ``->`` [MForms #MForms] | //-// |
| ``prepV2`` | [V #V] ``->`` [Preposition #Preposition] ``->`` [V2 #V2] | //-// |
| ``prepV3`` | [V #V] ``->`` [Preposition #Preposition] ``->`` [Preposition #Preposition] ``->`` [V3 #V3] | //-// |
| ``accPrep`` | [Preposition #Preposition] | //-// |
| ``mkV2`` | [V #V] ``->`` [V2 #V2] | //-// |
| ``mkV2`` | [V #V] ``->`` [Preposition #Preposition] ``->`` [V2 #V2] | //-// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //-// |
| ``vowel`` | ``pattern`` ``Str`` | //-// |
| ``consonant`` | ``pattern`` ``Str`` | //-// |
| ``regPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [PN #PN] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //-// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //-// |
| ``mkAdN`` | [CAdv #CAdv] ``->`` [AdN #AdN] | //-// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //-// |
| ``mkPrep`` | ``Str`` ``->`` [Case #Case] ``->`` [Prep #Prep] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //-// |
| ``mkConj`` | ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] ``=\y,n`` ``->`` ``mk2Conj`` ``[]`` ``y`` ``n`` | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] ``=\x,y`` ``->`` ``mk2Conj`` ``x`` ``y`` ``plural`` | //-// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] ``=\x,y,n`` ``->`` ``mk2Conj`` ``x`` ``y`` ``n`` | //-// |
| ``mk2Conj`` | ``Str`` ``->`` ``Str`` ``->`` [Number #Number] ``->`` [Conj #Conj] | //-// |
