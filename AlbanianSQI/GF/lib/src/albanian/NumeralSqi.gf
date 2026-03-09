concrete NumeralSqi of Numeral = CatSqi ** open ParamX, Prelude in {

  flags optimize=all_subs ;

  oper
    -- "bind" = no-space concatenation (uses BIND explicitly)
    bind : Str -> Str -> Str = \a,b -> a ++ BIND ++ b ;

    bind3 : Str -> Str -> Str -> Str = \a,b,c -> bind a (bind b c) ;

  param
    DForm = unit | teen | ten ;

  oper
    LinDigit  = {s : DForm => Str} ;
    LinSub100 = {s : Str} ;

  lincat
    Digit      = LinDigit ;
    Sub10      = LinDigit ;
    Sub100     = LinSub100 ;
    Sub1000    = LinSub100 ;
    Sub1000000 = {s : Str} ;

  oper
    mkNum : Str -> LinDigit = \tri ->
      {s = table {
        unit => tri ;
        teen => bind3 tri "mbë" "dhjetë" ;
        ten  => bind tri "dhjetë"
      }} ;

  lin
    num x = {s = x.s} ;

    n2 = {
      s = table {
        unit => "dy" ;
        teen => bind3 "dy" "mbë" "dhjetë" ;   -- dymbëdhjetë
        ten  => "njëzet"
      }
    } ;

    -- Albanian 30 is irregular: "tridhjetë"
    n3 = {
      s = table {
        unit => "tre" ;
        teen => bind3 "tre" "mbë" "dhjetë" ;
        ten  => "tridhjetë"
      }
    } ;

    n4 = {
      s = table {
        unit => "katër" ;
        teen => bind3 "katër" "mbë" "dhjetë" ;
        ten  => "dyzet"
      }
    } ;

    n5 = mkNum "pesë" ;
    n6 = mkNum "gjashtë" ;
    n7 = mkNum "shtatë" ;
    n8 = mkNum "tetë" ;
    n9 = mkNum "nëntë" ;

  oper
    mkR : Str -> LinSub100 = \n -> {s = n} ;

  lin
    pot01 = {s = table {_ => "një"}} ;
    pot0 d = d ;

    pot110 = mkR "dhjetë" ;
    pot111 = mkR (bind3 "një" "mbë" "dhjetë") ;

    pot1to19 d = mkR (d.s ! teen) ;
    pot0as1 n  = mkR (n.s ! unit) ;

    pot1 d = mkR (d.s ! ten) ;
    pot1plus d e = mkR ((d.s ! ten) ++ "e" ++ (e.s ! unit)) ;
    pot1as2 n = n ;

    pot2 d = mkR (bind (d.s ! unit) "qind") ;
    pot2plus d e = mkR ((bind (d.s ! unit) "qind") ++ "e" ++ e.s) ;
    pot2as3 n = {s = n.s} ;

    pot3 n = {s = n.s ++ "mijë"} ;
    pot3plus n m = {s = n.s ++ "mijë" ++ "e" ++ m.s} ;

  lincat
    Dig = {s : Str; n : Number} ;

  lin
    IDig d = d ** {tail = T1} ;

    IIDig d i = {
      s = d.s ++ spaceIf i.tail ++ i.s ;
      n = Pl ;
      tail = inc i.tail
    } ;

    D_0 = mkDig "0" Pl ;
    D_1 = mkDig "1" Sg ;
    D_2 = mkDig "2" Pl ;
    D_3 = mkDig "3" Pl ;
    D_4 = mkDig "4" Pl ;
    D_5 = mkDig "5" Pl ;
    D_6 = mkDig "6" Pl ;
    D_7 = mkDig "7" Pl ;
    D_8 = mkDig "8" Pl ;
    D_9 = mkDig "9" Pl ;

    PosDecimal d = d ** {hasDot = False} ;
    NegDecimal d = {s = "-" ++ BIND ++ d.s; hasDot = False; n = Pl} ;

    IFrac d i = {
      s = d.s ++ if_then_Str d.hasDot BIND (BIND ++ "," ++ BIND) ++ i.s ;
      hasDot = True ;
      n = Pl
    } ;

  oper
    mkDig : Str -> Number -> Dig = \s,n -> lin Dig {s = s; n = n} ;

    spaceIf : DTail -> Str = \t -> case t of {
      T3 => "" ;
      _  => BIND
    } ;

    inc : DTail -> DTail = \t -> case t of {
      T1 => T2 ;
      T2 => T3 ;
      T3 => T1
    } ;

}
