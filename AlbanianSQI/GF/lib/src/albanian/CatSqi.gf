concrete CatSqi of Cat = CommonX ** open ParamX, Prelude, ResSqi in {

lincat N  = Noun ;
lincat N2 = Noun ** {c2 : Compl} ;
lincat N3 = Noun ** {c2,c3 : Compl} ;

lincat A  = Adj ;
lincat A2 = Adj ** {c2 : Compl} ;

lincat V, VA, VV, VS, VQ = Verb ;
lincat V2, V2S, V2Q      = Verb ** {c2 : Compl} ;
lincat V3, V2A, V2V      = Verb ** {c2,c3 : Compl} ;

lincat Prep = Compl ;

lincat Subj = {s : Str} ;
lincat Conj = {s : Str} ;

lincat Card   = {s : Str} ;
lincat ACard  = {s : Str} ;
lincat Predet = {s : Str} ;
lincat Ord    = {s : Str} ;

lincat IComp  = {s : Str} ;
lincat IP     = {s : Str} ;
lincat IDet   = {s : Str} ;
lincat IQuant = {s : Str} ;

lincat S       = {s : Str} ;
lincat QS      = {s : Str} ;
lincat RS      = {s : Str} ;
lincat SSlash  = {s : Str} ;
lincat Cl      = {s : Str} ;
lincat QCl     = {s : Str} ;
lincat RCl     = {s : Str} ;
lincat RP      = {s : Str} ;
lincat ClSlash = {s : Str} ;

lincat VP      = {s : Str} ;
lincat VPSlash = {s : Str} ;
lincat Comp    = {s : Str} ;

lincat Imp = {s : Str} ;

lincat Numeral = {s : Str} ;
lincat Digits  = {s : Str; n : Number; tail : DTail} ;
lincat Decimal = {s : Str; n : Number; hasDot : Bool} ;

lincat AP    = {s : Species => Case => Gender => Number => Str} ;
lincat CN    = Noun ;
lincat Num   = {s : Str; n : Number} ;
lincat Quant = {s : Case => Gender => Number => Str; spec : Species} ;
lincat Det   = {s : Case => Gender => Str; spec : Species; n : Number} ;
lincat NP    = {s : Case => Str; a : Agr} ;
lincat Pron  = {s : Case => Str; acc_clit, dat_clit : Str; a : Agr} ;

}