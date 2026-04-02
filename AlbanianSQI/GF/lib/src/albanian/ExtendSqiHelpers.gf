-- GF/lib/src/albanian/ExtendSqiHelpers.gf

resource ExtendSqiHelpers =
  open GrammarSqi, CatSqi, (R = ResSqi), (P = ParamX), Prelude in {

  oper
    -- =========================================================
    -- 1. NEUTRAL UTILITIES
    -- Strategy: structurally safe helpers only.
    -- These may extract strings or constants, but must not pretend
    -- to preserve rich categories unless they really do.
    --
    -- Note: surface extraction to Str is acceptable here when the
    -- eventual target is explicitly shallow/string-like (e.g. Utt).
    -- =========================================================

    wordSep : Str = " " ;

    agrMascSg : R.Agr =
      R.agrgP3 R.Masc P.Sg ;

    -- Base adjective surface form.
    -- Keep the historical name here for A-callers.
    adjSurfaceNomMascSg : A -> Str =
      \a -> a.s ! R.Nom ! R.Masc ! P.Sg ;

    -- AP surface form.
    -- Use this in shallow AP -> Str contexts such as FocusAP.
    apSurfaceNomMascSg : AP -> Str =
      \ap -> ap.s ! R.Indef ! R.Nom ! R.Masc ! P.Sg ;

    verbPres3sg : R.Verb -> Str =
      \v -> v.Indicative ! P.Pres ! P.Sg ! P.P3 ;

    prepSurfaceAcc : R.Prep -> NP -> Str =
      \prep,np -> prep.s ++ np.s ! R.Acc ;

    mkPronConst :
      Str -> Str -> Str -> Str -> Str -> R.Gender -> P.Number -> CatSqi.Pron =
      \nom,acc,dat,accCl,datCl,g,n ->
        lin Pron {
          s = table {
            R.Nom   => nom ;
            R.Acc   => acc ;
            R.Dat   => dat ;
            R.Ablat => dat
          } ;
          acc_clit = accCl ;
          dat_clit = datCl ;
          a        = R.agrgP3 g n
        } ;

    adjComplStr : A -> R.Species -> R.Case -> R.Gender -> P.Number -> Str =
      \a,spec,c,g,n ->
        case a.clit of {
          True  => R.link_clitic ! spec ! c ! g ! n ++ a.s ! c ! g ! n ;
          False => a.s ! c ! g ! n
        } ;

    -- =========================================================
    -- 2. CATEGORY-PRESERVING HELPERS
    -- Strategy: safe builders for rich outputs.
    -- These may construct NP/CN/AP/Pron only if the full Albanian
    -- category shape is preserved.
    -- =========================================================

    mkBareNpFromCn : P.Number -> CN -> NP =
      \n,cn ->
        lin NP {
          s = \\c => cn.s ! R.Indef ! c ! n ;
          a = R.agrgP3 cn.g n
        } ;

    -- =========================================================
    -- 3. LOSSY SURFACE EXTRACTORS
    -- Strategy: allowed only when the eventual target is string-like.
    -- Never use these to build final AP/CN/NP/Pron values.
    -- =========================================================

    cnSurfaceNomSg : CN -> Str =
      \cn -> cn.s ! R.Indef ! R.Nom ! P.Sg ;

    -- Alias kept explicit for AP callers in shallow contexts.
    apSurfaceNomMascSgCompat : AP -> Str =
      \ap -> apSurfaceNomMascSg ap ;

    -- =========================================================
    -- 4. TEMPORARY COMPATIBILITY HELPERS
    -- Strategy: provisional only.
    -- Use only when inherited/core Albanian paths are not yet usable.
    -- Removal plan: replace family-by-family with inherited or
    -- Albanian-preserving constructors once the target subsystem lands.
    -- =========================================================

    mkCompatAPFromStr : Str -> AP =
      \w ->
        lin AP {
          s = \\spec,cas,g,n => w
        } ;

    mkCompatCNFromStr : Str -> R.Gender -> CN =
      \w,g ->
        lin CN {
          s = \\spec,cas,n => w ;
          g = g
        } ;

    mkCompatNPFromStr : Str -> R.Gender -> P.Number -> NP =
      \w,g,n ->
        lin NP {
          s = \\cas => w ;
          a = R.agrgP3 g n
        } ;

} ;