-- GF/lib/src/albanian/ExtendSqiVPBridge.gf

resource ExtendSqiVPBridge =
  open GrammarSqi, CatSqi,
       (R = ResSqi), (P = ParamX),
       ExtendSqiHelpers,
       (NS = NounSqi), (AS = AdverbSqi) in {

  oper
    -- =========================================================
    -- VP / VPSLASH BRIDGE SUBSYSTEM
    -- Strategy:
    -- - keep inherited Albanian composition wherever a real path exists
    -- - keep lossy AP/NP bridges explicitly centralized and provisional
    -- - use Albanian case/government defaults already established elsewhere
    -- =========================================================

    vp_npSurfaceAcc : NP -> Str =
      \np -> np.s ! R.Acc ;

    vp_agentAdv : NP -> Adv =
      \np -> AS.PrepNP (R.mkPrep "nga") np ;

    -- TEMPORARY fallback:
    -- AP-producing participial bridges still have no Albanian AP-preserving
    -- constructor path. Keep the lossy conversion centralized in helpers.
    vp_PresPartAP : VP -> AP =
      \vp ->
        mkCompatAPFromStr vp.s ;

    -- SC is shallow/string-like here, so direct embedding is acceptable.
    vp_EmbedPresPart : VP -> SC =
      \vp ->
        lin SC {s = vp.s} ;

    -- TEMPORARY fallback:
    -- preserve subsystem ownership, but do not duplicate local AP builders here.
    vp_PastPartAP : VPSlash -> AP =
      \vpslash ->
        mkCompatAPFromStr vpslash.s ;

    -- TEMPORARY fallback:
    -- keep explicit Albanian agent marking through the inherited PrepNP path,
    -- not by raw NP concatenation.
    vp_PastPartAgentAP : VPSlash -> NP -> AP =
      \vpslash,np ->
        mkCompatAPFromStr (vpslash.s ++ wordSep ++ (vp_agentAdv np).s) ;

    -- VP/VPSlash are already shallow enough in this Albanian implementation,
    -- so the passive bridge can remain direct.
    vp_PassVPSlash : VPSlash -> VP =
      \vpslash ->
        lin VP {s = vpslash.s} ;

    -- Preferred passive+agent path: reuse Albanian prep government.
    vp_PassAgentVPSlash : VPSlash -> NP -> VP =
      \vpslash,np ->
        lin VP {s = vpslash.s ++ wordSep ++ (vp_agentAdv np).s} ;

    -- TEMPORARY fallback:
    -- centralized compatibility NP builder, not local ad hoc NP record construction.
    -- Masculine singular agreement remains the documented emergency default for
    -- semantically neutralized nominalizations.
    --
    -- The NP complement is surfaced in Acc, consistent with Albanian complement
    -- realization elsewhere in the extension layer.
    vp_NominalizeVPSlashNP : VPSlash -> NP -> NP =
      \vpslash,np ->
        mkCompatNPFromStr
          (vpslash.s ++ wordSep ++ vp_npSurfaceAcc np)
          R.Masc
          P.Sg ;

    vp_ProgrVPSlash : VPSlash -> VPSlash =
      \vpslash ->
        lin VPSlash {s = vpslash.s} ;

    -- Keep the adjective surface rich as long as possible, then expose only
    -- the open complement slot as a slash string.
    vp_A2VPSlash : A2 -> VPSlash =
      \a2 ->
        lin VPSlash {
          s = adjComplStr a2 R.Indef R.Nom R.Masc P.Sg ++ wordSep ++ a2.c2.s
        } ;

    -- Same policy for N2: keep the Albanian noun path, expose only the missing
    -- complement slot as a shallow slash string.
    vp_N2VPSlash : N2 -> VPSlash =
      \n2 ->
        lin VPSlash {
          s = cnSurfaceNomSg (UseN2 n2) ++ wordSep ++ n2.c2.s
        } ;

    -- Preferred inherited/functor-style composition path.
    vp_AdvIsNP : Adv -> NP -> Cl =
      \adv,np ->
        PredVP np (UseComp (CompAdv adv)) ;

    -- Preferred inherited/functor-style composition path.
    vp_AdvIsNPAP : Adv -> NP -> AP -> Cl =
      \adv,np,ap ->
        PredVP np (AdvVP (UseComp (CompAP ap)) adv) ;

    -- These targets are Adv/string-like, so shallow realization is acceptable.
    vp_PurposeVP : VP -> Adv =
      \vp ->
        lin Adv {s = "për të" ++ wordSep ++ vp.s} ;

    vp_WithoutVP : VP -> Adv =
      \vp ->
        lin Adv {s = "pa" ++ wordSep ++ vp.s} ;

    vp_ByVP : VP -> Adv =
      \vp ->
        lin Adv {s = "nga" ++ wordSep ++ vp.s} ;

    vp_InOrderToVP : VP -> Adv =
      \vp ->
        lin Adv {s = "që të" ++ wordSep ++ vp.s} ;

    -- Constructor-based AP path; keeps AP shape instead of manufacturing one.
    vp_CompoundAP : N -> A -> AP =
      \n,a ->
        AdvAP (PositA a) (AS.PrepNP (R.mkPrep "nga") (NS.MassNP (UseN n))) ;

} ;