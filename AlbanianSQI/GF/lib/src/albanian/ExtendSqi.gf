-- GF/lib/src/albanian/ExtendSqi.gf
--# -path=.:../common:../abstract
concrete ExtendSqi of Extend =
  CatSqi ** ExtendFunctor -
  [
    VPS, ListVPS, VPI, ListVPI, VPS2, ListVPS2, VPI2, ListVPI2,
    RNP, RNPList, X, ListComp, ListImp,

    GenNP, GenIP, GenRP, GenModNP, GenModIP,
    PiedPipingQuestSlash, PiedPipingRelSlash, StrandQuestSlash, StrandRelSlash, EmptyRelSlash,

    MkVPS, ConjVPS, PredVPS, SQuestVPS, QuestVPS, RelVPS,
    ExistS, ExistNPQS, ExistIPQS, ExistCN, ExistMassCN, ExistPluralCN, ExistsNP,

    MkVPI, ConjVPI, ComplVPIVV,
    MkVPS2, ConjVPS2, ComplVPS2, ReflVPS2,
    MkVPI2, ConjVPI2, ComplVPI2,

    BaseVPS, ConsVPS, BaseVPI, ConsVPI, BaseVPS2, ConsVPS2, BaseVPI2, ConsVPI2,
    BaseComp, ConsComp, ConjComp, BaseImp, ConsImp, ConjImp,

    ProDrop, AdAdV, PositAdVAdj, ICompAP, IAdvAdv,
    CompBareCN, CompIQuant, CompS, CompQS, CompVP,

    UttAccIP, UttDatIP, UttAccNP, UttDatNP, UttAdV, UttVPShort,

    FocusObj, FocusAdv, FocusAdV, FocusAP, PrepCN,

    PresPartAP, EmbedPresPart, PastPartAP, PastPartAgentAP,
    PassVPSlash, PassAgentVPSlash, NominalizeVPSlashNP, ProgrVPSlash,
    A2VPSlash, N2VPSlash, AdvIsNP, AdvIsNPAP,

    PurposeVP, WithoutVP, ByVP, InOrderToVP,

    ComplBareVS, SlashBareV2S, ComplDirectVS, ComplDirectVQ,
    FrontComplDirectVS, FrontComplDirectVQ,

    PredAPVP, PredIAdvVP, AdjAsCN, AdjAsNP, ApposNP,

    ReflRNP, ReflPron, ReflPoss, PredetRNP, AdvRNP, AdvRVP, AdvRAP, ReflA2RNP,
    PossPronRNP, ConjRNP,
    Base_rr_RNP, Base_nr_RNP, Base_rn_RNP,
    Cons_rr_RNP, Cons_nr_RNP, Cons_rn_RNP,

    ReflPossPron, ComplGenVV, CompoundN, CompoundAP,
    GerundCN, GerundNP, GerundAdv,
    UncontractedNeg, TPastSimple, ComplSlashPartLast,

    DetNPMasc, DetNPFem, UseComp_estar, UseComp_ser,
    SubjRelNP, SubjunctRelCN,

    iFem_Pron, youFem_Pron, weFem_Pron, youPlFem_Pron,
    theyFem_Pron, theyNeutr_Pron,
    youPolFem_Pron, youPolPl_Pron, youPolPlFem_Pron,

    UseDAP, UseDAPMasc, UseDAPFem,
    CardCNCard, AdjOrd, SentAP
  ]
  with
    (Grammar = GrammarSqi) **
  open Prelude, Predef, ResSqi, ParamX in {

  oper
    sp : Str = " " ;

    agrMascSg : Agr = agrgP3 Masc Sg ;

    cnStr : CN -> Str = \cn -> cn.s ! Indef ! Nom ! Sg ;
    apStr : AP -> Str = \ap -> ap.s ! Indef ! Nom ! Masc ! Sg ;
    adjToStr : Adj -> Str = \a -> a.s ! Nom ! Masc ! Sg ;

    apConst : Str -> AP =
      \w -> lin AP {s = \\spec,cas,g,n => w} ;

    cnConst : Str -> Gender -> CN =
      \w,g -> lin CN {s = \\spec,cas,n => w ; g = g} ;

    npConst : Str -> Gender -> Number -> NP =
      \w,g,n -> lin NP {
        s = \\cas => w ;
        a = agrgP3 g n
      } ;

    mkPronConst : Str -> Str -> Str -> Str -> Str -> Gender -> Number -> CatSqi.Pron =
      \nom,acc,dat,accCl,datCl,g,n -> lin CatSqi.Pron {
        s        = table {Nom => nom ; Acc => acc ; Dat => dat ; Ablat => dat} ;
        acc_clit = accCl ;
        dat_clit = datCl ;
        a        = agrgP3 g n
      } ;

    ipNom : IP -> Str = \ip -> ip.s ;
    ipAcc : IP -> Str = \ip -> ip.s ;
    ipDat : IP -> Str = \ip -> ip.s ;

  lincat
    VPS, VPI, VPS2, VPI2, RNP, RNPList, X = {s : Str} ;
    [VPS], [VPI], [VPS2], [VPI2], [Comp], [Imp] = {s : Str} ;

  lin
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

    PiedPipingQuestSlash ip slash = {s = ip.s ++ sp ++ slash.s} ;
    PiedPipingRelSlash rp slash   = {s = rp.s ++ sp ++ slash.s} ;
    StrandQuestSlash ip slash     = {s = ip.s ++ sp ++ slash.s} ;
    StrandRelSlash rp slash       = {s = rp.s ++ sp ++ slash.s} ;
    EmptyRelSlash slash           = {s = slash.s} ;

    MkVPS temp pol vp = {s = vp.s} ;
    ConjVPS conj vpss = {s = vpss.s} ;
    PredVPS np vps    = {s = np.s ! Nom ++ sp ++ vps.s} ;
    SQuestVPS np vps  = {s = np.s ! Nom ++ sp ++ vps.s} ;
    QuestVPS ip vps   = {s = ip.s ++ sp ++ vps.s} ;
    RelVPS rp vps     = {s = rp.s ++ sp ++ vps.s} ;

    ExistS s          = {s = s.s} ;
    ExistNPQS np qs   = {s = np.s ! Nom ++ sp ++ qs.s} ;
    ExistIPQS ip qs   = {s = ip.s ++ sp ++ qs.s} ;

    ExistCN cn        = {s = cnStr cn} ;
    ExistMassCN cn    = {s = cnStr cn} ;
    ExistPluralCN cn  = {s = cnStr cn} ;
    ExistsNP np       = {s = np.s ! Nom} ;

    MkVPI vp          = {s = vp.s} ;
    ConjVPI conj vpis = {s = vpis.s} ;
    ComplVPIVV vv vpi = {s = vpi.s} ;

    MkVPS2 temp pol vpslash = {s = vpslash.s} ;
    ConjVPS2 conj vps2s     = {s = vps2s.s} ;
    ComplVPS2 vps2 np       = {s = vps2.s ++ sp ++ np.s ! Acc} ;
    ReflVPS2 vpslash        = {s = vpslash.s} ;

    MkVPI2 vpslash      = {s = vpslash.s} ;
    ConjVPI2 conj vpi2s = {s = vpi2s.s} ;
    ComplVPI2 vpi2 np   = {s = vpi2.s ++ sp ++ np.s ! Acc} ;

    BaseVPS x y   = {s = x.s ++ sp ++ y.s} ;
    ConsVPS x xs  = {s = x.s ++ sp ++ xs.s} ;

    BaseVPI x y   = {s = x.s ++ sp ++ y.s} ;
    ConsVPI x xs  = {s = x.s ++ sp ++ xs.s} ;

    BaseVPS2 x y  = {s = x.s ++ sp ++ y.s} ;
    ConsVPS2 x xs = {s = x.s ++ sp ++ xs.s} ;

    BaseVPI2 x y  = {s = x.s ++ sp ++ y.s} ;
    ConsVPI2 x xs = {s = x.s ++ sp ++ xs.s} ;

    BaseComp x y  = {s = x.s ++ sp ++ y.s} ;
    ConsComp x xs = {s = x.s ++ sp ++ xs.s} ;

    BaseImp x y   = {s = x.s ++ sp ++ y.s} ;
    ConsImp x xs  = {s = x.s ++ sp ++ xs.s} ;

    ConjComp conj comps = {s = comps.s} ;
    ConjImp conj imps   = {s = imps.s} ;

    ProDrop p = lin CatSqi.Pron {
      s        = \\_ => "" ;
      acc_clit = p.acc_clit ;
      dat_clit = p.dat_clit ;
      a        = p.a
    } ;

    AdAdV ada adv   = {s = ada.s ++ adv.s} ;
    PositAdVAdj a   = {s = adjToStr a} ;
    ICompAP ap      = {s = apStr ap} ;
    IAdvAdv adv     = {s = adv.s} ;

    CompBareCN cn     = {s = cnStr cn} ;
    CompIQuant iq     = {s = iq.s} ;
    CompS s           = {s = s.s} ;
    CompQS qs         = {s = qs.s} ;
    CompVP ant pol vp = {s = vp.s} ;

    UttAccIP ip   = {s = ip.s} ;
    UttDatIP ip   = {s = ip.s} ;
    UttAccNP np   = {s = np.s ! Acc} ;
    UttDatNP np   = {s = np.s ! Dat} ;
    UttAdV adv    = {s = adv.s} ;
    UttVPShort vp = {s = vp.s} ;

    FocusObj np sslash = {s = np.s ! Nom ++ sp ++ sslash.s} ;
    FocusAdv adv s     = {s = adv.s ++ sp ++ s.s} ;
    FocusAdV adv s     = {s = adv.s ++ sp ++ s.s} ;
    FocusAP ap np      = {s = apStr ap ++ sp ++ np.s ! Nom} ;

    PrepCN prep cn = {s = prep.s ++ sp ++ cnStr cn} ;

    PresPartAP vp              = apConst vp.s ;
    EmbedPresPart vp           = {s = vp.s} ;
    PastPartAP vpslash         = apConst vpslash.s ;
    PastPartAgentAP vpslash np = apConst (vpslash.s ++ sp ++ np.s ! Nom) ;

    PassVPSlash vpslash         = {s = vpslash.s} ;
    PassAgentVPSlash vpslash np = {s = vpslash.s ++ sp ++ np.s ! Nom} ;

    NominalizeVPSlashNP vpslash np = cnConst (vpslash.s ++ sp ++ np.s ! Nom) Masc ;
    ProgrVPSlash vpslash           = {s = vpslash.s} ;

    A2VPSlash a2 np = {s = adjToStr a2 ++ sp ++ np.s ! Acc} ;
    N2VPSlash n2 np = {s = cnStr n2 ++ sp ++ np.s ! Acc} ;

    AdvIsNP adv np      = {s = adv.s ++ sp ++ np.s ! Nom} ;
    AdvIsNPAP adv np ap = {s = adv.s ++ sp ++ np.s ! Nom ++ sp ++ apStr ap} ;

    PurposeVP vp   = {s = "për të" ++ sp ++ vp.s} ;
    WithoutVP vp   = {s = "pa" ++ sp ++ vp.s} ;
    ByVP vp        = {s = "nga" ++ sp ++ vp.s} ;
    InOrderToVP vp = {s = "që të" ++ sp ++ vp.s} ;

    ComplBareVS vs s   = {s = (vs.s ! ParamX.Pres ! agrMascSg) ++ sp ++ s.s} ;
    SlashBareV2S v2s s = {s = s.s} ;

    ComplDirectVS vs utt = {s = (vs.s ! ParamX.Pres ! agrMascSg) ++ sp ++ utt.s} ;
    ComplDirectVQ vq utt = {s = (vq.s ! ParamX.Pres ! agrMascSg) ++ sp ++ utt.s} ;

    FrontComplDirectVS np vs utt = {s = np.s ! Nom ++ sp ++ utt.s ++ sp ++ (vs.s ! ParamX.Pres ! agrMascSg)} ;
    FrontComplDirectVQ np vq utt = {s = np.s ! Nom ++ sp ++ utt.s ++ sp ++ (vq.s ! ParamX.Pres ! agrMascSg)} ;

    PredAPVP ap vp     = {s = apStr ap ++ sp ++ vp.s} ;
    PredIAdvVP iadv vp = {s = iadv.s ++ sp ++ vp.s} ;

    AdjAsCN ap = cnConst (apStr ap) Masc ;
    AdjAsNP ap = npConst (apStr ap) Masc Sg ;

    ApposNP np1 np2 = {
      s = \\c => np1.s ! c ++ sp ++ np2.s ! c ;
      a = np1.a
    } ;

    ReflRNP vpslash rnp = {s = vpslash.s ++ sp ++ rnp.s} ;
    ReflPron            = {s = "veten"} ;
    ReflPoss num cn     = {s = "të vet" ++ sp ++ cnStr cn} ;

    PredetRNP pred rnp = {s = pred.s ++ sp ++ rnp.s} ;
    AdvRNP np prep rnp = {s = rnp.s ++ sp ++ prep.s ++ sp ++ np.s ! Nom} ;
    AdvRVP vp prep rnp = {s = vp.s ++ sp ++ prep.s ++ sp ++ rnp.s} ;
    AdvRAP ap prep rnp = ap ;
    ReflA2RNP a2 rnp   = apConst (adjToStr a2) ;

    PossPronRNP pron num cn rnp = {
      s = pron.s ! Nom ++ sp ++ cnStr cn
    } ;

    ConjRNP conj rnps = {s = rnps.s} ;

    Base_rr_RNP r1 r2 = {s = r1.s ++ sp ++ r2.s} ;
    Base_nr_RNP np r  = {s = np.s ! Nom ++ sp ++ r.s} ;
    Base_rn_RNP r np  = {s = r.s ++ sp ++ np.s ! Nom} ;

    Cons_rr_RNP r rs  = {s = r.s ++ sp ++ rs.s} ;
    Cons_nr_RNP np rs = {s = np.s ! Nom ++ sp ++ rs.s} ;
    Cons_rn_RNP r rs  = {s = r.s ++ sp ++ rs.s} ;

    ReflPossPron = {
      s    = \\c,g,n => "vet" ;
      spec = Indef
    } ;

    ComplGenVV vv ant pol vp = vp ;

    CompoundN n1 n2 = n1 ;
    CompoundAP n a  = apConst (cnStr n ++ sp ++ adjToStr a) ;

    GerundCN vp  = cnConst vp.s Masc ;
    GerundNP vp  = npConst vp.s Masc Sg ;
    GerundAdv vp = {s = vp.s} ;

    UncontractedNeg = {s = "nuk" ; p = ParamX.Neg} ;
    TPastSimple     = {s = "" ; t = ParamX.Past} ;

    ComplSlashPartLast vpslash np = {s = vpslash.s ++ sp ++ np.s ! Acc} ;

    DetNPMasc det = {
      s = \\c => det.s ! c ! Masc ;
      a = agrgP3 Masc det.n
    } ;

    DetNPFem det = {
      s = \\c => det.s ! c ! Fem ;
      a = agrgP3 Fem det.n
    } ;

    UseComp_estar comp = {s = comp.s} ;
    UseComp_ser   comp = {s = comp.s} ;

    SubjRelNP np rs = {
      s = \\c => np.s ! c ++ sp ++ rs.s ;
      a = np.a
    } ;

    SubjunctRelCN cn rs = cnConst (cnStr cn ++ sp ++ rs.s) cn.g ;

    iFem_Pron        = mkPronConst "unë" "mua" "mua" "më" "më" Fem Sg ;
    youFem_Pron      = mkPronConst "ti" "ty" "ty" "të" "të" Fem Sg ;
    weFem_Pron       = mkPronConst "ne" "ne" "ne" "na" "na" Fem Pl ;
    youPlFem_Pron    = mkPronConst "ju" "ju" "ju" "ju" "ju" Fem Pl ;
    theyFem_Pron     = mkPronConst "ato" "ato" "atyre" "" "" Fem Pl ;
    theyNeutr_Pron   = mkPronConst "ata" "ata" "atyre" "" "" Masc Pl ;
    youPolFem_Pron   = mkPronConst "ju" "ju" "ju" "ju" "ju" Fem Sg ;
    youPolPl_Pron    = mkPronConst "ju" "ju" "ju" "ju" "ju" Masc Pl ;
    youPolPlFem_Pron = mkPronConst "ju" "ju" "ju" "ju" "ju" Fem Pl ;

    UseDAP dap     = npConst dap.s Masc Sg ;
    UseDAPMasc dap = npConst dap.s Masc Sg ;
    UseDAPFem dap  = npConst dap.s Fem Sg ;

    CardCNCard card cn = cnConst (card.s ++ sp ++ cnStr cn) cn.g ;

    AdjOrd ord = {
      s = \\_,_,_,_ => ord.s
    } ;

    SentAP ap sc = {
      s = \\spec,c,g,n => ap.s ! spec ! c ! g ! n ++ "që" ++ sc.s
    } ;

}