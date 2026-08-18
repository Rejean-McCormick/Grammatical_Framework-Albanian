resource ExtendSqiAPCN =
  open Prelude, GrammarSqi, CatSqi,
       (R = ResSqi), (P = ParamX),
       NounSqi, AdjectiveSqi in {

  oper
    -- =========================================================
    -- AP / CN CONVERSION SUBSYSTEM
    -- Strategy:
    -- - prefer inherited/compositional Albanian paths where they exist
    -- - keep rich-category outputs rich
    -- - allow shallow reduction only for genuinely string-like targets
    -- - isolate the AP -> CN bridge as the only provisional path here
    -- =========================================================

    apcn_wordSep : Str = " " ;

    apcn_CompFromAP : AP -> Comp =
      \ap -> CompAP ap ;

    apcn_CompFromCN : CN -> Comp =
      \cn -> CompCN cn ;

    -- IComp is shallow/string-like in Albanian, so mirror the canonical CompAP path.
    apcn_ICompAP : AP -> IComp =
      \ap -> lin IComp (apcn_CompFromAP ap) ;

    -- Preferred inherited path.
    apcn_CompBareCN : CN -> Comp =
      \cn -> apcn_CompFromCN cn ;

    -- Preferred inherited path.
    apcn_CompIQuant : IQuant -> IComp =
      \iq -> CompIP (IdetIP (IdetQuant iq NumSg)) ;

    -- Preferred inherited/compositional Albanian path:
    -- PredAPVP ap vp = ImpersCl (UseComp (CompAP (SentAP ap (EmbedVP vp))))
    apcn_PredAPVP : AP -> VP -> Cl =
      \ap,vp ->
        ImpersCl (UseComp (apcn_CompFromAP (SentAP ap (EmbedVP vp)))) ;

    -- TEMPORARY / PROVISIONAL:
    -- no better inherited AP -> CN path has been surfaced yet.
    -- Keep the full CN table; do not flatten AP to Str here.
    -- Masculine remains the documented emergency default for this bridge.
    apcn_AdjAsCN : AP -> CN =
      \ap -> lin CN {
        s = \\spec,c,n => ap.s ! spec ! c ! R.Masc ! n ;
        g = R.Masc
      } ;

    -- Preferred NP realization for the provisional AP -> CN bridge:
    -- use the normal DetCN path rather than rebuilding NP by hand.
    apcn_AdjAsNP : AP -> NP =
      \ap -> DetCN (DetQuant IndefArt NumSg) (apcn_AdjAsCN ap) ;

    -- Card is string-like, so reduce CN through canonical CompCN,
    -- not by selecting a raw noun cell.
    apcn_CardCNCard : Card -> CN -> Card =
      \card,cn -> lin Card {
        s = card.s ++ apcn_wordSep ++ (apcn_CompFromCN cn).s
      } ;

} ;