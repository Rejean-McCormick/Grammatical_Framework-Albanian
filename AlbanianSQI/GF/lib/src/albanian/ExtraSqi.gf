concrete ExtraSqi of ExtraSqiAbs = CatSqi ** open Prelude, ResSqi in {

  lincat
    VPI   = {s : Str} ;
    [VPI] = {s : Str} ;

    VPS   = {s : Str} ;
    [VPS] = {s : Str} ;

    Foc   = {s : Str} ;

  oper
    npAfterPrep : NP -> Str = \np -> np.s ! Acc ;

    apBase : AP -> Str =
      \ap -> ap.s ! Indef ! Nom ! Masc ! Sg ;

    cnBare : CN -> Str =
      \cn -> cn.s ! Indef ! Acc ! Sg ;

    v3sgPres : Verb -> Str =
      \v -> v.Indicative ! Pres ! Sg ! P3 ;

  lin
    GenNP np = {
      s = \\c,g,n => link_clitic ! Indef ! c ! g ! n ++ np.s ! Ablat ;
      spec = Indef
    } ;

    GenIP ip = {s = "i" ++ ip.s} ;

    GenRP num cn = {
      s = link_clitic ! Indef ! Nom ! cn.g ! num.n ++ cn.s ! Indef ! Ablat ! num.n
    } ;

    ComplBareVS vs s = {s = v3sgPres vs ++ s.s} ;

    StrandRelSlash rp slash = {s = rp.s ++ slash.s} ;
    EmptyRelSlash slash = {s = slash.s} ;
    StrandQuestSlash ip slash = {s = ip.s ++ slash.s} ;

    BaseVPI x y = {s = x.s ++ "," ++ y.s} ;
    ConsVPI x xs = {s = x.s ++ "," ++ xs.s} ;
    MkVPI vp = {s = vp.s} ;
    ConjVPI conj xs = {s = xs.s ++ conj.s} ;
    ComplVPIVV vv vpi = {s = v3sgPres vv ++ vpi.s} ;

    BaseVPS x y = {s = x.s ++ "," ++ y.s} ;
    ConsVPS x xs = {s = x.s ++ "," ++ xs.s} ;
    MkVPS t p vp = {s = vp.s} ;
    ConjVPS conj xs = {s = xs.s ++ conj.s} ;
    PredVPS np vps = {s = np.s ! Nom ++ vps.s} ;

    ICompAP ap = {s = apBase ap} ;
    IAdvAdv adv = {s = adv.s} ;
    CompIQuant iq = {s = iq.s} ;
    PrepCN prep cn = {s = prep.s ++ cnBare cn} ;

    FocObj np slash = {s = np.s ! Acc ++ slash.s} ;
    FocAdv adv cl = {s = adv.s ++ cl.s} ;
    FocAdV adv cl = {s = adv.s ++ cl.s} ;
    FocAP ap np = {s = apBase ap ++ np.s ! Nom} ;
    FocNeg cl = {s = "nuk" ++ cl.s} ;
    FocVP vp np = {s = vp.s ++ np.s ! Nom} ;
    FocVV vv vp np = {s = v3sgPres vv ++ vp.s ++ np.s ! Nom} ;
    UseFoc t p foc = {s = foc.s} ;

    -- IMPORTANT FIX:
    -- In abstract Extra, PartVP produces an AP (participial adjective),
    -- so returning vp directly fails (VP.s : Str vs AP.s : table).
    PartVP vp = {
      s = \\sp,c,g,n => vp.s
    } ;

    EmbedPresPart vp = {s = vp.s} ;

    PassVPSlash vpslash = vpslash ;
}