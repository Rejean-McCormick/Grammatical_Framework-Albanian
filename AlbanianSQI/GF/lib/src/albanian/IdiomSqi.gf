-- GF/lib/src/albanian/IdiomSqi.gf
concrete IdiomSqi of Idiom = CatSqi ** open ResSqi, Prelude in {

  oper
    -- =========================================================
    -- IDIOM SUBSYSTEM
    -- Strategy:
    -- - keep established Albanian idioms shallow and explicit
    -- - do not pretend draft paths preserve richer structure than they do
    -- - preserve full records with ** only when the target category remains
    --   the same and only the surface string is being adjusted
    -- =========================================================

    copBe    : Str = "është" ;
    relThat  : Str = "që" ;
    existV   : Str = "ka" ;
    progPart : Str = "po" ;
    letPart  : Str = "le" ++ "të" ;
    selfWord : Str = "vetë" ;

    idiomNpNom : NP -> Str =
      \np -> np.s ! Nom ;

  lin
    -- it is here she slept
    CleftAdv adv s =
      {s = copBe ++ adv.s ++ relThat ++ s.s} ;

    -- it is NP who/that ...
    CleftNP np rs =
      {s = copBe ++ idiomNpNom np ++ relThat ++ rs.s} ;

    -- which X are there
    ExistIP ip =
      {s = ip.s ++ existV} ;

    ExistIPAdv ip adv =
      {s = ip.s ++ adv.s ++ existV} ;

    -- there is NP
    ExistNP np =
      {s = existV ++ idiomNpNom np} ;

    ExistNPAdv np adv =
      {s = existV ++ idiomNpNom np ++ adv.s} ;

    -- TEMPORARY / DRAFT:
    -- no explicit Albanian generic-subject strategy has been surfaced here.
    -- Keep this shallow rather than manufacturing a fake expletive/pronoun path.
    GenericCl vp =
      {s = vp.s} ;

    -- TEMPORARY / DRAFT:
    -- likewise, no explicit impersonal/expletive path is currently established.
    ImpersCl vp =
      {s = vp.s} ;

    -- let NP VP
    ImpP3 np vp =
      {s = letPart ++ idiomNpNom np ++ vp.s} ;

    -- let's VP
    ImpPl1 vp =
      {s = letPart ++ vp.s} ;

    -- TEMPORARY / DRAFT:
    -- progressive marking is currently realized with shallow "po" prefixing.
    -- Preserve the VP record, but only adjust its surface string.
    ProgrVP vp =
      vp ** {s = progPart ++ vp.s} ;

    -- TEMPORARY / DRAFT:
    -- reflexive/emphatic self path remains a shallow suffix strategy.
    -- Preserve the VP record, but only adjust its surface string.
    SelfAdVVP vp =
      vp ** {s = vp.s ++ selfWord} ;

    -- Shallow Adv-like realization.
    SelfAdvVP vp =
      {s = vp.s ++ selfWord} ;

    -- NP itself
    SelfNP np =
      {s = \\c => np.s ! c ++ selfWord ;
       a = np.a} ;

} ;