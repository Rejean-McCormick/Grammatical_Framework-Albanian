# Paradigms: Mongolian

#LParadigms

source [``../src/mongolian/ParadigmsMon.gf`` http://www.grammaticalframework.org/lib/src/mongolian/ParadigmsMon.gf]

|| Function  | Type  | Explanation ||
| ``mkN`` | ``(_,_`` ``:`` ``Str)`` ``->`` [Noun #Noun] | //-// |
| ``mk2N`` | ``(adj`` ``:`` ``Str)`` ``->`` [Noun #Noun] ``->`` [Noun #Noun] | //-// |
| ``mkLN`` | ``(_,_`` ``:`` ``Str)`` ``->`` [Noun #Noun] | //-// |
| ``regN`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``loanN`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``modDecl`` | ``(Dcl`` ``->`` ``Dcl)`` ``->`` ``Str`` ``->`` [Noun #Noun] | //-// |
| ``modDeclL`` | ``(Dcl`` ``->`` ``Dcl)`` ``->`` ``Str`` ``->`` [Noun #Noun] | //-// |
| ``mkN01a`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``mkN01b`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``mkN01c`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``mkN01d`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``mkN01e`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``mkN01f`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``mkN01g`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``mkN01h`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``mkLN01c`` | ``Str`` ``->`` [Noun #Noun] | //-// |
| ``modDecl2`` | ``(Dcl`` ``->`` ``Dcl)`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Noun #Noun] | //-// |
| ``modDecl2L`` | ``(Dcl`` ``->`` ``Dcl)`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Noun #Noun] | //-// |
| ``reg2N`` | ``(nomSg,nomPl`` ``:`` ``Str)`` ``->`` [Noun #Noun] | //-// |
| ``loan2N`` | ``(nomSg,nomPl`` ``:`` ``Str)`` ``->`` [Noun #Noun] | //-// |
| ``mkN02a`` | ``(nomSg,nomPl`` ``:`` ``Str)`` ``->`` [Noun #Noun] | //-// |
| ``mkN02b`` | ``(nomSg,nomPl`` ``:`` ``Str)`` ``->`` [Noun #Noun] | //-// |
| ``mkN02c`` | ``Str`` ``->`` ``Str`` ``->`` [Noun #Noun] | //-// |
| ``mkN02d`` | ``(nomSg,nomPl`` ``:`` ``Str)`` ``->`` [Noun #Noun] | //-// |
| ``mkN02e`` | ``(nomSg,nomPl`` ``:`` ``Str)`` ``->`` [Noun #Noun] | //-// |
| ``mkNP`` | ``Str`` ``->`` [Def #Def] ``->`` [NP #NP] | //-// |
| ``regV`` | ``Str`` ``->`` [Verb #Verb] | //-// |
| ``verbToAux`` | [Verb #Verb] ``->`` [Aux #Aux] | //-// |
| ``auxToVerb`` | [Aux #Aux] ``->`` [Verb #Verb] | //-// |
| ``mkV`` | ``Str`` ``->`` [Verb #Verb] | //-// |
| ``auxBe`` | [Aux #Aux] | //-// |
