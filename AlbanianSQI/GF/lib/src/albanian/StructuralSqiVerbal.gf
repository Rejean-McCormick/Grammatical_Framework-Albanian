-- GF/lib/src/albanian/StructuralSqiVerbal.gf
resource StructuralSqiVerbal =
  open Prelude, ParamX, ResSqi, CatSqi, (P = ParadigmsSqi) in {

oper
  -- Compile-safe fallback for irregular verbs that do not fit ParadigmsSqi.mkV.
  -- This preserves the intended lemma surface in Structural items without
  -- forcing a guessed regular paradigm.
  mkVConst : Str -> CatSqi.V =
    \x -> lin V {
      Indicative = table {
        Pres => table {
          Sg => table {P1 => x ; P2 => x ; P3 => x} ;
          Pl => table {P1 => x ; P2 => x ; P3 => x}
        } ;
        Past => table {
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
    P.mkVV (mkVConst "di") ;

  can_VV : CatSqi.VV =
    P.mkVV (P.mkV "mundem") ;

  must_VV : CatSqi.VV =
    P.mkVV (mkVConst "duhet") ;

  want_VV : CatSqi.VV =
    P.mkVV (mkVConst "dua") ;

  have_V2 : CatSqi.V2 =
    P.mkV2 (P.mkV "kam") ;

} ;