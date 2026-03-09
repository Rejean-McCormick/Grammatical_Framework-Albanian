-- GF/lib/src/albanian/IdiomSqi.gf
concrete IdiomSqi of Idiom = CatSqi ** open ResSqi, Prelude in {

  oper
    copBe : Str = "është" ;
    relThat : Str = "që" ;
    existV : Str = "ka" ;
    progPart : Str = "po" ;
    letPart : Str = "le" ++ "të" ;
    selfWord : Str = "vetë" ;

    npNom : NP -> Str = \np -> np.s ! Nom ;

  lin
    -- it is here she slept
    CleftAdv adv s =
      {s = copBe ++ adv.s ++ relThat ++ s.s} ;

    -- it is NP who/that ...
    CleftNP np rs =
      {s = copBe ++ npNom np ++ relThat ++ rs.s} ;

    -- which X are there
    ExistIP ip =
      {s = ip.s ++ existV} ;

    ExistIPAdv ip adv =
      {s = ip.s ++ adv.s ++ existV} ;

    -- there is NP
    ExistNP np =
      {s = existV ++ npNom np} ;

    ExistNPAdv np adv =
      {s = existV ++ npNom np ++ adv.s} ;

    -- one sleeps (draft: no explicit subject)
    GenericCl vp =
      {s = vp.s} ;

    -- it is hot (draft: no explicit expletive)
    ImpersCl vp =
      {s = vp.s} ;

    -- let NP VP
    ImpP3 np vp =
      {s = letPart ++ npNom np ++ vp.s} ;

    -- let's VP
    ImpPl1 vp =
      {s = letPart ++ vp.s} ;

    -- progressive VP (draft marker "po")
    ProgrVP vp =
      vp ** {s = progPart ++ vp.s} ;

    -- VP ... himself/herself (draft: suffix)
    SelfAdVVP vp =
      vp ** {s = vp.s ++ selfWord} ;

    SelfAdvVP vp =
      vp ** {s = vp.s ++ selfWord} ;

    -- NP itself
    SelfNP np =
      {s = \\c => np.s ! c ++ selfWord ;
       a = np.a} ;

}