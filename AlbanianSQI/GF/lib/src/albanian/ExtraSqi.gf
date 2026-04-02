-- GF/lib/src/albanian/ExtraSqi.gf
--# -path=.:../common:../abstract

-- POLICY:
-- 1. ExtraSqi is the shared Albanian extension-layer surface.
-- 2. Rich Albanian categories (AP/CN/NP/Pron) must not be flattened for rich outputs.
-- 3. Surface extractors are allowed only for string-like targets.
-- 4. Focus / preposition / IComp behavior here must stay aligned with ExtendSqi.
-- 5. Any lossy AP/CN path here is provisional and should not be mistaken for final design.

concrete ExtraSqi of ExtraSqiAbs =
  CatSqi **
  open Prelude, ResSqi, GrammarSqi,
       (NS = NounSqi), (AS = AdverbSqi) in {

  oper
    -- =========================================================
    -- 1. NEUTRAL UTILITIES
    -- =========================================================

    wordSep : Str = " " ;

    verbPres3sg : Verb -> Str =
      \v -> v.Indicative ! Pres ! Sg ! P3 ;

    npSurfaceNom : NP -> Str =
      \np -> np.s ! Nom ;

    npSurfaceAcc : NP -> Str =
      \np -> np.s ! Acc ;

    -- =========================================================
    -- 2. CATEGORY-PRESERVING HELPERS
    -- =========================================================

    mkBareNpFromCn : Number -> CN -> NP =
      \n,cn -> lin NP {
        s = \\c => cn.s ! Indef ! c ! n ;
        a = agrgP3 cn.g n
      } ;

    -- =========================================================
    -- 3. LOSSY SURFACE EXTRACTORS
    -- allowed only for string-like targets
    -- =========================================================

    apSurfaceNomMascSg : AP -> Str =
      \ap -> ap.s ! Indef ! Nom ! Masc ! Sg ;

    -- =========================================================
    -- 4. TEMPORARY COMPATIBILITY HELPERS
    -- rich outputs built here are provisional
    -- =========================================================

    mkCompatAPFromStr : Str -> AP =
      \w -> lin AP {
        s = \\spec,c,g,n => w
      } ;

  lincat
    VPI   = {s : Str} ;
    [VPI] = {s : Str} ;

    VPS   = {s : Str} ;
    [VPS] = {s : Str} ;

    Foc   = {s : Str} ;

  lin
    -- =========================================================
    -- SHALLOW SCAFFOLDING / LIST WRAPPERS
    -- =========================================================

    GenNP np = {
      s = \\c,g,n => link_clitic ! Indef ! c ! g ! n ++ np.s ! Ablat ;
      spec = Indef
    } ;

    GenIP ip = {s = "i" ++ ip.s} ;

    GenRP num cn = {
      s = link_clitic ! Indef ! Nom ! cn.g ! num.n ++ cn.s ! Indef ! Ablat ! num.n
    } ;

    ComplBareVS vs s = {s = verbPres3sg vs ++ wordSep ++ s.s} ;

    StrandRelSlash rp slash   = {s = rp.s ++ wordSep ++ slash.s} ;
    EmptyRelSlash slash       = {s = slash.s} ;
    StrandQuestSlash ip slash = {s = ip.s ++ wordSep ++ slash.s} ;

    BaseVPI x y = {s = x.s ++ "," ++ wordSep ++ y.s} ;
    ConsVPI x xs = {s = x.s ++ "," ++ wordSep ++ xs.s} ;
    MkVPI vp = {s = vp.s} ;
    ConjVPI conj xs = {s = xs.s ++ wordSep ++ conj.s} ;
    ComplVPIVV vv vpi = {s = verbPres3sg vv ++ wordSep ++ vpi.s} ;

    BaseVPS x y = {s = x.s ++ "," ++ wordSep ++ y.s} ;
    ConsVPS x xs = {s = x.s ++ "," ++ wordSep ++ xs.s} ;
    MkVPS t p vp = {s = vp.s} ;
    ConjVPS conj xs = {s = xs.s ++ wordSep ++ conj.s} ;
    PredVPS np vps = {s = npSurfaceNom np ++ wordSep ++ vps.s} ;

    -- =========================================================
    -- AP/CN CONVERSION SUBSYSTEM
    -- Strategy:
    -- - use inherited/compositional Albanian paths where available
    -- - keep shallow reduction only for genuinely string-like targets
    -- =========================================================

    -- aligned with ExtendSqiAPCN
    ICompAP ap = lin IComp (CompAP ap) ;

    IAdvAdv adv = {s = adv.s} ;

    -- aligned with ExtendSqiAPCN
    CompIQuant iq = CompIP (IdetIP (IdetQuant iq NumSg)) ;

    -- aligned with ExtendSqiFocusPrep / Albanian prep government
    PrepCN prep cn = AS.PrepNP prep (NS.MassNP cn) ;

    -- =========================================================
    -- FOCUS SUBSYSTEM
    -- Strategy: keep Foc shallow and visibly surface-oriented
    -- =========================================================

    FocObj np slash = {s = npSurfaceAcc np ++ wordSep ++ slash.s} ;
    FocAdv adv cl   = {s = adv.s ++ wordSep ++ cl.s} ;
    FocAdV adv cl   = {s = adv.s ++ wordSep ++ cl.s} ;

    -- temporary shallow target, aligned with ExtendSqiFocusPrep
    FocAP ap np     = {s = apSurfaceNomMascSg ap ++ wordSep ++ npSurfaceNom np} ;

    FocNeg cl       = {s = "nuk" ++ wordSep ++ cl.s} ;
    FocVP vp np     = {s = vp.s ++ wordSep ++ npSurfaceNom np} ;
    FocVV vv vp np  = {s = verbPres3sg vv ++ wordSep ++ vp.s ++ wordSep ++ npSurfaceNom np} ;
    UseFoc t p foc  = {s = foc.s} ;

    -- =========================================================
    -- VP / VPSlash BRIDGE SUBSYSTEM
    -- =========================================================

    -- IMPORTANT: PartVP returns AP in the abstract, so any direct VP->AP
    -- realization here is a temporary compatibility path.
    PartVP vp = mkCompatAPFromStr vp.s ;

    -- SC is shallow/string-like here.
    EmbedPresPart vp = {s = vp.s} ;

    PassVPSlash vpslash = vpslash ;
}