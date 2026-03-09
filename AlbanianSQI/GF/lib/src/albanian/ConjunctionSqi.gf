concrete ConjunctionSqi of Conjunction = CatSqi **
  open Coordination, ResSqi, Prelude in {

  oper
    commaSep : Str = ", " ;
    conjSep  : Conj -> Str = \c -> " " ++ c.s ++ " " ;

  lincat
    ListS    = {init : Str ; last : Str} ;

    ListNP   = {init : Case => Str ; last : Case => Str ; a : Agr} ;

    ListCN   = {init : Species => Case => Number => Str ;
                last : Species => Case => Number => Str ;
                g : Gender} ;

    ListAP   = {init : Species => Case => Gender => Number => Str ;
                last : Species => Case => Gender => Number => Str} ;

    ListAdv  = {init : Str ; last : Str} ;
    ListAdV  = {init : Str ; last : Str} ;
    ListIAdv = {init : Str ; last : Str} ;
    ListRS   = {init : Str ; last : Str} ;

    -- IMPORTANT:
    -- In your CatSqi, DAP is *not* defined, so GF inserts default: DAP = {s : Str}.
    -- Therefore ListDAP must be stringy, and ConjDet must construct a Det by
    -- using the same surface string for all Case/Gender.
    ListDAP  = {init : Str ;
                last : Str ;
                spec : Species ;
                n : Number} ;

  lin
    BaseS x y = {init = x.s ; last = y.s} ;
    ConsS x xs = {init = x.s ++ commaSep ++ xs.init ; last = xs.last} ;
    ConjS c xs = {s = xs.init ++ conjSep c ++ xs.last} ;

    BaseNP x y =
      { init = \\c => x.s ! c ;
        last = \\c => y.s ! c ;
        a = x.a
      } ;
    ConsNP x xs =
      { init = \\c => x.s ! c ++ commaSep ++ xs.init ! c ;
        last = xs.last ;
        a = xs.a
      } ;
    ConjNP c xs =
      { s = \\cse => xs.init ! cse ++ conjSep c ++ xs.last ! cse ;
        a = xs.a
      } ;

    BaseCN x y =
      { init = \\sp,cse,n => x.s ! sp ! cse ! n ;
        last = \\sp,cse,n => y.s ! sp ! cse ! n ;
        g = x.g
      } ;
    ConsCN x xs =
      { init = \\sp,cse,n => x.s ! sp ! cse ! n ++ commaSep ++ xs.init ! sp ! cse ! n ;
        last = xs.last ;
        g = xs.g
      } ;
    ConjCN c xs =
      { s = \\sp,cse,n => xs.init ! sp ! cse ! n ++ conjSep c ++ xs.last ! sp ! cse ! n ;
        g = xs.g
      } ;

    BaseAP x y =
      { init = \\sp,cse,g,n => x.s ! sp ! cse ! g ! n ;
        last = \\sp,cse,g,n => y.s ! sp ! cse ! g ! n
      } ;
    ConsAP x xs =
      { init = \\sp,cse,g,n => x.s ! sp ! cse ! g ! n ++ commaSep ++ xs.init ! sp ! cse ! g ! n ;
        last = xs.last
      } ;
    ConjAP c xs =
      { s = \\sp,cse,g,n => xs.init ! sp ! cse ! g ! n ++ conjSep c ++ xs.last ! sp ! cse ! g ! n
      } ;

    BaseAdv x y = {init = x.s ; last = y.s} ;
    ConsAdv x xs = {init = x.s ++ commaSep ++ xs.init ; last = xs.last} ;
    ConjAdv c xs = {s = xs.init ++ conjSep c ++ xs.last} ;

    BaseAdV x y = {init = x.s ; last = y.s} ;
    ConsAdV x xs = {init = x.s ++ commaSep ++ xs.init ; last = xs.last} ;
    ConjAdV c xs = {s = xs.init ++ conjSep c ++ xs.last} ;

    BaseIAdv x y = {init = x.s ; last = y.s} ;
    ConsIAdv x xs = {init = x.s ++ commaSep ++ xs.init ; last = xs.last} ;
    ConjIAdv c xs = {s = xs.init ++ conjSep c ++ xs.last} ;

    BaseRS x y = {init = x.s ; last = y.s} ;
    ConsRS x xs = {init = x.s ++ commaSep ++ xs.init ; last = xs.last} ;
    ConjRS c xs = {s = xs.init ++ conjSep c ++ xs.last} ;

    -- FIX: these were missing in your module (you saw "no linearization of BaseDAP/ConsDAP")
    BaseDAP x y =
      { init = x.s ;
        last = y.s ;
        spec = Indef ;
        n = Sg
      } ;

    ConsDAP x xs =
      { init = x.s ++ commaSep ++ xs.init ;
        last = xs.last ;
        spec = xs.spec ;
        n = xs.n
      } ;

    -- FIX: must match the stringy ListDAP above
    ConjDet c xs =
      { s = \\cse,g => xs.init ++ conjSep c ++ xs.last ;
        spec = xs.spec ;
        n = xs.n
      } ;

}