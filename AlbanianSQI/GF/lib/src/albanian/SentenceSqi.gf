-- FILE: SentenceSqi.gf
concrete SentenceSqi of Sentence = CatSqi ** open ResSqi, Prelude, Predef in {

  oper
    sp : Str = " " ;

  lin
    PredVP np vp     = {s = np.s ! Nom ++ sp ++ vp.s} ;
    PredSCVP sc vp   = {s = sc.s ++ sp ++ vp.s} ;

    ImpVP vp         = {s = vp.s} ;

    AdvS adv s       = {s = adv.s ++ sp ++ s.s} ;
    ExtAdvS adv s    = {s = adv.s ++ sp ++ s.s} ;

    RelS s rs        = {s = s.s ++ sp ++ rs.s} ;

    SlashPrep cl prep = {s = cl.s ++ sp ++ prep.s} ;
    SlashVP np vpslash = {s = np.s ! Nom ++ sp ++ vpslash.s} ;

    AdvSlash clslash adv = {s = clslash.s ++ sp ++ adv.s} ;

    EmbedS s         = {s = s.s} ;
    EmbedQS qs       = {s = qs.s} ;
    EmbedVP vp       = {s = vp.s} ;

    UseCl  temp pol cl      = {s = cl.s} ;
    UseQCl temp pol qcl     = {s = qcl.s} ;
    UseRCl temp pol rcl     = {s = rcl.s} ;
    UseSlash temp pol clsl  = {s = clsl.s} ;

    -- GF 3.12: SlashVS has 3 arguments (NP, VS, SSlash) in Sentence.gf
    SlashVS np vs sslash = {s = np.s ! Nom ++ sp ++ sslash.s} ;

    AdvImp adv imp              = {s = adv.s ++ sp ++ imp.s} ;
    SSubjS s subj s2            = {s = s.s ++ sp ++ subj.s ++ sp ++ s2.s} ;

}