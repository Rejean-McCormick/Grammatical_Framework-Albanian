-- GF/lib/src/albanian/StructuralSqiVerbal.gf
resource StructuralSqiVerbal =
  open Prelude, ParamX, ResSqi, CatSqi, (P = ParadigmsSqi) in {

oper
  -- =========================================================
  -- STRUCTURAL VERBAL VOCABULARY
  -- Strategy:
  -- - keep compile-safe constant-verb fallbacks here for verbs we do not
  --   want ParadigmsSqi.mkV to analyze
  -- - centralize the constant builders instead of repeating ad hoc wrappers
  -- - keep must_VV disabled until the GeneratePMCFG crash source is isolated
  -- =========================================================

  mkPersTab : Str -> _ =
    \x -> table {P1 => x ; P2 => x ; P3 => x} ;

  mkNumPersTab : Str -> _ =
    \x -> table {
      Sg => mkPersTab x ;
      Pl => mkPersTab x
    } ;

  mkVConst : Str -> CatSqi.V =
    \x -> lin V {
      Indicative = table {
        ParamX.Pres      => mkNumPersTab x ;
        ParamX.Past      => mkNumPersTab x ;
        Aorist           => mkNumPersTab x ;
        Imperfect        => mkNumPersTab x
      } ;
      Imperative = table {
        Sg => x ;
        Pl => x
      } ;
      participle = x ;
      pres_optative = mkNumPersTab x ;
      perf_optative = mkNumPersTab x ;
      pres_admirative = mkNumPersTab x ;
      imperf_admirative = mkNumPersTab x
    } ;

  mkVVConst : Str -> CatSqi.VV =
    \x -> P.mkVV (mkVConst x) ;

  mkV2Const : Str -> CatSqi.V2 =
    \x -> P.mkV2 (mkVConst x) ;

  can8know_VV : CatSqi.VV =
    mkVVConst "di" ;

  can_VV : CatSqi.VV =
    mkVVConst "mundem" ;

  -- Keep disabled until the GeneratePMCFG crash source is isolated.
  -- must_VV : CatSqi.VV =
  --   mkVVConst "duhet" ;

  want_VV : CatSqi.VV =
    mkVVConst "dua" ;

  have_V2 : CatSqi.V2 =
    mkV2Const "kam" ;

} ;