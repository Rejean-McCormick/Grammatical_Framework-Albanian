resource ExtendSqiScaffolding =
  open Prelude, Predef, (P = ParamX), GrammarSqi, CatSqi, CommonX, ExtendSqiHelpers, (R = ResSqi) in {

  oper
    -- =========================================================
    -- SCAFFOLDING OPS SAFE TO KEEP IN A RESOURCE
    -- =========================================================

    sc_GenNP : NP -> Quant =
      \np -> lin Quant {
        s    = \\c,g,n => R.link_clitic ! R.Indef ! c ! g ! n ++ np.s ! R.Ablat ;
        spec = R.Indef
      } ;

    sc_GenIP : IP -> IQuant =
      \ip -> lin IQuant {s = "i" ++ ip.s} ;

    sc_GenRP : Num -> CN -> RP =
      \num,cn -> lin RP {
        s = R.link_clitic ! R.Indef ! R.Nom ! cn.g ! num.n ++ cn.s ! R.Indef ! R.Ablat ! num.n
      } ;

    sc_GenModNP : Num -> NP -> CN -> NP =
      \num,np,cn -> np ;

    sc_GenModIP : Num -> IP -> CN -> IP =
      \num,ip,cn -> ip ;

    sc_PiedPipingQuestSlash : IP -> ClSlash -> QS =
      \ip,slash -> lin QS {s = ip.s ++ wordSep ++ slash.s} ;

    sc_PiedPipingRelSlash : RP -> ClSlash -> RS =
      \rp,slash -> lin RS {s = rp.s ++ wordSep ++ slash.s} ;

    sc_StrandQuestSlash : IP -> ClSlash -> QS =
      \ip,slash -> lin QS {s = ip.s ++ wordSep ++ slash.s} ;

    sc_StrandRelSlash : RP -> ClSlash -> RS =
      \rp,slash -> lin RS {s = rp.s ++ wordSep ++ slash.s} ;

    sc_EmptyRelSlash : ClSlash -> RS =
      \slash -> lin RS {s = slash.s} ;

    sc_ProDrop : Pron -> Pron =
      \p -> lin Pron {
        s        = \\_ => "" ;
        acc_clit = p.acc_clit ;
        dat_clit = p.dat_clit ;
        a        = p.a
      } ;

    sc_AdAdV : AdA -> Adv -> AdV =
      \ada,adv -> lin AdV {s = ada.s ++ adv.s} ;

    sc_PositAdVAdj : A -> AdV =
      \a -> lin AdV {s = adjSurfaceNomMascSg a} ;

    sc_IAdvAdv : Adv -> IAdv =
      \adv -> lin IAdv {s = adv.s} ;

    sc_CompS : S -> Comp =
      \s -> lin Comp {s = s.s} ;

    sc_CompQS : QS -> Comp =
      \qs -> lin Comp {s = qs.s} ;

    sc_CompVP : Ant -> Pol -> VP -> Comp =
      \ant,pol,vp -> lin Comp {s = vp.s} ;

    sc_UttAccIP : IP -> Utt =
      \ip -> lin Utt {s = ip.s} ;

    sc_UttDatIP : IP -> Utt =
      \ip -> lin Utt {s = ip.s} ;

    sc_UttAccNP : NP -> Utt =
      \np -> lin Utt {s = np.s ! R.Acc} ;

    sc_UttDatNP : NP -> Utt =
      \np -> lin Utt {s = np.s ! R.Dat} ;

    sc_UttAdV : Adv -> Utt =
      \adv -> lin Utt {s = adv.s} ;

    sc_UttVPShort : VP -> Utt =
      \vp -> lin Utt {s = vp.s} ;

    sc_ComplBareVS : VS -> S -> VP =
      \vs,s -> lin VP {s = verbPres3sg vs ++ wordSep ++ s.s} ;

    sc_SlashBareV2S : V2S -> S -> VPSlash =
      \v2s,s -> lin VPSlash {s = s.s} ;

    sc_ComplDirectVS : VS -> Utt -> VP =
      \vs,utt -> lin VP {s = verbPres3sg vs ++ wordSep ++ utt.s} ;

    sc_ComplDirectVQ : VQ -> Utt -> VP =
      \vq,utt -> lin VP {s = verbPres3sg vq ++ wordSep ++ utt.s} ;

    sc_FrontComplDirectVS : NP -> VS -> Utt -> Cl =
      \np,vs,utt ->
        lin Cl {s = np.s ! R.Nom ++ wordSep ++ utt.s ++ wordSep ++ verbPres3sg vs} ;

    sc_FrontComplDirectVQ : NP -> VQ -> Utt -> Cl =
      \np,vq,utt ->
        lin Cl {s = np.s ! R.Nom ++ wordSep ++ utt.s ++ wordSep ++ verbPres3sg vq} ;

    sc_PredIAdvVP : IAdv -> VP -> QCl =
      \iadv,vp -> lin QCl {s = iadv.s ++ wordSep ++ vp.s} ;

    sc_ApposNP : NP -> NP -> NP =
      \np1,np2 -> lin NP {
        s = \\c => np1.s ! c ++ wordSep ++ np2.s ! c ;
        a = np1.a
      } ;

    sc_ComplGenVV : VV -> Ant -> Pol -> VP -> VP =
      \vv,ant,pol,vp -> vp ;

    sc_CompoundN : N -> N -> N =
      \n1,n2 -> n1 ;

    sc_GerundCN : VP -> CN =
      \vp -> mkCompatCNFromStr vp.s R.Masc ;

    sc_GerundNP : VP -> NP =
      \vp -> mkCompatNPFromStr vp.s R.Masc P.Sg ;

    sc_GerundAdv : VP -> Adv =
      \vp -> lin Adv {s = vp.s} ;

    sc_UncontractedNeg : Pol =
      lin Pol {s = "" ; p = P.Neg} ;

    sc_TPastSimple : Tense =
      lin Tense {s = "" ; t = P.Past} ;

    sc_ComplSlashPartLast : VPSlash -> NP -> VP =
      \vpslash,np -> lin VP {s = vpslash.s ++ wordSep ++ np.s ! R.Acc} ;

    sc_DetNPMasc : Det -> NP =
      \det -> lin NP {
        s = \\c => det.s ! c ! R.Masc ;
        a = R.agrgP3 R.Masc det.n
      } ;

    sc_DetNPFem : Det -> NP =
      \det -> lin NP {
        s = \\c => det.s ! c ! R.Fem ;
        a = R.agrgP3 R.Fem det.n
      } ;

    sc_UseComp_estar : Comp -> VP =
      \comp -> lin VP {s = comp.s} ;

    sc_UseComp_ser : Comp -> VP =
      \comp -> lin VP {s = comp.s} ;

    sc_SubjRelNP : NP -> RS -> NP =
      \np,rs -> lin NP {
        s = \\c => np.s ! c ++ wordSep ++ rs.s ;
        a = np.a
      } ;

    sc_SubjunctRelCN : CN -> RS -> CN =
      \cn,rs -> lin CN {
        s = \\spec,c,n => cn.s ! spec ! c ! n ++ wordSep ++ rs.s ;
        g = cn.g
      } ;

}