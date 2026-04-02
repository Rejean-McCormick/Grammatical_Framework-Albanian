-- GF/lib/src/albanian/ExtendSqiFocusPrep.gf

resource ExtendSqiFocusPrep =
  open Prelude, GrammarSqi, CatSqi,
       ExtendSqiHelpers,
       (R = ResSqi),
       (NS = NounSqi), (AS = AdverbSqi) in {

  oper
    -- =========================================================
    -- FOCUS / PREPOSITION SUBSYSTEM
    -- Strategy: mirror Albanian focus/preposition behavior.
    -- Utt is shallow, so surface extraction is allowed there.
    -- Keep prep/government behavior aligned with AdverbSqi.
    -- =========================================================

    fp_npSurfaceNom : NP -> Str =
      \np -> np.s ! R.Nom ;

    fp_npSurfaceAcc : NP -> Str =
      \np -> np.s ! R.Acc ;

    fp_FocusObj : NP -> SSlash -> Utt =
      \np,sslash ->
        lin Utt {
          s = fp_npSurfaceAcc np ++ wordSep ++ sslash.s
        } ;

    fp_FocusAdv : Adv -> S -> Utt =
      \adv,s ->
        lin Utt {
          s = adv.s ++ wordSep ++ s.s
        } ;

    fp_FocusAdV : AdV -> S -> Utt =
      \adv,s ->
        lin Utt {
          s = adv.s ++ wordSep ++ s.s
        } ;

    fp_FocusAP : AP -> NP -> Utt =
      \ap,np ->
        lin Utt {
          s = apSurfaceNomMascSg ap ++ wordSep ++ fp_npSurfaceNom np
        } ;

    fp_PrepCN : CatSqi.Prep -> CN -> Adv =
      \prep,cn ->
        AS.PrepNP prep (NS.MassNP cn) ;

} ;