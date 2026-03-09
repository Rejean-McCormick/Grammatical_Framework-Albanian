-- GF/lib/src/albanian/VerbSqi.gf
concrete VerbSqi of Verb = CatSqi **
  open ResSqi, Prelude in {

  oper
    copula   : Str = "është" ;
    reflClit : Str = "u" ;
    sp       : Str = " " ;

    join : Str -> Str -> Str = \x,y -> x ++ sp ++ y ;

    vPred : Verb -> Str = \v ->
      v.Indicative ! Pres ! Sg ! P3 ;

    npNom : NP -> Str = \np -> np.s ! Nom ;
    npAcc : NP -> Str = \np -> np.s ! Acc ;

    apPred : AP -> Str = \ap ->
      ap.s ! Indef ! Nom ! Masc ! Sg ;

    cnPred : CN -> Str = \cn ->
      cn.s ! Indef ! Nom ! Sg ;

  lin
    UseV v =
      {s = vPred v} ;

    UseCopula =
      {s = copula} ;

    UseComp c =
      {s = join copula c.s} ;

    CompNP np =
      {s = npNom np} ;

    CompAP ap =
      {s = apPred ap} ;

    CompCN cn =
      {s = cnPred cn} ;

    CompAdv adv =
      {s = adv.s} ;

    AdvVP vp adv =
      vp ** {s = join vp.s adv.s} ;

    ExtAdvVP vp adv =
      vp ** {s = join adv.s vp.s} ;

    AdVVP adv vp =
      vp ** {s = join adv.s vp.s} ;

    AdvVPSlash vps adv =
      vps ** {s = join vps.s adv.s} ;

    AdVVPSlash adv vps =
      vps ** {s = join adv.s vps.s} ;

    ComplSlash vps np =
      {s = join vps.s (npAcc np)} ;

    ReflVP vps =
      {s = join reflClit vps.s} ;

    PassV2 v2 =
      {s = join reflClit v2.participle} ;

    ComplVV vv vp =
      {s = join (vPred vv) vp.s} ;

    ComplVS vs s =
      {s = join (vPred vs) s.s} ;

    ComplVQ vq qs =
      {s = join (vPred vq) qs.s} ;

    ComplVA va ap =
      {s = join (vPred va) (apPred ap)} ;

    SlashV2a v2 =
      {s = join (vPred v2) v2.c2.s} ;

    SlashV2V v2v vp =
      {s = join (join (vPred v2v) vp.s) v2v.c2.s} ;

    SlashV2S v2s s =
      {s = join (join (vPred v2s) s.s) v2s.c2.s} ;

    SlashV2Q v2q qs =
      {s = join (join (vPred v2q) qs.s) v2q.c2.s} ;

    SlashV2A v2a ap =
      {s = join (join (vPred v2a) (apPred ap)) v2a.c2.s} ;

    Slash2V3 v3 np =
      {s = join (join (join (vPred v3) v3.c2.s) (npAcc np)) v3.c3.s} ;

    Slash3V3 v3 np =
      {s = join (join (join (vPred v3) v3.c3.s) (npAcc np)) v3.c2.s} ;

    SlashVV vv vps =
      {s = join (vPred vv) vps.s} ;

    SlashV2VNP v2v np vps =
      {s = join (join (join (vPred v2v) v2v.c2.s) (npAcc np)) vps.s} ;

    VPSlashPrep vp prep =
      {s = join vp.s prep.s} ;

}