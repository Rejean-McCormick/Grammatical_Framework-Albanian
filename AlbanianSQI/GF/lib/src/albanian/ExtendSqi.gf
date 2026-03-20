-- GF/lib/src/albanian/ExtendSqi.gf
--# -path=.:../common:../abstract

-- POLICY:
-- 1. ExtendFunctor is the default source of structure.
-- 2. Rich Albanian categories (AP/CN/NP/Pron) must not be flattened for rich outputs.
-- 3. Surface extractors are allowed only for string-like targets.
-- 4. Existential, AP/CN, Prep/Focus, VP-bridge, and RNP are maintained as subsystems.
-- 5. Every nontrivial override should be readable as inherited / mirrored /
--    Albanian-specific / temporary.

concrete ExtendSqi of Extend =
  CatSqi ** ExtendFunctor -
  [
    -- =========================================================
    -- SHALLOW SCAFFOLDING / LIST WRAPPERS
    -- =========================================================
    VPS, ListVPS, VPI, ListVPI, VPS2, ListVPS2, VPI2, ListVPI2,
    X, ListComp, ListImp,

    GenNP, GenIP, GenRP, GenModNP, GenModIP,
    PiedPipingQuestSlash, PiedPipingRelSlash, StrandQuestSlash, StrandRelSlash, EmptyRelSlash,

    MkVPS, ConjVPS, PredVPS, SQuestVPS, QuestVPS, RelVPS,
    MkVPI, ConjVPI, ComplVPIVV,
    MkVPS2, ConjVPS2, ComplVPS2, ReflVPS2,
    MkVPI2, ConjVPI2, ComplVPI2,

    BaseVPS, ConsVPS, BaseVPI, ConsVPI, BaseVPS2, ConsVPS2, BaseVPI2, ConsVPI2,
    BaseComp, ConsComp, ConjComp, BaseImp, ConsImp, ConjImp,

    ProDrop, AdAdV, PositAdVAdj, IAdvAdv,
    CompS, CompQS, CompVP,

    UttAccIP, UttDatIP, UttAccNP, UttDatNP, UttAdV, UttVPShort,

    ComplBareVS, SlashBareV2S, ComplDirectVS, ComplDirectVQ,
    FrontComplDirectVS, FrontComplDirectVQ,

    PredIAdvVP, ApposNP,

    ReflPossPron, ComplGenVV, CompoundN,
    GerundCN, GerundNP, GerundAdv,
    UncontractedNeg, TPastSimple, ComplSlashPartLast,

    DetNPMasc, DetNPFem, UseComp_estar, UseComp_ser,
    SubjRelNP, SubjunctRelCN,

    iFem_Pron, youFem_Pron, weFem_Pron, youPlFem_Pron,
    theyFem_Pron, theyNeutr_Pron,
    youPolFem_Pron, youPolPl_Pron, youPolPlFem_Pron,

    UseDAP, UseDAPMasc, UseDAPFem,

    -- =========================================================
    -- EXISTENTIAL SUBSYSTEM
    -- =========================================================
    ExistS, ExistNPQS, ExistIPQS, ExistCN, ExistMassCN, ExistPluralCN, ExistsNP,

    -- =========================================================
    -- AP/CN CONVERSION SUBSYSTEM
    -- =========================================================
    ICompAP, CompBareCN, CompIQuant,
    PredAPVP, AdjAsCN, AdjAsNP, CardCNCard,

    -- =========================================================
    -- FOCUS / PREPOSITION SUBSYSTEM
    -- =========================================================
    FocusObj, FocusAdv, FocusAdV, FocusAP, PrepCN,

    -- =========================================================
    -- VP / VPSlash BRIDGE SUBSYSTEM
    -- =========================================================
    PresPartAP, EmbedPresPart, PastPartAP, PastPartAgentAP,
    PassVPSlash, PassAgentVPSlash, NominalizeVPSlashNP, ProgrVPSlash,
    A2VPSlash, N2VPSlash, AdvIsNP, AdvIsNPAP,
    PurposeVP, WithoutVP, ByVP, InOrderToVP,
    CompoundAP,

    -- =========================================================
    -- RNP SUBSYSTEM
    -- =========================================================
    ReflRNP, ReflPron, ReflPoss, PredetRNP, AdvRNP, AdvRVP, AdvRAP, ReflA2RNP,
    PossPronRNP, ConjRNP,
    Base_rr_RNP, Base_nr_RNP, Base_rn_RNP,
    Cons_rr_RNP, Cons_nr_RNP
  ]
  with
    (Grammar = GrammarSqi) **
  open Prelude, Predef, ResSqi, ParamX in {

  oper
    -- =========================================================
    -- 1. NEUTRAL UTILITIES
    -- structurally safe helpers
    -- =========================================================

    wordSep : Str = " " ;

    agrMascSg : Agr = agrgP3 Masc Sg ;

    adjSurfaceNomMascSg : Adj -> Str =
      \a -> a.s ! Nom ! Masc ! Sg ;

    verbPres3sg : Verb -> Str =
      \v -> v.Indicative ! ParamX.Pres ! Sg ! P3 ;

    prepSurfaceAcc : Str -> NP -> Str =
      \prepS,np -> prepS ++ np.s ! Acc ;

    mkPronConst :
      Str -> Str -> Str -> Str -> Str -> Gender -> Number -> CatSqi.Pron =
      \nom,acc,dat,accCl,datCl,g,n -> lin Pron {
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
      \n,cn -> lin NP {
        s = \\c => cn.s ! Indef ! c ! n ;
        a = agrgP3 cn.g n ;
        lock_NP = <>
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
      \w -> lin AP {
        s = \\spec,cas,g,n => w ;
        lock_AP = <>
      } ;

    mkCompatCNFromStr : Str -> Gender -> CN =
      \w,g -> lin CN {
        s = \\spec,cas,n => w ;
        g = g ;
        lock_CN = <>
      } ;

    mkCompatNPFromStr : Str -> Gender -> Number -> NP =
      \w,g,n -> lin NP {
        s = \\cas => w ;
        a = agrgP3 g n ;
        lock_NP = <>
      } ;

  lincat
    VPS, VPI, VPS2, VPI2, X = {s : Str} ;
    [VPS], [VPI], [VPS2], [VPI2], [Comp], [Imp] = {s : Str} ;

  lin
    -- =========================================================
    -- SHALLOW SCAFFOLDING / LIST WRAPPERS
    -- Strategy: keep wrappers visibly shallow
    -- =========================================================

    GenNP np = lin Quant {
      s    = \\c,g,n => link_clitic ! Indef ! c ! g ! n ++ np.s ! Ablat ;
      spec = Indef
    } ;

    GenIP ip = lin IQuant {s = "i" ++ ip.s} ;

    GenRP num cn = {
      s = link_clitic ! Indef ! Nom ! cn.g ! num.n ++ cn.s ! Indef ! Ablat ! num.n
    } ;

    GenModNP num np cn = np ;
    GenModIP num ip cn = ip ;

    PiedPipingQuestSlash ip slash = {s = ip.s ++ wordSep ++ slash.s} ;
    PiedPipingRelSlash rp slash   = {s = rp.s ++ wordSep ++ slash.s} ;
    StrandQuestSlash ip slash     = {s = ip.s ++ wordSep ++ slash.s} ;
    StrandRelSlash rp slash       = {s = rp.s ++ wordSep ++ slash.s} ;
    EmptyRelSlash slash           = {s = slash.s} ;

    MkVPS temp pol vp = {s = vp.s} ;
    ConjVPS conj vpss = {s = vpss.s} ;
    PredVPS np vps    = {s = np.s ! Nom ++ wordSep ++ vps.s} ;
    SQuestVPS np vps  = {s = np.s ! Nom ++ wordSep ++ vps.s} ;
    QuestVPS ip vps   = {s = ip.s ++ wordSep ++ vps.s} ;
    RelVPS rp vps     = {s = rp.s ++ wordSep ++ vps.s} ;

    MkVPI vp          = {s = vp.s} ;
    ConjVPI conj vpis = {s = vpis.s} ;
    ComplVPIVV vv vpi = {s = vpi.s} ;

    MkVPS2 temp pol vpslash = {s = vpslash.s} ;
    ConjVPS2 conj vps2s     = {s = vps2s.s} ;
    ComplVPS2 vps2 np       = {s = vps2.s ++ wordSep ++ np.s ! Acc} ;
    ReflVPS2 vps2 rnp       = {s = vps2.s ++ wordSep ++ rnp.s ! Acc} ;

    MkVPI2 vpslash      = {s = vpslash.s} ;
    ConjVPI2 conj vpi2s = {s = vpi2s.s} ;
    ComplVPI2 vpi2 np   = {s = vpi2.s ++ wordSep ++ np.s ! Acc} ;

    BaseVPS x y   = {s = x.s ++ wordSep ++ y.s} ;
    ConsVPS x xs  = {s = x.s ++ wordSep ++ xs.s} ;

    BaseVPI x y   = {s = x.s ++ wordSep ++ y.s} ;
    ConsVPI x xs  = {s = x.s ++ wordSep ++ xs.s} ;

    BaseVPS2 x y  = {s = x.s ++ wordSep ++ y.s} ;
    ConsVPS2 x xs = {s = x.s ++ wordSep ++ xs.s} ;

    BaseVPI2 x y  = {s = x.s ++ wordSep ++ y.s} ;
    ConsVPI2 x xs = {s = x.s ++ wordSep ++ xs.s} ;

    BaseComp x y  = {s = x.s ++ wordSep ++ y.s} ;
    ConsComp x xs = {s = x.s ++ wordSep ++ xs.s} ;

    BaseImp x y   = {s = x.s ++ wordSep ++ y.s} ;
    ConsImp x xs  = {s = x.s ++ wordSep ++ xs.s} ;

    ConjComp conj comps = {s = comps.s} ;
    ConjImp conj imps   = {s = imps.s} ;

    ProDrop p = lin Pron {
      s        = \\_ => "" ;
      acc_clit = p.acc_clit ;
      dat_clit = p.dat_clit ;
      a        = p.a
    } ;

    AdAdV ada adv   = {s = ada.s ++ adv.s} ;
    PositAdVAdj a   = {s = adjSurfaceNomMascSg a} ;
    IAdvAdv adv     = {s = adv.s} ;

    CompS s           = {s = s.s} ;
    CompQS qs         = {s = qs.s} ;
    CompVP ant pol vp = {s = vp.s} ;

    UttAccIP ip   = {s = ip.s} ;
    UttDatIP ip   = {s = ip.s} ;
    UttAccNP np   = {s = np.s ! Acc} ;
    UttDatNP np   = {s = np.s ! Dat} ;
    UttAdV adv    = {s = adv.s} ;
    UttVPShort vp = {s = vp.s} ;

    ComplBareVS vs s   = {s = verbPres3sg vs ++ wordSep ++ s.s} ;
    SlashBareV2S v2s s = {s = s.s} ;

    ComplDirectVS vs utt = {s = verbPres3sg vs ++ wordSep ++ utt.s} ;
    ComplDirectVQ vq utt = {s = verbPres3sg vq ++ wordSep ++ utt.s} ;

    FrontComplDirectVS np vs utt =
      {s = np.s ! Nom ++ wordSep ++ utt.s ++ wordSep ++ verbPres3sg vs} ;
    FrontComplDirectVQ np vq utt =
      {s = np.s ! Nom ++ wordSep ++ utt.s ++ wordSep ++ verbPres3sg vq} ;

    PredIAdvVP iadv vp = {s = iadv.s ++ wordSep ++ vp.s} ;

    ApposNP np1 np2 =
      lin NP {
        s = \\c => np1.s ! c ++ wordSep ++ np2.s ! c ;
        a = np1.a ;
        lock_NP = <>
      } ;

    ComplGenVV vv ant pol vp = vp ;

    CompoundN n1 n2 = n1 ;

    -- temporary compatibility path
    GerundCN vp  = mkCompatCNFromStr vp.s Masc ;
    GerundNP vp  = mkCompatNPFromStr vp.s Masc Sg ;
    GerundAdv vp = {s = vp.s} ;

    UncontractedNeg = {s = "nuk" ; p = ParamX.Neg} ;
    TPastSimple     = {s = "" ; t = ParamX.Past} ;

    ComplSlashPartLast vpslash np = {s = vpslash.s ++ wordSep ++ np.s ! Acc} ;

    DetNPMasc det =
      lin NP {
        s = \\c => det.s ! c ! Masc ;
        a = agrgP3 Masc det.n ;
        lock_NP = <>
      } ;

    DetNPFem det =
      lin NP {
        s = \\c => det.s ! c ! Fem ;
        a = agrgP3 Fem det.n ;
        lock_NP = <>
      } ;

    UseComp_estar comp = {s = comp.s} ;
    UseComp_ser   comp = {s = comp.s} ;

    SubjRelNP np rs =
      lin NP {
        s = \\c => np.s ! c ++ wordSep ++ rs.s ;
        a = np.a ;
        lock_NP = <>
      } ;

    SubjunctRelCN cn rs =
      lin CN {
        s = \\spec,c,n => cn.s ! spec ! c ! n ++ wordSep ++ rs.s ;
        g = cn.g ;
        lock_CN = <>
      } ;

    -- =========================================================
    -- EXISTENTIAL SUBSYSTEM
    -- Strategy: mirror ExtendFunctor clause/question composition
    -- =========================================================

    ExistS temp pol np    = UseCl temp pol (ExistNP np) ;
    ExistNPQS temp pol np = UseQCl temp pol (QuestCl (ExistNP np)) ;
    ExistIPQS temp pol ip = UseQCl temp pol (ExistIP ip) ;

    ExistCN cn        = ExistNP (DetCN (DetQuant IndefArt NumSg) cn) ;
    ExistMassCN cn    = ExistNP (MassNP cn) ;
    ExistPluralCN cn  = ExistNP (DetCN (DetQuant IndefArt NumPl) cn) ;
    ExistsNP          = ExistNP ;

    -- =========================================================
    -- AP/CN CONVERSION SUBSYSTEM
    -- Strategy: preserve rich boundaries where possible;
    -- any lossy path here is provisional and must stay explicit
    -- =========================================================

    ICompAP ap      = {s = apSurfaceNomMascSg ap} ;

    CompBareCN cn   = CompCN cn ;
    CompIQuant iq   = CompIP (IdetIP (IdetQuant iq NumSg)) ;

    PredAPVP ap vp =
      ImpersCl
        (UseComp
          (CompAP
            (lin AP {
              s = \\spec,c,g,n =>
                    ap.s ! spec ! c ! g ! n ++ wordSep ++ "që" ++ wordSep ++ (EmbedVP vp).s ;
              lock_AP = <>
            }))) ;

    AdjAsCN ap =
      lin CN {
        s = \\spec,c,n => ap.s ! spec ! c ! Masc ! n ;
        g = Masc ;
        lock_CN = <>
      } ;

    AdjAsNP ap =
      lin NP {
        s = \\c => ap.s ! Indef ! c ! Masc ! Sg ;
        a = agrgP3 Masc Sg ;
        lock_NP = <>
      } ;

    CardCNCard card cn =
      card ** {s = card.s ++ wordSep ++ cnSurfaceNomSg cn} ;

    -- =========================================================
    -- FOCUS / PREPOSITION SUBSYSTEM
    -- Strategy: keep focus wrappers shallow, avoid hidden CN drift
    -- =========================================================

    FocusObj np sslash = {s = np.s ! Nom ++ wordSep ++ sslash.s} ;
    FocusAdv adv s     = {s = adv.s ++ wordSep ++ s.s} ;
    FocusAdV adv s     = {s = adv.s ++ wordSep ++ s.s} ;

    FocusAP ap np      = {s = apSurfaceNomMascSg ap ++ wordSep ++ np.s ! Nom} ;

    PrepCN prep cn     = PrepNP prep (MassNP cn) ;

    -- =========================================================
    -- VP / VPSlash BRIDGE SUBSYSTEM
    -- Strategy: shallow verbal wrappers, explicit complement handling
    -- =========================================================

    PresPartAP vp              = mkCompatAPFromStr vp.s ;
    EmbedPresPart vp           = {s = vp.s} ;
    PastPartAP vpslash         = mkCompatAPFromStr vpslash.s ;
    PastPartAgentAP vpslash np = mkCompatAPFromStr (vpslash.s ++ wordSep ++ np.s ! Nom) ;

    PassVPSlash vpslash         = {s = vpslash.s} ;
    PassAgentVPSlash vpslash np = {s = vpslash.s ++ wordSep ++ np.s ! Nom} ;

    NominalizeVPSlashNP vpslash np =
      lin NP {
        s = \\c => vpslash.s ++ wordSep ++ np.s ! c ;
        a = agrgP3 Masc Sg ;
        lock_NP = <>
      } ;

    ProgrVPSlash vpslash = {s = vpslash.s} ;

    A2VPSlash a2 = {s = adjSurfaceNomMascSg a2 ++ wordSep ++ a2.c2.s} ;
    N2VPSlash n2 = {s = cnSurfaceNomSg (UseN2 n2) ++ wordSep ++ n2.c2.s} ;

    AdvIsNP adv np      = PredVP np (UseComp (CompAdv adv)) ;
    AdvIsNPAP adv np ap = PredVP np (AdvVP (UseComp (CompAP ap)) adv) ;

    PurposeVP vp   = {s = "për të" ++ wordSep ++ vp.s} ;
    WithoutVP vp   = {s = "pa" ++ wordSep ++ vp.s} ;
    ByVP vp        = {s = "nga" ++ wordSep ++ vp.s} ;
    InOrderToVP vp = {s = "që të" ++ wordSep ++ vp.s} ;

    CompoundAP n a =
      AdvAP (PositA a) (PrepCN (mkPrep "nga") (UseN n)) ;

    -- =========================================================
    -- RNP SUBSYSTEM
    -- Strategy: one coherent representation across the family
    -- =========================================================

    ReflRNP vpslash rnp = {s = vpslash.s ++ wordSep ++ rnp.s ! Acc} ;

    ReflPron = mkCompatNPFromStr "veten" Masc Sg ;

    ReflPoss num cn =
      lin NP {
        s = \\c => "të vet" ++ wordSep ++ cn.s ! Indef ! c ! num.n ;
        a = agrgP3 cn.g num.n ;
        lock_NP = <>
      } ;

    PredetRNP pred rnp =
      lin NP {
        s = \\c => pred.s ++ wordSep ++ rnp.s ! c ;
        a = rnp.a ;
        lock_NP = <>
      } ;

    AdvRNP np prep rnp =
      lin NP {
        s = \\c => rnp.s ! c ++ wordSep ++ prep.s ++ wordSep ++ np.s ! Acc ;
        a = rnp.a ;
        lock_NP = <>
      } ;

    AdvRVP vp prep rnp =
      {s = vp.s ++ wordSep ++ prep.s ++ wordSep ++ rnp.s ! Acc} ;

    AdvRAP ap prep rnp =
      lin AP {
        s = \\spec,c,g,n =>
              ap.s ! spec ! c ! g ! n ++ wordSep ++ prep.s ++ wordSep ++ rnp.s ! Acc ;
        lock_AP = <>
      } ;

    ReflA2RNP a2 rnp =
      lin AP {
        s = \\spec,c,g,n =>
              adjComplStr a2 spec c g n ++ wordSep ++ a2.c2.s ++ wordSep ++ rnp.s ! Acc ;
        lock_AP = <>
      } ;

    PossPronRNP pron num cn rnp =
      lin NP {
        s = \\c =>
              pron.s ! c ++ wordSep ++ cn.s ! Indef ! c ! num.n ++ wordSep ++ rnp.s ! Acc ;
        a = pron.a ;
        lock_NP = <>
      } ;

    ConjRNP conj rnps =
      lin NP {
        s = \\c => rnps.init ! c ++ wordSep ++ conj.s ++ wordSep ++ rnps.last ! c ;
        a = rnps.a ;
        lock_NP = <>
      } ;

    Base_rr_RNP r1 r2 =
      lin ListNP {
        init = \\c => r1.s ! c ;
        last = \\c => r2.s ! c ;
        a = r1.a
      } ;

    Base_nr_RNP np r =
      lin ListNP {
        init = \\c => np.s ! c ;
        last = \\c => r.s ! c ;
        a = np.a
      } ;

    Base_rn_RNP r np =
      lin ListNP {
        init = \\c => r.s ! c ;
        last = \\c => np.s ! c ;
        a = r.a
      } ;

    Cons_rr_RNP r rs =
      lin ListNP {
        init = \\c => r.s ! c ++ wordSep ++ rs.init ! c ;
        last = rs.last ;
        a = rs.a
      } ;

    Cons_nr_RNP np rs =
      lin ListNP {
        init = \\c => np.s ! c ++ wordSep ++ rs.init ! c ;
        last = rs.last ;
        a = rs.a
      } ;

    -- =========================================================
    -- CONSTANTS / LEXICAL TAIL
    -- =========================================================

    ReflPossPron = {
      s    = \\c,g,n => "vet" ;
      spec = Indef
    } ;

    iFem_Pron        = mkPronConst "unë" "mua" "mua" "më" "më" Fem Sg ;
    youFem_Pron      = mkPronConst "ti" "ty" "ty" "të" "të" Fem Sg ;
    weFem_Pron       = mkPronConst "ne" "ne" "ne" "na" "na" Fem Pl ;
    youPlFem_Pron    = mkPronConst "ju" "ju" "ju" "ju" "ju" Fem Pl ;
    theyFem_Pron     = mkPronConst "ato" "ato" "atyre" "" "" Fem Pl ;
    theyNeutr_Pron   = mkPronConst "ata" "ata" "atyre" "" "" Masc Pl ;
    youPolFem_Pron   = mkPronConst "ju" "ju" "ju" "ju" "ju" Fem Sg ;
    youPolPl_Pron    = mkPronConst "ju" "ju" "ju" "ju" "ju" Masc Pl ;
    youPolPlFem_Pron = mkPronConst "ju" "ju" "ju" "ju" "ju" Fem Pl ;

    UseDAP dap     = mkCompatNPFromStr dap.s Masc Sg ;
    UseDAPMasc dap = mkCompatNPFromStr dap.s Masc Sg ;
    UseDAPFem dap  = mkCompatNPFromStr dap.s Fem Sg ;

}