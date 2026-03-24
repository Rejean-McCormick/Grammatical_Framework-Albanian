resource ExtendSqiVPBridge =
  open GrammarSqi, CatSqi, ResSqi, ParamX, (NS = NounSqi), (AS = AdverbSqi) in {

  oper
    vp_wordSep : Str = " " ;

    vp_adjSurfaceNomMascSg : Adj -> Str =
      \a -> a.s ! Nom ! Masc ! Sg ;

    vp_cnSurfaceNomSg : CN -> Str =
      \cn -> cn.s ! Indef ! Nom ! Sg ;

    vp_mkCompatAPFromStr : Str -> AP =
      \w ->
        lin AP {
          s = \\spec,cas,g,n => w
        } ;

    vp_mkCompatNPFromStr : Str -> Gender -> Number -> NP =
      \w,g,n ->
        lin NP {
          s = \\cas => w ;
          a = agrgP3 g n
        } ;

    vp_PresPartAP : VP -> AP =
      \vp ->
        vp_mkCompatAPFromStr vp.s ;

    vp_EmbedPresPart : VP -> SC =
      \vp ->
        lin SC {s = vp.s} ;

    vp_PastPartAP : VPSlash -> AP =
      \vpslash ->
        vp_mkCompatAPFromStr vpslash.s ;

    vp_PastPartAgentAP : VPSlash -> NP -> AP =
      \vpslash,np ->
        vp_mkCompatAPFromStr (vpslash.s ++ vp_wordSep ++ np.s ! Nom) ;

    vp_PassVPSlash : VPSlash -> VP =
      \vpslash ->
        lin VP {s = vpslash.s} ;

    vp_PassAgentVPSlash : VPSlash -> NP -> VP =
      \vpslash,np ->
        lin VP {s = vpslash.s ++ vp_wordSep ++ np.s ! Nom} ;

    vp_NominalizeVPSlashNP : VPSlash -> NP -> NP =
      \vpslash,np ->
        lin NP {
          s = \\c => vpslash.s ++ vp_wordSep ++ np.s ! c ;
          a = agrgP3 Masc Sg
        } ;

    vp_ProgrVPSlash : VPSlash -> VPSlash =
      \vpslash ->
        lin VPSlash {s = vpslash.s} ;

    vp_A2VPSlash : A2 -> VPSlash =
      \a2 ->
        lin VPSlash {s = vp_adjSurfaceNomMascSg a2 ++ vp_wordSep ++ a2.c2.s} ;

    vp_N2VPSlash : N2 -> VPSlash =
      \n2 ->
        lin VPSlash {s = vp_cnSurfaceNomSg (UseN2 n2) ++ vp_wordSep ++ n2.c2.s} ;

    vp_AdvIsNP : Adv -> NP -> Cl =
      \adv,np ->
        PredVP np (UseComp (CompAdv adv)) ;

    vp_AdvIsNPAP : Adv -> NP -> AP -> Cl =
      \adv,np,ap ->
        PredVP np (AdvVP (UseComp (CompAP ap)) adv) ;

    vp_PurposeVP : VP -> Adv =
      \vp ->
        lin Adv {s = "për të" ++ vp_wordSep ++ vp.s} ;

    vp_WithoutVP : VP -> Adv =
      \vp ->
        lin Adv {s = "pa" ++ vp_wordSep ++ vp.s} ;

    vp_ByVP : VP -> Adv =
      \vp ->
        lin Adv {s = "nga" ++ vp_wordSep ++ vp.s} ;

    vp_InOrderToVP : VP -> Adv =
      \vp ->
        lin Adv {s = "që të" ++ vp_wordSep ++ vp.s} ;

    vp_CompoundAP : N -> A -> AP =
      \n,a ->
        AdvAP (PositA a) (AS.PrepNP (mkPrep "nga") (NS.MassNP (UseN n))) ;

}