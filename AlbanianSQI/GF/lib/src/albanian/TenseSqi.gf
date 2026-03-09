-- GF/lib/src/albanian/TenseSqi.gf
concrete TenseSqi of Tense = open Prelude in {

  param
    TForm = Pres | Past | Fut | Cond ;
    AForm = Simul | Anter ;
    PForm = Pos | Neg ;

  lincat
    Tense = {t : TForm} ;
    Ant   = {a : AForm} ;
    Pol   = {p : PForm} ;
    Temp  = {t : TForm ; a : AForm} ;

  lin
    TPres = {t = Pres} ;
    TPast = {t = Past} ;
    TFut  = {t = Fut} ;
    TCond = {t = Cond} ;

    ASimul = {a = Simul} ;
    AAnter = {a = Anter} ;

    PPos = {p = Pos} ;
    PNeg = {p = Neg} ;

    TTAnt t a = {t = t.t ; a = a.a} ;

}