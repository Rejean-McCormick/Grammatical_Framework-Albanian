-- GF/lib/src/albanian/ExtendSqi.gf
--# -path=.:../common:../abstract

concrete ExtendSqi of Extend =
  CatSqi ** ExtendFunctor -
  [
    GenNP, GenIP, GenRP, GenModNP, GenModIP,
    PiedPipingQuestSlash, PiedPipingRelSlash, StrandQuestSlash, StrandRelSlash, EmptyRelSlash,
    ProDrop, AdAdV, PositAdVAdj, IAdvAdv, CompS, CompQS, CompVP,
    UttAccIP, UttDatIP, UttAccNP, UttDatNP, UttAdV, UttVPShort,
    ComplBareVS, SlashBareV2S, ComplDirectVS, ComplDirectVQ, FrontComplDirectVS, FrontComplDirectVQ,
    PredIAdvVP, ApposNP, ReflPossPron, ComplGenVV, CompoundN,
    GerundCN, GerundNP, GerundAdv, UncontractedNeg, TPastSimple, ComplSlashPartLast,
    DetNPMasc, DetNPFem, UseComp_estar, UseComp_ser, SubjRelNP, SubjunctRelCN,
    iFem_Pron, youFem_Pron, weFem_Pron, youPlFem_Pron, theyFem_Pron, theyNeutr_Pron,
    youPolFem_Pron, youPolPl_Pron, youPolPlFem_Pron, UseDAP, UseDAPMasc, UseDAPFem,
    ExistS, ExistNPQS, ExistIPQS, ExistCN, ExistMassCN, ExistPluralCN, ExistsNP,
    ICompAP, CompBareCN, CompIQuant, PredAPVP, AdjAsCN, AdjAsNP, CardCNCard,
    FocusObj, FocusAdv, FocusAdV, FocusAP, PrepCN,
    PresPartAP, EmbedPresPart, PastPartAP, PastPartAgentAP,
    PassVPSlash, PassAgentVPSlash, NominalizeVPSlashNP, ProgrVPSlash,
    A2VPSlash, N2VPSlash, AdvIsNP, AdvIsNPAP, PurposeVP, WithoutVP, ByVP, InOrderToVP, CompoundAP,
    ReflRNP, ReflPron, ReflPoss, PredetRNP, AdvRNP, AdvRVP, AdvRAP, ReflA2RNP,
    PossPronRNP, ConjRNP, Base_rr_RNP, Base_nr_RNP, Base_rn_RNP, Cons_rr_RNP, Cons_nr_RNP
  ]
  with
    (Grammar = GrammarSqi) **
  open Prelude,
       ExtendSqiHelpers,
       ExtendSqiScaffolding,
       ExtendSqiExistential,
       ExtendSqiAPCN,
       ExtendSqiFocusPrep,
       ExtendSqiVPBridge,
       ExtendSqiRNP,
       ExtendSqiLexicon
  in {

  lin
    GenNP = sc_GenNP ; GenIP = sc_GenIP ; GenRP = sc_GenRP ; GenModNP = sc_GenModNP ; GenModIP = sc_GenModIP ;
    PiedPipingQuestSlash = sc_PiedPipingQuestSlash ; PiedPipingRelSlash = sc_PiedPipingRelSlash ;
    StrandQuestSlash = sc_StrandQuestSlash ; StrandRelSlash = sc_StrandRelSlash ; EmptyRelSlash = sc_EmptyRelSlash ;

    ProDrop = sc_ProDrop ; AdAdV = sc_AdAdV ; PositAdVAdj = sc_PositAdVAdj ; IAdvAdv = sc_IAdvAdv ;
    CompS = sc_CompS ; CompQS = sc_CompQS ; CompVP = sc_CompVP ;
    UttAccIP = sc_UttAccIP ; UttDatIP = sc_UttDatIP ; UttAccNP = sc_UttAccNP ; UttDatNP = sc_UttDatNP ; UttAdV = sc_UttAdV ; UttVPShort = sc_UttVPShort ;
    ComplBareVS = sc_ComplBareVS ; SlashBareV2S = sc_SlashBareV2S ; ComplDirectVS = sc_ComplDirectVS ; ComplDirectVQ = sc_ComplDirectVQ ;
    FrontComplDirectVS = sc_FrontComplDirectVS ; FrontComplDirectVQ = sc_FrontComplDirectVQ ;
    PredIAdvVP = sc_PredIAdvVP ; ApposNP = sc_ApposNP ; ComplGenVV = sc_ComplGenVV ; CompoundN = sc_CompoundN ;
    GerundCN = sc_GerundCN ; GerundNP = sc_GerundNP ; GerundAdv = sc_GerundAdv ;
    UncontractedNeg = sc_UncontractedNeg ; TPastSimple = sc_TPastSimple ; ComplSlashPartLast = sc_ComplSlashPartLast ;
    DetNPMasc = sc_DetNPMasc ; DetNPFem = sc_DetNPFem ; UseComp_estar = sc_UseComp_estar ; UseComp_ser = sc_UseComp_ser ;
    SubjRelNP = sc_SubjRelNP ; SubjunctRelCN = sc_SubjunctRelCN ;

    ExistS = ex_ExistS ; ExistNPQS = ex_ExistNPQS ; ExistIPQS = ex_ExistIPQS ;
    ExistCN = ex_ExistCN ; ExistMassCN = ex_ExistMassCN ; ExistPluralCN = ex_ExistPluralCN ; ExistsNP = ex_ExistsNP ;

    ICompAP = apcn_ICompAP ; CompBareCN = apcn_CompBareCN ; CompIQuant = apcn_CompIQuant ;
    PredAPVP = apcn_PredAPVP ; AdjAsCN = apcn_AdjAsCN ; AdjAsNP = apcn_AdjAsNP ; CardCNCard = apcn_CardCNCard ;

    FocusObj = fp_FocusObj ; FocusAdv = fp_FocusAdv ; FocusAdV = fp_FocusAdV ; FocusAP = fp_FocusAP ; PrepCN = fp_PrepCN ;

    PresPartAP = vp_PresPartAP ; EmbedPresPart = vp_EmbedPresPart ; PastPartAP = vp_PastPartAP ; PastPartAgentAP = vp_PastPartAgentAP ;
    PassVPSlash = vp_PassVPSlash ; PassAgentVPSlash = vp_PassAgentVPSlash ; NominalizeVPSlashNP = vp_NominalizeVPSlashNP ; ProgrVPSlash = vp_ProgrVPSlash ;
    A2VPSlash = vp_A2VPSlash ; N2VPSlash = vp_N2VPSlash ; AdvIsNP = vp_AdvIsNP ; AdvIsNPAP = vp_AdvIsNPAP ;
    PurposeVP = vp_PurposeVP ; WithoutVP = vp_WithoutVP ; ByVP = vp_ByVP ; InOrderToVP = vp_InOrderToVP ; CompoundAP = vp_CompoundAP ;

    ReflRNP = rnp_ReflRNP ; ReflPron = rnp_ReflPron ; ReflPoss = rnp_ReflPoss ; PredetRNP = rnp_PredetRNP ;
    AdvRNP = rnp_AdvRNP ; AdvRVP = rnp_AdvRVP ; AdvRAP = rnp_AdvRAP ; ReflA2RNP = rnp_ReflA2RNP ;
    PossPronRNP = rnp_PossPronRNP ; ConjRNP = rnp_ConjRNP ;
    Base_rr_RNP = rnp_Base_rr_RNP ; Base_nr_RNP = rnp_Base_nr_RNP ; Base_rn_RNP = rnp_Base_rn_RNP ;
    Cons_rr_RNP = rnp_Cons_rr_RNP ; Cons_nr_RNP = rnp_Cons_nr_RNP ;

    ReflPossPron = lex_ReflPossPron ;
    iFem_Pron = lex_iFem_Pron ; youFem_Pron = lex_youFem_Pron ; weFem_Pron = lex_weFem_Pron ; youPlFem_Pron = lex_youPlFem_Pron ;
    theyFem_Pron = lex_theyFem_Pron ; theyNeutr_Pron = lex_theyNeutr_Pron ;
    youPolFem_Pron = lex_youPolFem_Pron ; youPolPl_Pron = lex_youPolPl_Pron ; youPolPlFem_Pron = lex_youPolPlFem_Pron ;
    UseDAP = lex_UseDAP ; UseDAPMasc = lex_UseDAPMasc ; UseDAPFem = lex_UseDAPFem ;

}