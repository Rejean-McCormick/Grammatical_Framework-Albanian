resource ExtendSqiAPCN =
  open Prelude, GrammarSqi, CatSqi, ResSqi, ParamX in {

  oper
    apcn_wordSep : Str = " " ;

    apcn_ICompAP : AP -> IComp =
      \ap -> lin IComp {
        s = ap.s ! Indef ! Nom ! Masc ! Sg
      } ;

    apcn_CompBareCN : CN -> Comp =
      \cn -> CompCN cn ;

    apcn_CompIQuant : IQuant -> IComp =
      \iq -> CompIP (IdetIP (IdetQuant iq NumSg)) ;

    apcn_PredAPVP : AP -> VP -> Cl =
      \ap,vp ->
        ImpersCl
          (UseComp
            (CompAP
              (lin AP {
                s = \\spec,c,g,n =>
                      ap.s ! spec ! c ! g ! n ++
                      apcn_wordSep ++ "që" ++ apcn_wordSep ++
                      (EmbedVP vp).s
              }))) ;

    apcn_AdjAsCN : AP -> CN =
      \ap -> lin CN {
        s = \\spec,c,n => ap.s ! spec ! c ! Masc ! n ;
        g = Masc
      } ;

    apcn_AdjAsNP : AP -> NP =
      \ap -> lin NP {
        s = \\c => ap.s ! Indef ! c ! Masc ! Sg ;
        a = agrgP3 Masc Sg
      } ;

    apcn_CardCNCard : Card -> CN -> Card =
      \card,cn -> lin Card {
        s = card.s ++ apcn_wordSep ++ cn.s ! Indef ! Nom ! Sg
      } ;

}