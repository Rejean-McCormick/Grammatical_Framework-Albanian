-- GF/lib/src/albanian/ExtendSqiHelpers.gf

resource ExtendSqiHelpers =
  open GrammarSqi, CatSqi, ResSqi, ParamX, Prelude in {

  oper
    -- =========================================================
    -- 1. NEUTRAL UTILITIES
    -- structurally safe helpers
    -- =========================================================

    wordSep : Str = " " ;

    agrMascSg : Agr =
      agrgP3 Masc Sg ;

    adjSurfaceNomMascSg : Adj -> Str =
      \a -> a.s ! Nom ! Masc ! Sg ;

    verbPres3sg : Verb -> Str =
      \v -> v.Indicative ! ParamX.Pres ! Sg ! P3 ;

    prepSurfaceAcc : Str -> NP -> Str =
      \prepS,np -> prepS ++ np.s ! Acc ;

    mkPronConst :
      Str -> Str -> Str -> Str -> Str -> Gender -> Number -> CatSqi.Pron =
      \nom,acc,dat,accCl,datCl,g,n ->
        lin Pron {
          s        = table {Nom => nom ; Acc => acc ; Dat => dat ; Ablat => dat} ;
          acc_clit = accCl ;
          dat_clit = datCl ;
          a        = agrgP3 g n
        } ;

    adjComplStr : Adj -> Species -> Case -> Gender -> Number -> Str =
      \a,spec,c,g,n ->
        case a.clit of {
          True  => link_clitic ! spec ! c ! g ! n ++ a.s ! c ! g ! n ;
          False => a.s ! c ! g ! n
        } ;

    -- =========================================================
    -- 2. CATEGORY-PRESERVING HELPERS
    -- allowed for rich outputs
    -- =========================================================

    mkBareNpFromCn : Number -> CN -> NP =
      \n,cn ->
        lin NP {
          s = \\c => cn.s ! Indef ! c ! n ;
          a = agrgP3 cn.g n
        } ;

    -- =========================================================
    -- 3. LOSSY SURFACE EXTRACTORS
    -- allowed only for string-like targets
    -- =========================================================

    cnSurfaceNomSg : CN -> Str =
      \cn -> cn.s ! Indef ! Nom ! Sg ;

    apSurfaceNomMascSg : AP -> Str =
      \ap -> ap.s ! Indef ! Nom ! Masc ! Sg ;

    -- =========================================================
    -- 4. TEMPORARY COMPATIBILITY HELPERS
    -- rich outputs built here are provisional, not final design
    -- =========================================================

    mkCompatAPFromStr : Str -> AP =
      \w ->
        lin AP {
          s = \\spec,cas,g,n => w
        } ;

    mkCompatCNFromStr : Str -> Gender -> CN =
      \w,g ->
        lin CN {
          s = \\spec,cas,n => w ;
          g = g
        } ;

    mkCompatNPFromStr : Str -> Gender -> Number -> NP =
      \w,g,n ->
        lin NP {
          s = \\cas => w ;
          a = agrgP3 g n
        } ;

}