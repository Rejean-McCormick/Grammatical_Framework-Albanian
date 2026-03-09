resource ResSqi = ParamX-[Tense,Past,Pres] ** open Prelude in {

oper
  Compl : Type = {s : Str} ;

  mkCompl : Str -> Compl = \s -> {s = s} ;

  -- In CatSqi: Prep = Compl
  Prep : Type = Compl ;
  mkPrep : Str -> Prep = mkCompl ;
  noPrep : Prep = mkPrep [] ;


param
  Species = Indef | Def ;
  Case = Nom | Acc | Dat | Ablat ;
  Gender = Masc | Fem ;

param
  GenNum = GSg Gender | GPl ;

oper
  Agr : Type = {gn : GenNum ; p : Person} ;

  genNum : Gender -> Number -> GenNum = \g,n ->
    case n of {
      Sg => GSg g ;
      Pl => GPl
    } ;

  agrgP3 : Gender -> Number -> Agr =
    \g,n -> {gn = genNum g n ; p = P3} ;


oper
  Noun : Type = {s : Species => Case => Number => Str ; g : Gender} ;

  mkNoun : (_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_ : Str) -> Gender -> Noun =
    \f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,g ->
      { s = table {
              Indef => table {
                         Nom => table {Sg => f1 ;  Pl => f2} ;
                         Acc => table {Sg => f3 ;  Pl => f4} ;
                         Dat => table {Sg => f5 ;  Pl => f6} ;
                         Ablat => table {Sg => f7 ; Pl => f8}
                       } ;
              Def => table {
                       Nom => table {Sg => f9 ;  Pl => f10} ;
                       Acc => table {Sg => f11 ; Pl => f12} ;
                       Dat => table {Sg => f13 ; Pl => f14} ;
                       Ablat => table {Sg => f15 ; Pl => f16}
                     }
            } ;
        g = g
      } ;


oper
  Adj : Type = {s : Case => Gender => Number => Str ; clit : Bool} ;

  mkAdj : (_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_ : Str) -> Bool -> Adj =
    \f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,clit ->
      { s = table {
              Nom => table {
                       Masc => table {Sg => f1 ;  Pl => f2} ;
                       Fem  => table {Sg => f3 ;  Pl => f4}
                     } ;
              Acc => table {
                       Masc => table {Sg => f5 ;  Pl => f6} ;
                       Fem  => table {Sg => f7 ;  Pl => f8}
                     } ;
              Dat => table {
                       Masc => table {Sg => f9 ;  Pl => f10} ;
                       Fem  => table {Sg => f11 ; Pl => f12}
                     } ;
              Ablat => table {
                         Masc => table {Sg => f13 ; Pl => f14} ;
                         Fem  => table {Sg => f15 ; Pl => f16}
                       }
            } ;
        clit = clit
      } ;


param
  Tense = Pres | Past | Imperfect | Aorist ;

oper
  Verb : Type = {
    Indicative       : Tense => Number => Person => Str ;
    Imperative       : Number => Str ;
    participle       : Str ;
    pres_optative    : Number => Person => Str ;
    perf_optative    : Number => Person => Str ;
    pres_admirative  : Number => Person => Str ;
    imperf_admirative: Number => Person => Str
  } ;

  mkVerb :
    (_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_ : Str) -> Verb =
    \f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20,f21,f22,f23,f24,f25,f26,f27,
     f28,f29,f30,f31,f32,f33,f34,f35,f36,f37,f38,f39,f40,f41,f42,f43,f44,f45,f46,f47,f48,f49,f50,f51 ->
      { Indicative = table {
            Pres => table {
                     Sg => table {P1 => f1 ;  P2 => f2 ;  P3 => f3} ;
                     Pl => table {P1 => f4 ;  P2 => f5 ;  P3 => f6}
                   } ;
            Past => table {
                     Sg => table {P1 => f7 ;  P2 => f8 ;  P3 => f9} ;
                     Pl => table {P1 => f10 ; P2 => f11 ; P3 => f12}
                   } ;
            Aorist => table {
                       Sg => table {P1 => f13 ; P2 => f14 ; P3 => f15} ;
                       Pl => table {P1 => f16 ; P2 => f17 ; P3 => f18}
                     } ;
            Imperfect => table {
                          Sg => table {P1 => f19 ; P2 => f20 ; P3 => f21} ;
                          Pl => table {P1 => f22 ; P2 => f23 ; P3 => f24}
                        }
          } ;
        Imperative = table {Sg => f25 ; Pl => f26} ;
        participle = f27 ;
        pres_optative = table {
                          Sg => table {P1 => f28 ; P2 => f29 ; P3 => f30} ;
                          Pl => table {P1 => f31 ; P2 => f32 ; P3 => f33}
                        } ;
        perf_optative = table {
                          Sg => table {P1 => f34 ; P2 => f35 ; P3 => f36} ;
                          Pl => table {P1 => f37 ; P2 => f38 ; P3 => f39}
                        } ;
        pres_admirative = table {
                             Sg => table {P1 => f40 ; P2 => f41 ; P3 => f42} ;
                             Pl => table {P1 => f43 ; P2 => f44 ; P3 => f45}
                           } ;
        imperf_admirative = table {
                               Sg => table {P1 => f46 ; P2 => f47 ; P3 => f48} ;
                               Pl => table {P1 => f49 ; P2 => f50 ; P3 => f51}
                             }
      } ;


oper
  -- Match CatSqi lincat Pron
  Pron : Type = {s : Case => Str ; acc_clit, dat_clit : Str ; a : Agr} ;

  mkPron : (_,_,_,_,_,_ : Str) -> GenNum -> Person -> Pron =
    \nom,acc,dat,ablat,accC,datC,gn,p ->
      { s = table {Nom => nom ; Acc => acc ; Dat => dat ; Ablat => ablat} ;
        acc_clit = accC ;
        dat_clit = datC ;
        a = {gn = gn ; p = p}
      } ;


oper
  Quant : Type = {s : Case => Gender => Number => Str ; spec : Species} ;

  mkQuant : (_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_ : Str) -> Quant =
    \f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16 -> {
      s = table {
            Nom => table {
                     Masc => table {Sg => f1 ;  Pl => f2} ;
                     Fem  => table {Sg => f3 ;  Pl => f4}
                   } ;
            Acc => table {
                     Masc => table {Sg => f5 ;  Pl => f6} ;
                     Fem  => table {Sg => f7 ;  Pl => f8}
                   } ;
            Dat => table {
                     Masc => table {Sg => f9 ;  Pl => f10} ;
                     Fem  => table {Sg => f11 ; Pl => f12}
                   } ;
            Ablat => table {
                      Masc => table {Sg => f13 ; Pl => f14} ;
                      Fem  => table {Sg => f15 ; Pl => f16}
                    }
          } ;
      spec = Indef
    } ;


oper
  Det : Type = {s : Case => Gender => Str ; n : Number ; spec : Species} ;

  mkDet : (Number -> Species -> Case -> Gender -> Str) -> Det = \f -> {
    s = \\c,g => f Sg Indef c g ;
    n = Sg ;
    spec = Indef
  } ;

  mkNum : Str -> Number -> {s : Str ; n : Number} = \s,n -> {s=s ; n=n} ;


oper
  link_clitic : Species => Case => Gender => Number => Str =
    table {
      Indef => table {
        Nom => table { _ => table { _ => "i" } } ;
        Acc => table {
                 Masc => table {Sg => "të" ; Pl => "e"} ;
                 Fem  => table {Sg => "të" ; Pl => "e"}
               } ;
        Dat => table {
                 Masc => table {Sg => "të" ; Pl => "të"} ;
                 Fem  => table {Sg => "të" ; Pl => "të"}
               } ;
        Ablat => table {
                   Masc => table {Sg => "të" ; Pl => "të"} ;
                   Fem  => table {Sg => "të" ; Pl => "të"}
                 }
      } ;
      Def => table {
        Nom => table { _ => table { _ => "i" } } ;
        Acc => table {
                 Masc => table {Sg => "e" ; Pl => "e"} ;
                 Fem  => table {Sg => "e" ; Pl => "e"}
               } ;
        Dat => table {
                 Masc => table {Sg => "të" ; Pl => "të"} ;
                 Fem  => table {Sg => "të" ; Pl => "të"}
               } ;
        Ablat => table {
                   Masc => table {Sg => "të" ; Pl => "të"} ;
                   Fem  => table {Sg => "të" ; Pl => "të"}
                 }
      }
    } ;

}