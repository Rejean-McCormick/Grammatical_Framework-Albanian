-- FILE: AdverbSqi.gf
concrete AdverbSqi of Adverb = CatSqi ** open ResSqi, Prelude in {

  oper
    -- Adverbial default from adjective: use basic Nom/Masc/Sg form,
    -- include linking clitic if needed.
    aBase : Adj -> Str = \a ->
      case a.clit of {
        True  => link_clitic ! Indef ! Nom ! Masc ! Sg ++ a.s ! Nom ! Masc ! Sg ;
        False => a.s ! Nom ! Masc ! Sg
      } ;

    thanSep : Str = "se" ;

    npAfterThan : NP -> Str = \np -> np.s ! Nom ;

    -- Do not inspect p.s at runtime.
    -- In this grammar Prep only carries a surface string, so choose
    -- the structural default used after prepositions.
    npAfterPrep : CatSqi.Prep -> NP -> Str = \_,np ->
      np.s ! Acc ;

  lin
    PositAdAAdj a = {s = aBase a} ;
    PositAdvAdj a = {s = aBase a} ;

    AdAdv ada adv = {s = ada.s ++ adv.s} ;
    AdnCAdv cadv  = {s = cadv.s} ;

    ComparAdvAdj cadv a np =
      {s = cadv.s ++ aBase a ++ thanSep ++ npAfterThan np} ;

    ComparAdvAdjS cadv a s =
      {s = cadv.s ++ aBase a ++ thanSep ++ s.s} ;

    PrepNP p np = {s = p.s ++ npAfterPrep p np} ;

    SubjS subj s = {s = subj.s ++ s.s} ;
}