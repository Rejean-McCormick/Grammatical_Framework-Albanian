-- GF/lib/src/albanian/AdjectiveSqi.gf

concrete AdjectiveSqi of Adjective = CatSqi **
  open ResSqi, Prelude, Predef in {

  lin

    PositA a = {
      s = \\spec,c,g,n =>
            case a.clit of {
              True  => link_clitic ! spec ! c ! g ! n ++ a.s ! c ! g ! n ;
              False => a.s ! c ! g ! n
            }
    } ;

    UseComparA a = PositA a ;

    ComparA a np = {
      s = \\spec,c,g,n =>
            "më" ++
            (case a.clit of {
               True  => link_clitic ! spec ! c ! g ! n ++ a.s ! c ! g ! n ;
               False => a.s ! c ! g ! n
             }) ++
            "se" ++ np.s ! Nom
    } ;

    UseA2 a2 = PositA a2 ;

    ComplA2 a2 np = {
      s = \\spec,c,g,n =>
            (UseA2 a2).s ! spec ! c ! g ! n ++ a2.c2.s ++ np.s ! Acc
    } ;

    ReflA2 a2 = UseA2 a2 ;

    -- Ad-adjective modifier (e.g. "shumë i mirë"): just concatenate.
    AdAP ada ap = {
      s = \\spec,c,g,n => ada.s ++ ap.s ! spec ! c ! g ! n
    } ;

    -- AP modified by an adverb/adv phrase: fallback = AP + Adv.
    AdvAP ap adv = {
      s = \\spec,c,g,n => ap.s ! spec ! c ! g ! n ++ adv.s
    } ;

    -- Comparative adverb pattern: cadv.s ... cadv.p NP
    -- (e.g. "aq i madh sa NP")
    CAdvAP cadv ap np = {
      s = \\spec,c,g,n =>
            cadv.s ++ ap.s ! spec ! c ! g ! n ++ cadv.p ++ np.s ! Nom
    } ;

    -- Ordinal used as adjective phrase (invariant fallback).
    AdjOrd ord = {
      s = \\_,_,_,_ => ord.s
    } ;

    -- Sentence complement AP + "që" + SC (fallback).
    SentAP ap sc = {
      s = \\spec,c,g,n => ap.s ! spec ! c ! g ! n ++ "që" ++ sc.s
    } ;

}