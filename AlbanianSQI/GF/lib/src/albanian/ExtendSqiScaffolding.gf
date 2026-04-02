resource ExtendSqiScaffolding =
  open Prelude, Predef, (P = ParamX), GrammarSqi, CatSqi, CommonX,
       ExtendSqiHelpers, (R = ResSqi) in {

  oper
    -- =========================================================
    -- SCAFFOLDING OPS SAFE TO KEEP IN A RESOURCE
    -- Strategy:
    -- - keep coordinator-facing helpers shallow and explicit
    -- - preserve current working Albanian category shapes
    -- - expose minimal boundary glue for Comp/Imp/VPI/VPS families
    --   without moving ownership into ExtendSqi.gf
    -- =========================================================

    sc_npSurfaceNom : NP -> Str =
      \np -> np.s ! R.Nom ;

    sc_npSurfaceAcc : NP -> Str =
      \np -> np.s ! R.Acc ;

    -- =========================================================
    -- GENITIVE / REL-SLASH BOUNDARY
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
        s = R.link_clitic ! R.Indef ! R.Nom ! cn.g ! num.n
            ++ cn.s ! R.Indef ! R.Ablat ! num.n
      } ;

    sc_GenModNP : Num -> NP -> CN -> NP =
      \_,np,_ -> np ;

    sc_GenModIP : Num -> IP -> CN -> IP =
      \_,ip,_ -> ip ;

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

    -- =========================================================
    -- SMALL UTTERANCE / COMPLEMENT HELPERS
    -- =========================================================

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
      \_,_,vp -> lin Comp {s = vp.s} ;

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
      \v2s,s -> lin VPSlash {s = verbPres3sg v2s ++ wordSep ++ s.s} ;

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
      \vv,_,_,vp -> lin VP {s = verbPres3sg vv ++ wordSep ++ vp.s} ;

    sc_CompoundN : N -> N -> N =
      \n1,_ -> n1 ;

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

    -- =========================================================
    -- MINIMAL COORDINATION GLUE
    -- These stay shallow on purpose. They are here so the coordinator
    -- can wire them if the inherited boundary still proves incomplete.
    -- =========================================================

    sc_BaseComp : Comp -> Comp -> {s : Str} =
      \x,y -> {s = x.s ++ "," ++ wordSep ++ y.s} ;

    sc_ConsComp : Comp -> {s : Str} -> {s : Str} =
      \x,xs -> {s = x.s ++ "," ++ wordSep ++ xs.s} ;

    sc_ConjComp : Conj -> {s : Str} -> Comp =
      \conj,ss -> lin Comp {s = ss.s ++ wordSep ++ conj.s} ;

    sc_BaseImp : Imp -> Imp -> {s : Str} =
      \x,y -> {s = x.s ++ "," ++ wordSep ++ y.s} ;

    sc_ConsImp : Imp -> {s : Str} -> {s : Str} =
      \x,xs -> {s = x.s ++ "," ++ wordSep ++ xs.s} ;

    sc_ConjImp : Conj -> {s : Str} -> Imp =
      \conj,ss -> lin Imp {s = ss.s ++ wordSep ++ conj.s} ;

    -- =========================================================
    -- SHALLOW VPI / VPS BOUNDARY WRAPPERS
    -- Keep these explicit and string-like.
    -- =========================================================

    sc_BaseVPI : {s : Str} -> {s : Str} -> {s : Str} =
      \x,y -> {s = x.s ++ "," ++ wordSep ++ y.s} ;

    sc_ConsVPI : {s : Str} -> {s : Str} -> {s : Str} =
      \x,xs -> {s = x.s ++ "," ++ wordSep ++ xs.s} ;

    sc_MkVPI : VP -> {s : Str} =
      \vp -> {s = vp.s} ;

    sc_ConjVPI : Conj -> {s : Str} -> {s : Str} =
      \conj,xs -> {s = xs.s ++ wordSep ++ conj.s} ;

    sc_ComplVPIVV : VV -> {s : Str} -> VP =
      \vv,vpi -> lin VP {s = verbPres3sg vv ++ wordSep ++ vpi.s} ;

    sc_BaseVPI2 : {s : Str} -> {s : Str} -> {s : Str} =
      \x,y -> {s = x.s ++ "," ++ wordSep ++ y.s} ;

    sc_ConsVPI2 : {s : Str} -> {s : Str} -> {s : Str} =
      \x,xs -> {s = x.s ++ "," ++ wordSep ++ xs.s} ;

    sc_MkVPI2 : VPSlash -> {s : Str} =
      \vpslash -> {s = vpslash.s} ;

    sc_ConjVPI2 : Conj -> {s : Str} -> {s : Str} =
      \conj,xs -> {s = xs.s ++ wordSep ++ conj.s} ;

    sc_ComplVPI2 : {s : Str} -> NP -> {s : Str} =
      \vpi2,np -> {s = vpi2.s ++ wordSep ++ np.s ! R.Acc} ;

    sc_BaseVPS : {s : Str} -> {s : Str} -> {s : Str} =
      \x,y -> {s = x.s ++ "," ++ wordSep ++ y.s} ;

    sc_ConsVPS : {s : Str} -> {s : Str} -> {s : Str} =
      \x,xs -> {s = x.s ++ "," ++ wordSep ++ xs.s} ;

    sc_MkVPS : Temp -> Pol -> VP -> {s : Str} =
      \_,_,vp -> {s = vp.s} ;

    sc_ConjVPS : Conj -> {s : Str} -> {s : Str} =
      \conj,xs -> {s = xs.s ++ wordSep ++ conj.s} ;

    sc_PredVPS : NP -> {s : Str} -> S =
      \np,vps -> lin S {s = sc_npSurfaceNom np ++ wordSep ++ vps.s} ;

    sc_BaseVPS2 : {s : Str} -> {s : Str} -> {s : Str} =
      \x,y -> {s = x.s ++ "," ++ wordSep ++ y.s} ;

    sc_ConsVPS2 : {s : Str} -> {s : Str} -> {s : Str} =
      \x,xs -> {s = x.s ++ "," ++ wordSep ++ xs.s} ;

    sc_MkVPS2 : Temp -> Pol -> VPSlash -> {s : Str} =
      \_,_,vpslash -> {s = vpslash.s} ;

    sc_ConjVPS2 : Conj -> {s : Str} -> {s : Str} =
      \conj,xs -> {s = xs.s ++ wordSep ++ conj.s} ;

    sc_ComplVPS2 : {s : Str} -> NP -> {s : Str} =
      \vps2,np -> {s = vps2.s ++ wordSep ++ sc_npSurfaceAcc np} ;

} ;