resource ExtendSqiRNP =
  open GrammarSqi, CatSqi, ParamX, (R = ResSqi) in {

  oper
    rnp_wordSep : Str = " " ;

    rnp_afterPrepNP : Prep -> NP -> Str =
      \_,np -> np.s ! R.Acc ;

    rnp_mkCompatNPFromStr : Str -> R.Gender -> Number -> NP =
      \w,g,n -> lin NP {
        s = \\c => w ;
        a = R.agrgP3 g n
      } ;

    rnp_adjComplStr : A2 -> R.Species -> R.Case -> R.Gender -> Number -> Str =
      \a,spec,c,g,n ->
        case a.clit of {
          True  => R.link_clitic ! spec ! c ! g ! n ++ a.s ! c ! g ! n ;
          False => a.s ! c ! g ! n
        } ;

    rnp_ReflRNP : VPSlash -> NP -> VP =
      \vpslash,rnp ->
        lin VP {
          s = vpslash.s ++ rnp_wordSep ++ rnp.s ! R.Acc
        } ;

    rnp_ReflPron : NP =
      rnp_mkCompatNPFromStr "veten" R.Masc Sg ;

    rnp_ReflPoss : Num -> CN -> NP =
      \num,cn -> lin NP {
        s = \\c => "të vet" ++ rnp_wordSep ++ cn.s ! R.Indef ! c ! num.n ;
        a = R.agrgP3 cn.g num.n
      } ;

    rnp_PredetRNP : Predet -> NP -> NP =
      \pred,rnp -> lin NP {
        s = \\c => pred.s ++ rnp_wordSep ++ rnp.s ! c ;
        a = rnp.a
      } ;

    rnp_AdvRNP : NP -> Prep -> NP -> NP =
      \np,prep,rnp -> lin NP {
        s = \\c =>
              rnp.s ! c ++
              rnp_wordSep ++ prep.s ++ rnp_wordSep ++
              rnp_afterPrepNP prep np ;
        a = rnp.a
      } ;

    rnp_AdvRVP : VP -> Prep -> NP -> VP =
      \vp,prep,rnp ->
        lin VP {
          s = vp.s ++
              rnp_wordSep ++ prep.s ++ rnp_wordSep ++
              rnp_afterPrepNP prep rnp
        } ;

    rnp_AdvRAP : AP -> Prep -> NP -> AP =
      \ap,prep,rnp -> lin AP {
        s = \\spec,c,g,n =>
              ap.s ! spec ! c ! g ! n ++
              rnp_wordSep ++ prep.s ++ rnp_wordSep ++
              rnp_afterPrepNP prep rnp
      } ;

    rnp_ReflA2RNP : A2 -> NP -> AP =
      \a2,rnp -> lin AP {
        s = \\spec,c,g,n =>
              rnp_adjComplStr a2 spec c g n ++
              rnp_wordSep ++ a2.c2.s ++ rnp_wordSep ++
              rnp.s ! R.Acc
      } ;

    rnp_PossPronRNP : CatSqi.Pron -> Num -> CN -> NP -> NP =
      \pron,num,cn,rnp -> lin NP {
        s = \\c =>
              pron.s ! c ++
              rnp_wordSep ++ cn.s ! R.Indef ! c ! num.n ++
              rnp_wordSep ++ rnp.s ! R.Acc ;
        a = pron.a
      } ;

    rnp_ConjRNP : Conj -> ListNP -> NP =
      \conj,rnps -> lin NP {
        s = \\c =>
              rnps.init ! c ++
              rnp_wordSep ++ conj.s ++ rnp_wordSep ++
              rnps.last ! c ;
        a = rnps.a
      } ;

    rnp_Base_rr_RNP : NP -> NP -> ListNP =
      \r1,r2 -> lin ListNP {
        init = \\c => r1.s ! c ;
        last = \\c => r2.s ! c ;
        a = r1.a
      } ;

    rnp_Base_nr_RNP : NP -> NP -> ListNP =
      \np,r -> lin ListNP {
        init = \\c => np.s ! c ;
        last = \\c => r.s ! c ;
        a = np.a
      } ;

    rnp_Base_rn_RNP : NP -> NP -> ListNP =
      \r,np -> lin ListNP {
        init = \\c => r.s ! c ;
        last = \\c => np.s ! c ;
        a = r.a
      } ;

    rnp_Cons_rr_RNP : NP -> ListNP -> ListNP =
      \r,rs -> lin ListNP {
        init = \\c => r.s ! c ++ rnp_wordSep ++ rs.init ! c ;
        last = rs.last ;
        a = rs.a
      } ;

    rnp_Cons_nr_RNP : NP -> ListNP -> ListNP =
      \np,rs -> lin ListNP {
        init = \\c => np.s ! c ++ rnp_wordSep ++ rs.init ! c ;
        last = rs.last ;
        a = rs.a
      } ;

    rnp_Cons_rn_RNP : NP -> ListNP -> ListNP =
      \r,ns -> lin ListNP {
        init = \\c => r.s ! c ++ rnp_wordSep ++ ns.init ! c ;
        last = ns.last ;
        a = ns.a
      } ;

}