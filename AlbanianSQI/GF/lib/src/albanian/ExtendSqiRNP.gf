resource ExtendSqiRNP =
  open GrammarSqi, CatSqi, ParamX,
       (R = ResSqi),
       ExtendSqiHelpers,
       (AS = AdverbSqi) in {

  oper
    -- =========================================================
    -- RNP SUBSYSTEM
    -- Strategy:
    -- - prefer inherited Albanian composition wherever a real path exists
    -- - keep the custom RNP family coherent, but reuse standard NP/ListNP
    --   composition when it already matches the required shape
    -- - keep only the genuinely Albanian-specific surface bridges local
    -- =========================================================

    rnp_advFromPrepNP : Prep -> NP -> Adv =
      \prep,np -> AS.PrepNP prep np ;

    rnp_ReflRNP : VPSlash -> NP -> VP =
      \vpslash,rnp ->
        lin VP {
          s = vpslash.s ++ wordSep ++ rnp.s ! R.Acc
        } ;

    rnp_ReflPron : NP =
      mkCompatNPFromStr "veten" R.Masc Sg ;

    rnp_ReflPoss : Num -> CN -> NP =
      \num,cn -> lin NP {
        s = \\c => "të vet" ++ wordSep ++ cn.s ! R.Indef ! c ! num.n ;
        a = R.agrgP3 cn.g num.n
      } ;

    rnp_PredetRNP : Predet -> NP -> NP =
      \pred,rnp -> lin NP {
        s = \\c => pred.s ++ wordSep ++ rnp.s ! c ;
        a = rnp.a
      } ;

    -- Keep NP rich; use Albanian prep government through PrepNP.
    rnp_AdvRNP : NP -> Prep -> NP -> NP =
      \np,prep,rnp -> lin NP {
        s = \\c => rnp.s ! c ++ wordSep ++ (rnp_advFromPrepNP prep np).s ;
        a = rnp.a
      } ;

    -- Preferred inherited/compositional path.
    rnp_AdvRVP : VP -> Prep -> NP -> VP =
      \vp,prep,rnp ->
        AdvVP vp (rnp_advFromPrepNP prep rnp) ;

    -- Preferred inherited/compositional path.
    rnp_AdvRAP : AP -> Prep -> NP -> AP =
      \ap,prep,rnp ->
        AdvAP ap (rnp_advFromPrepNP prep rnp) ;

    -- Preferred inherited Albanian path for A2 + NP complement.
    rnp_ReflA2RNP : A2 -> NP -> AP =
      \a2,rnp ->
        ComplA2 a2 rnp ;

    rnp_PossPronRNP : CatSqi.Pron -> Num -> CN -> NP -> NP =
      \pron,num,cn,rnp -> lin NP {
        s = \\c =>
              pron.s ! c ++
              wordSep ++ cn.s ! R.Indef ! c ! num.n ++
              wordSep ++ rnp.s ! R.Acc ;
        a = pron.a
      } ;

    -- Reuse the standard Albanian NP conjunction path.
    rnp_ConjRNP : Conj -> ListNP -> NP =
      \conj,rnps ->
        ConjNP conj rnps ;

    -- Keep the three abstract family entry points, but route them through
    -- the standard Albanian ListNP builders.
    rnp_Base_rr_RNP : NP -> NP -> ListNP =
      \r1,r2 ->
        BaseNP r1 r2 ;

    rnp_Base_nr_RNP : NP -> NP -> ListNP =
      \np,r ->
        BaseNP np r ;

    rnp_Base_rn_RNP : NP -> NP -> ListNP =
      \r,np ->
        BaseNP r np ;

    rnp_Cons_rr_RNP : NP -> ListNP -> ListNP =
      \r,rs ->
        ConsNP r rs ;

    rnp_Cons_nr_RNP : NP -> ListNP -> ListNP =
      \np,rs ->
        ConsNP np rs ;

    rnp_Cons_rn_RNP : NP -> ListNP -> ListNP =
      \r,ns ->
        ConsNP r ns ;

} ;