resource ExtendSqiAPCN =
  open Prelude, GrammarSqi, CatSqi, ResSqi, ParamX, NounSqi, AdjectiveSqi in {

  oper
    -- =========================================================
    -- AP / CN CONVERSION SUBSYSTEM
    -- Strategy:
    -- - prefer inherited/compositional Albanian paths where they exist
    -- - keep rich-category outputs rich
    -- - allow shallow reduction only for genuinely string-like targets
    -- - keep AP -> CN explicitly marked provisional until a better
    --   Albanian-preserving constructor path is available
    -- =========================================================

    apcn_wordSep : Str = " " ;

    -- IComp is string-like/shallow in Albanian, so mirror the canonical CompAP path.
    apcn_ICompAP : AP -> IComp =
      \ap -> lin IComp (CompAP ap) ;

    -- Preferred inherited path.
    apcn_CompBareCN : CN -> Comp =
      \cn -> CompCN cn ;

    -- Preferred inherited path.
    apcn_CompIQuant : IQuant -> IComp =
      \iq -> CompIP (IdetIP (IdetQuant iq NumSg)) ;

    -- Prefer the inherited/compositional path seen in the Albanian docs:
    -- PredAPVP ap vp = ImpersCl (UseComp (CompAP (SentAP ap (EmbedVP vp))))
    apcn_PredAPVP : AP -> VP -> Cl =
      \ap,vp ->
        ImpersCl (UseComp (CompAP (SentAP ap (EmbedVP vp)))) ;

    -- TEMPORARY / PROVISIONAL:
    -- no better inherited AP -> CN path has been surfaced yet.
    -- Keep the full CN table; do not flatten AP to Str here.
    -- Masculine is the current documented emergency default for this bridge.
    apcn_AdjAsCN : AP -> CN =
      \ap -> lin CN {
        s = \\spec,c,n => ap.s ! spec ! c ! Masc ! n ;
        g = Masc
      } ;

    -- Better than rebuilding NP by hand: build NP through the normal DetCN path.
    apcn_AdjAsNP : AP -> NP =
      \ap -> DetCN (DetQuant IndefArt NumSg) (apcn_AdjAsCN ap) ;

    -- Card is string-like, so reduce CN through canonical CompCN,
    -- not by selecting a raw noun cell.
    apcn_CardCNCard : Card -> CN -> Card =
      \card,cn -> lin Card {
        s = card.s ++ apcn_wordSep ++ (CompCN cn).s
      } ;

} ;