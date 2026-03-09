concrete TextSqi of Text = CatSqi ** open Prelude in {

  lin
    TEmpty = {s = []} ;

    TFullStop p t = {s = p.s ++ "." ++ t.s} ;
    TQuestMark p t = {s = p.s ++ "?" ++ t.s} ;
    TExclMark p t  = {s = p.s ++ "!" ++ t.s} ;

    TComma p t = {s = p.s ++ "," ++ t.s} ;
    TSemicolon p t = {s = p.s ++ ";" ++ t.s} ;
    TColon p t = {s = p.s ++ ":" ++ t.s} ;

}