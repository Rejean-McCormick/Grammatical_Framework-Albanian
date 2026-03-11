-- FILE: SentenceSqi.gf
concrete SentenceSqi of Sentence = CatSqi ** open ResSqi, Prelude in {

  oper
    sep : Str = " " ;

  lin
    PredVP np vp       = {s = np.s ! Nom ++ sep ++ vp.s} ;
    PredSCVP sc vp     = {s = sc.s ++ sep ++ vp.s} ;

    ImpVP vp           = {s = vp.s} ;

    AdvS adv s         = {s = adv.s ++ sep ++ s.s} ;
    ExtAdvS adv s      = {s = adv.s ++ sep ++ s.s} ;

    RelS s rs          = {s = s.s ++ sep ++ rs.s} ;

    SlashPrep cl prep  = {s = cl.s ++ sep ++ prep.s} ;
    SlashVP np vpslash = {s = np.s ! Nom ++ sep ++ vpslash.s} ;

    AdvSlash clslash adv = {s = clslash.s ++ sep ++ adv.s} ;

    EmbedS s           = {s = s.s} ;
    EmbedQS qs         = {s = qs.s} ;
    EmbedVP vp         = {s = vp.s} ;

    UseCl temp pol cl     = {s = cl.s} ;
    UseQCl temp pol qcl   = {s = qcl.s} ;
    UseRCl temp pol rcl   = {s = rcl.s} ;
    UseSlash temp pol clsl = {s = clsl.s} ;

    SlashVS np vs sslash = {s = np.s ! Nom ++ sep ++ sslash.s} ;

    AdvImp adv imp        = {s = adv.s ++ sep ++ imp.s} ;
    SSubjS s subj s2      = {s = s.s ++ sep ++ subj.s ++ sep ++ s2.s} ;

}