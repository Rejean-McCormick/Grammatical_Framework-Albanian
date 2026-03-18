-- GF/lib/src/albanian/StructuralSqiVerbal.gf
resource StructuralSqiVerbal =
  open Prelude, ParamX, ResSqi, CatSqi, (P = ParadigmsSqi) in {

oper
  -- Compile-safe fallback for verbs we do not want ParadigmsSqi.mkV to analyze.
  mkVConst : CatSqi.V -> Str -> CatSqi.V =
    \_ , x -> lin V {
      Indicative = table {
        ParamX.Pres => table {
          Sg => table {P1 => x ; P2 => x ; P3 => x} ;
          Pl => table {P1 => x ; P2 => x ; P3 => x}
        } ;
        ParamX.Past => table {
          Sg => table {P1 => x ; P2 => x ; P3 => x} ;
          Pl => table {P1 => x ; P2 => x ; P3 => x}
        } ;
        Aorist => table {
          Sg => table {P1 => x ; P2 => x ; P3 => x} ;
          Pl => table {P1 => x ; P2 => x ; P3 => x}
        } ;
        Imperfect => table {
          Sg => table {P1 => x ; P2 => x ; P3 => x} ;
          Pl => table {P1 => x ; P2 => x ; P3 => x}
        }
      } ;
      Imperative = table {
        Sg => x ;
        Pl => x
      } ;
      participle = x ;
      pres_optative = table {
        Sg => table {P1 => x ; P2 => x ; P3 => x} ;
        Pl => table {P1 => x ; P2 => x ; P3 => x}
      } ;
      perf_optative = table {
        Sg => table {P1 => x ; P2 => x ; P3 => x} ;
        Pl => table {P1 => x ; P2 => x ; P3 => x}
      } ;
      pres_admirative = table {
        Sg => table {P1 => x ; P2 => x ; P3 => x} ;
        Pl => table {P1 => x ; P2 => x ; P3 => x}
      } ;
      imperf_admirative = table {
        Sg => table {P1 => x ; P2 => x ; P3 => x} ;
        Pl => table {P1 => x ; P2 => x ; P3 => x}
      }
    } ;

  can8know_VV : CatSqi.VV =
    P.mkVV (mkVConst (lin V {Indicative = Predef.error "unused" ; Imperative = Predef.error "unused" ; participle = [] ; pres_optative = Predef.error "unused" ; perf_optative = Predef.error "unused" ; pres_admirative = Predef.error "unused" ; imperf_admirative = Predef.error "unused"}) "di") ;

  can_VV : CatSqi.VV =
    P.mkVV (mkVConst (lin V {Indicative = Predef.error "unused" ; Imperative = Predef.error "unused" ; participle = [] ; pres_optative = Predef.error "unused" ; perf_optative = Predef.error "unused" ; pres_admirative = Predef.error "unused" ; imperf_admirative = Predef.error "unused"}) "mundem") ;

  -- Keep disabled until the GeneratePMCFG crash source is isolated.
  -- must_VV : CatSqi.VV =
  --   P.mkVV (mkVConst (lin V {Indicative = Predef.error "unused" ; Imperative = Predef.error "unused" ; participle = [] ; pres_optative = Predef.error "unused" ; perf_optative = Predef.error "unused" ; pres_admirative = Predef.error "unused" ; imperf_admirative = Predef.error "unused"}) "duhet") ;

  want_VV : CatSqi.VV =
    P.mkVV (mkVConst (lin V {Indicative = Predef.error "unused" ; Imperative = Predef.error "unused" ; participle = [] ; pres_optative = Predef.error "unused" ; perf_optative = Predef.error "unused" ; pres_admirative = Predef.error "unused" ; imperf_admirative = Predef.error "unused"}) "dua") ;

  have_V2 : CatSqi.V2 =
    P.mkV2 (mkVConst (lin V {Indicative = Predef.error "unused" ; Imperative = Predef.error "unused" ; participle = [] ; pres_optative = Predef.error "unused" ; perf_optative = Predef.error "unused" ; pres_admirative = Predef.error "unused" ; imperf_admirative = Predef.error "unused"}) "kam") ;

} ;