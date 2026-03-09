-- FILE: QuestionSqi.gf
concrete QuestionSqi of Question = CatSqi **
  open ResSqi, Prelude in {

  oper
    sp : Str = " " ;

  lincat
    -- QVP is not defined in CatSqi, so we define it here.
    QVP = {s : Str} ;

  lin
    AddAdvQVP qvp iadv =
      {s = qvp.s ++ sp ++ iadv.s} ;

    AdvIAdv iadv adv =
      {s = iadv.s ++ sp ++ adv.s} ;

    -- CatSqi: IP = {s : Str}
    AdvIP ip adv =
      {s = ip.s ++ sp ++ adv.s} ;

    AdvQVP vp iadv =
      {s = vp.s ++ sp ++ iadv.s} ;

    -- CatSqi: IComp = {s : Str}
    CompIAdv iadv =
      {s = iadv.s} ;

    CompIP ip =
      {s = ip.s} ;

    ComplSlashIP vpslash ip =
      {s = vpslash.s ++ sp ++ ip.s} ;

    -- CatSqi: IDet = {s : Str}, IP = {s : Str}, CN is Noun with cn.s : Species => Case => Number => Str
    -- Fallback: pick Indef/Nom/Sg (no case table available in IDet).
    IdetCN idet cn =
      {s = idet.s ++ sp ++ cn.s ! Indef ! Nom ! Sg} ;

    IdetIP idet =
      {s = idet.s} ;

    -- CatSqi: IQuant = {s : Str}
    IdetQuant iquant num =
      {s = iquant.s ++ sp ++ num.s} ;

    PrepIP prep ip =
      {s = prep.s ++ sp ++ ip.s} ;

    QuestCl cl =
      {s = cl.s} ;

    QuestIAdv iadv cl =
      {s = iadv.s ++ sp ++ cl.s} ;

    QuestIComp icomp np =
      {s = icomp.s ++ sp ++ np.s ! Nom} ;

    QuestQVP ip qvp =
      {s = ip.s ++ sp ++ qvp.s} ;

    QuestSlash ip clslash =
      {s = ip.s ++ sp ++ clslash.s} ;

    QuestVP ip vp =
      {s = ip.s ++ sp ++ vp.s} ;

}