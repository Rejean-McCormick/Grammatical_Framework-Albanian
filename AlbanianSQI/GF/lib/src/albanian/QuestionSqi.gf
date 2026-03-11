-- FILE: QuestionSqi.gf
concrete QuestionSqi of Question = CatSqi **
  open ResSqi, Prelude in {

  oper
    sep : Str = " " ;

  lincat
    -- QVP is not defined in CatSqi, so we define it here.
    QVP = {s : Str} ;

  lin
    AddAdvQVP qvp iadv =
      {s = qvp.s ++ sep ++ iadv.s} ;

    AdvIAdv iadv adv =
      {s = iadv.s ++ sep ++ adv.s} ;

    -- CatSqi: IP = {s : Str}
    AdvIP ip adv =
      {s = ip.s ++ sep ++ adv.s} ;

    AdvQVP vp iadv =
      {s = vp.s ++ sep ++ iadv.s} ;

    -- CatSqi: IComp = {s : Str}
    CompIAdv iadv =
      {s = iadv.s} ;

    CompIP ip =
      {s = ip.s} ;

    ComplSlashIP vpslash ip =
      {s = vpslash.s ++ sep ++ ip.s} ;

    -- CatSqi: IDet = {s : Str}, IP = {s : Str}, CN is Noun with
    -- cn.s : Species => Case => Number => Str
    -- Fallback: pick Indef/Nom/Sg.
    IdetCN idet cn =
      {s = idet.s ++ sep ++ cn.s ! Indef ! Nom ! Sg} ;

    IdetIP idet =
      {s = idet.s} ;

    -- CatSqi: IQuant = {s : Str}
    IdetQuant iquant num =
      {s = iquant.s ++ sep ++ num.s} ;

    PrepIP prep ip =
      {s = prep.s ++ sep ++ ip.s} ;

    QuestCl cl =
      {s = cl.s} ;

    QuestIAdv iadv cl =
      {s = iadv.s ++ sep ++ cl.s} ;

    QuestIComp icomp np =
      {s = icomp.s ++ sep ++ np.s ! Nom} ;

    QuestQVP ip qvp =
      {s = ip.s ++ sep ++ qvp.s} ;

    QuestSlash ip clslash =
      {s = ip.s ++ sep ++ clslash.s} ;

    QuestVP ip vp =
      {s = ip.s ++ sep ++ vp.s} ;

} 