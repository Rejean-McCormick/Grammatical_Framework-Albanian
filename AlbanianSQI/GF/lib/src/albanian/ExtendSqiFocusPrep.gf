resource ExtendSqiFocusPrep =
  open Prelude, GrammarSqi, CatSqi, ParamX,
       (R = ResSqi),
       (NS = NounSqi), (AS = AdverbSqi) in {

  oper
    fp_wordSep : Str = " " ;

    fp_apSurfaceNomMascSg : AP -> Str =
      \ap -> ap.s ! R.Indef ! R.Nom ! R.Masc ! Sg ;

    fp_FocusObj : NP -> SSlash -> Utt =
      \np,sslash ->
        lin Utt {s = np.s ! R.Nom ++ fp_wordSep ++ sslash.s} ;

    fp_FocusAdv : Adv -> S -> Utt =
      \adv,s ->
        lin Utt {s = adv.s ++ fp_wordSep ++ s.s} ;

    fp_FocusAdV : AdV -> S -> Utt =
      \adv,s ->
        lin Utt {s = adv.s ++ fp_wordSep ++ s.s} ;

    fp_FocusAP : AP -> NP -> Utt =
      \ap,np ->
        lin Utt {s = fp_apSurfaceNomMascSg ap ++ fp_wordSep ++ np.s ! R.Nom} ;

    fp_PrepCN : CatSqi.Prep -> CN -> Adv =
      \prep,cn ->
        AS.PrepNP prep (NS.MassNP cn) ;

}