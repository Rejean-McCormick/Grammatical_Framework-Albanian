-- GF/lib/src/albanian/ExtendSqi.gf
--# -path=.:../common:../abstract
concrete ExtendSqi of Extend =
  CatSqi ** ExtendFunctor -
  [
    VPS, ListVPS, VPI, ListVPI, VPS2, ListVPS2, VPI2, ListVPI2,
    X, ListComp, ListImp,

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
    extSp : Str = " " ;

    agrMascSg : Agr = agrgP3 Masc Sg ;

    cnStr : CN -> Str = \cn -> cn.s ! Indef ! Nom ! Sg ;
    apStr : AP -> Str = \ap -> ap.s ! Indef ! Nom ! Masc ! Sg ;
    adjToStr : Adj -> Str = \a -> a.s ! Nom ! Masc ! Sg ;

    vPres3sg : Verb -> Str =
      \v -> v.Indicative ! ParamX.Pres ! Sg ! P3 ;

    apConst : Str -> AP =
      \w -> lin AP {s = \\spec,cas,g,n => w} ;

    cnConst : Str -> Gender -> CN =
      \w,g -> lin CN {s = \\spec,cas,n => w ; g = g} ;

    npConst : Str -> Gender -> Number -> NP =
      \w,g,n -> lin NP {
        s = \\cas => w ;
        a = agrgP3 g n
      } ;

    bareNPfromCN : Number -> CN -> NP =
      \n,cn -> lin NP {
        s = \\c => cn.s ! Indef ! c ! n ;
        a = agrgP3 cn.g n
      } ;

    prepNPAdv : Prep -> NP -> Adv =
      \prep,np -> {s = prep.s ++ extSp ++ np.s ! Acc} ;

    compApStr : AP -> Str = \ap -> (CompAP ap).s ;
    compCnStr : CN -> Str = \cn -> (CompCN cn).s ;

    mkPronConst : Str -> Str -> Str -> Str -> Str -> Gender -> Number -> CatSqi.Pron =
      \nom,acc,dat,accCl,datCl,g,n -> lin Pron {
        s        = table {Nom => nom ; Acc => acc ; Dat => dat ; Ablat => dat} ;
        acc_clit = accCl ;
        dat_clit = datCl ;
        a        = agrgP3 g n
      } ;

    ipNom : IP -> Str = \ip -> ip.s ;
    ipAcc : IP -> Str = \ip -> ip.s ;
    ipDat : IP -> Str = \ip -> ip.s ;

    adjComplStr : Adj -> Species -> Case -> Gender -> Number -> Str =
      \a,spec,c,g,n ->
        case a.clit of {
          True  => link_clitic ! spec ! c ! g ! n ++ a.s ! c ! g ! n ;
          False => a.s ! c ! g ! n
        } ;

  lincat
    VPS, VPI, VPS2, VPI2, X = {s : Str} ;
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

    PiedPipingQuestSlash ip slash = {s = ip.s ++ extSp ++ slash.s} ;
    PiedPipingRelSlash rp slash   = {s = rp.s ++ extSp ++ slash.s} ;
    StrandQuestSlash ip slash     = {s = ip.s ++ extSp ++ slash.s} ;
    StrandRelSlash rp slash       = {s = rp.s ++ extSp ++ slash.s} ;
    EmptyRelSlash slash           = {s = slash.s} ;

    MkVPS temp pol vp = {s = vp.s} ;
    ConjVPS conj vpss = {s = vpss.s} ;
    PredVPS np vps    = {s = np.s ! Nom ++ extSp ++ vps.s} ;
    SQuestVPS np vps  = {s = np.s ! Nom ++ extSp ++ vps.s} ;
    QuestVPS ip vps   = {s = ip.s ++ extSp ++ vps.s} ;
    RelVPS rp vps     = {s = rp.s ++ extSp ++ vps.s} ;

    ExistS temp pol np    = UseCl temp pol (ExistNP np) ;
    ExistNPQS temp pol np = UseQCl temp pol (QuestCl (ExistNP np)) ;
    ExistIPQS temp pol ip = UseQCl temp pol (ExistIP ip) ;

    ExistCN cn        = ExistNP (DetCN (DetQuant IndefArt NumSg) cn) ;
    ExistMassCN cn    = ExistNP (bareNPfromCN Sg cn) ;
    ExistPluralCN cn  = ExistNP (DetCN (DetQuant IndefArt NumPl) cn) ;
    ExistsNP          = ExistNP ;

    MkVPI vp          = {s = vp.s} ;
    ConjVPI conj vpis = {s = vpis.s} ;
    ComplVPIVV vv vpi = {s = vpi.s} ;

    MkVPS2 temp pol vpslash = {s = vpslash.s} ;
    ConjVPS2 conj vps2s     = {s = vps2s.s} ;
    ComplVPS2 vps2 np       = {s = vps2.s ++ extSp ++ np.s ! Acc} ;
    ReflVPS2 vps2 rnp       = {s = vps2.s ++ extSp ++ rnp.s ! Acc} ;

    MkVPI2 vpslash      = {s = vpslash.s} ;
    ConjVPI2 conj vpi2s = {s = vpi2s.s} ;
    ComplVPI2 vpi2 np   = {s = vpi2.s ++ extSp ++ np.s ! Acc} ;

    BaseVPS x y   = {s = x.s ++ extSp ++ y.s} ;
    ConsVPS x xs  = {s = x.s ++ extSp ++ xs.s} ;

    BaseVPI x y   = {s = x.s ++ extSp ++ y.s} ;
    ConsVPI x xs  = {s = x.s ++ extSp ++ xs.s} ;

    BaseVPS2 x y  = {s = x.s ++ extSp ++ y.s} ;
    ConsVPS2 x xs = {s = x.s ++ extSp ++ xs.s} ;

    BaseVPI2 x y  = {s = x.s ++ extSp ++ y.s} ;
    ConsVPI2 x xs = {s = x.s ++ extSp ++ xs.s} ;

    BaseComp x y  = {s = x.s ++ extSp ++ y.s} ;
    ConsComp x xs = {s = x.s ++ extSp ++ xs.s} ;

    BaseImp x y   = {s = x.s ++ extSp ++ y.s} ;
    ConsImp x xs  = {s = x.s ++ extSp ++ xs.s} ;

    ConjComp conj comps = {s = comps.s} ;
    ConjImp conj imps   = {s = imps.s} ;

    ProDrop p = lin Pron {
      s        = \\_ => "" ;
      acc_clit = p.acc_clit ;
      dat_clit = p.dat_clit ;
      a        = p.a
    } ;

    AdAdV ada adv   = {s = ada.s ++ adv.s} ;
    PositAdVAdj a   = {s = adjToStr a} ;
    ICompAP ap      = {s = compApStr ap} ;
    IAdvAdv adv     = {s = adv.s} ;

    CompBareCN cn     = CompCN cn ;
    CompIQuant iq     = CompIP (IdetIP (IdetQuant iq NumSg)) ;
    CompS s           = {s = s.s} ;
    CompQS qs         = {s = qs.s} ;
    CompVP ant pol vp = {s = vp.s} ;

    UttAccIP ip   = {s = ip.s} ;
    UttDatIP ip   = {s = ip.s} ;
    UttAccNP np   = {s = np.s ! Acc} ;
    UttDatNP np   = {s = np.s ! Dat} ;
    UttAdV adv    = {s = adv.s} ;
    UttVPShort vp = {s = vp.s} ;

    FocusObj np sslash = {s = np.s ! Nom ++ extSp ++ sslash.s} ;
    FocusAdv adv s     = {s = adv.s ++ extSp ++ s.s} ;
    FocusAdV adv s     = {s = adv.s ++ extSp ++ s.s} ;
    FocusAP ap np      = {s = compApStr ap ++ extSp ++ np.s ! Nom} ;

    PrepCN prep cn = prepNPAdv prep (bareNPfromCN Sg cn) ;

    PresPartAP vp              = apConst vp.s ;
    EmbedPresPart vp           = {s = vp.s} ;
    PastPartAP vpslash         = apConst vpslash.s ;
    PastPartAgentAP vpslash np = apConst (vpslash.s ++ extSp ++ np.s ! Nom) ;

    PassVPSlash vpslash         = {s = vpslash.s} ;
    PassAgentVPSlash vpslash np = {s = vpslash.s ++ extSp ++ np.s ! Nom} ;

    NominalizeVPSlashNP vpslash np =
      lin NP {
        s = \\c => vpslash.s ++ extSp ++ np.s ! c ;
        a = agrgP3 Masc Sg
      } ;

    ProgrVPSlash vpslash = {s = vpslash.s} ;

    A2VPSlash a2 = {s = adjToStr a2 ++ extSp ++ a2.c2.s} ;
    N2VPSlash n2 = {s = compCnStr (UseN2 n2) ++ extSp ++ n2.c2.s} ;

    AdvIsNP adv np      = PredVP np (UseComp (CompAdv adv)) ;
    AdvIsNPAP adv np ap = PredVP np (AdvVP (UseComp (CompAP ap)) adv) ;

    PurposeVP vp   = {s = "për të" ++ extSp ++ vp.s} ;
    WithoutVP vp   = {s = "pa" ++ extSp ++ vp.s} ;
    ByVP vp        = {s = "nga" ++ extSp ++ vp.s} ;
    InOrderToVP vp = {s = "që të" ++ extSp ++ vp.s} ;

    ComplBareVS vs s   = {s = vPres3sg vs ++ extSp ++ s.s} ;
    SlashBareV2S v2s s = {s = s.s} ;

    ComplDirectVS vs utt = {s = vPres3sg vs ++ extSp ++ utt.s} ;
    ComplDirectVQ vq utt = {s = vPres3sg vq ++ extSp ++ utt.s} ;

    FrontComplDirectVS np vs utt = {s = np.s ! Nom ++ extSp ++ utt.s ++ extSp ++ vPres3sg vs} ;
    FrontComplDirectVQ np vq utt = {s = np.s ! Nom ++ extSp ++ utt.s ++ extSp ++ vPres3sg vq} ;

    PredAPVP ap vp =
      ImpersCl (UseComp (CompAP (AdjectiveSqi.SentAP ap (EmbedVP vp)))) ;
    PredIAdvVP iadv vp = {s = iadv.s ++ extSp ++ vp.s} ;

    AdjAsCN ap =
      lin CN {
        s = \\spec,c,n => compApStr ap ;
        g = Masc
      } ;
    AdjAsNP ap =
      lin NP {
        s = \\c => compApStr ap ;
        a = agrgP3 Masc Sg
      } ;

    ApposNP np1 np2 =
      lin NP {
        s = \\c => np1.s ! c ++ extSp ++ np2.s ! c ;
        a = np1.a
      } ;

    ReflRNP vpslash rnp = {s = vpslash.s ++ extSp ++ rnp.s ! Acc} ;

    ReflPron = npConst "veten" Masc Sg ;

    ReflPoss num cn =
      lin NP {
        s = \\c => "të vet" ++ extSp ++ cn.s ! Indef ! c ! num.n ;
        a = agrgP3 cn.g num.n
      } ;

    PredetRNP pred rnp =
      lin NP {
        s = \\c => pred.s ++ extSp ++ rnp.s ! c ;
        a = rnp.a
      } ;

    AdvRNP np prep rnp =
      lin NP {
        s = \\c => rnp.s ! c ++ extSp ++ prep.s ++ extSp ++ np.s ! Acc ;
        a = rnp.a
      } ;

    AdvRVP vp prep rnp = {s = vp.s ++ extSp ++ prep.s ++ extSp ++ rnp.s ! Acc} ;

    AdvRAP ap prep rnp =
      lin AP {
        s = \\spec,c,g,n =>
              ap.s ! spec ! c ! g ! n ++ extSp ++ prep.s ++ extSp ++ rnp.s ! Acc
      } ;

    ReflA2RNP a2 rnp =
      lin AP {
        s = \\spec,c,g,n =>
              adjComplStr a2 spec c g n ++ extSp ++ a2.c2.s ++ extSp ++ rnp.s ! Acc
      } ;

    PossPronRNP pron num cn rnp =
      lin NP {
        s = \\c => pron.s ! c ++ extSp ++ cn.s ! Indef ! c ! num.n ++ extSp ++ rnp.s ! Acc ;
        a = pron.a
      } ;

    ConjRNP conj rnps =
      lin NP {
        s = \\c => rnps.init ! c ++ extSp ++ conj.s ++ extSp ++ rnps.last ! c ;
        a = rnps.a
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
        init = \\c => r.s ! c ++ extSp ++ rs.init ! c ;
        last = rs.last ;
        a = rs.a
      } ;

    Cons_nr_RNP np rs =
      lin ListNP {
        init = \\c => np.s ! c ++ extSp ++ rs.init ! c ;
        last = rs.last ;
        a = rs.a
      } ;

    Cons_rn_RNP r rs =
      lin ListNP {
        init = \\c => r.s ! c ++ extSp ++ rs.init ! c ;
        last = rs.last ;
        a = rs.a
      } ;

    ReflPossPron = {
      s    = \\c,g,n => "vet" ;
      spec = Indef
    } ;

    ComplGenVV vv ant pol vp = vp ;

    CompoundN n1 n2 = n1 ;
    CompoundAP n a  =
      AdvAP (PositA a) (prepNPAdv (mkPrep "nga") (bareNPfromCN Sg (UseN n))) ;

    GerundCN vp  = cnConst vp.s Masc ;
    GerundNP vp  = npConst vp.s Masc Sg ;
    GerundAdv vp = {s = vp.s} ;

    UncontractedNeg = {s = "nuk" ; p = ParamX.Neg} ;
    TPastSimple     = {s = "" ; t = ParamX.Past} ;

    ComplSlashPartLast vpslash np = {s = vpslash.s ++ extSp ++ np.s ! Acc} ;

    DetNPMasc det =
      lin NP {
        s = \\c => det.s ! c ! Masc ;
        a = agrgP3 Masc det.n
      } ;

    DetNPFem det =
      lin NP {
        s = \\c => det.s ! c ! Fem ;
        a = agrgP3 Fem det.n
      } ;

    UseComp_estar comp = {s = comp.s} ;
    UseComp_ser   comp = {s = comp.s} ;

    SubjRelNP np rs =
      lin NP {
        s = \\c => np.s ! c ++ extSp ++ rs.s ;
        a = np.a
      } ;

    SubjunctRelCN cn rs =
      lin CN {
        s = \\spec,c,n => cn.s ! spec ! c ! n ++ extSp ++ rs.s ;
        g = cn.g
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

    UseDAP dap     = npConst dap.s Masc Sg ;
    UseDAPMasc dap = npConst dap.s Masc Sg ;
    UseDAPFem dap  = npConst dap.s Fem Sg ;

    CardCNCard card cn = {s = card.s ++ extSp ++ compCnStr cn} ;

    AdjOrd ord = {
      s = \\_,_,_,_ => ord.s
    } ;

    SentAP ap sc = {
      s = \\spec,c,g,n => ap.s ! spec ! c ! g ! n ++ "që" ++ sc.s
    } ;

}