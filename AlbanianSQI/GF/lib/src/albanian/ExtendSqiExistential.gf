resource ExtendSqiExistential =
  open GrammarSqi, CatSqi, ResSqi, ParamX, (NS = NounSqi) in {

  oper
    ex_ExistS : Temp -> Pol -> NP -> S =
      \temp,pol,np ->
        UseCl temp pol (ExistNP np) ;

    ex_ExistNPQS : Temp -> Pol -> NP -> QS =
      \temp,pol,np ->
        UseQCl temp pol (QuestCl (ExistNP np)) ;

    ex_ExistIPQS : Temp -> Pol -> IP -> QS =
      \temp,pol,ip ->
        UseQCl temp pol (ExistIP ip) ;

    ex_ExistCN : CN -> Cl =
      \cn ->
        ExistNP (DetCN (DetQuant IndefArt NumSg) cn) ;

    ex_ExistMassCN : CN -> Cl =
      \cn ->
        ExistNP (NS.MassNP cn) ;

    ex_ExistPluralCN : CN -> Cl =
      \cn ->
        ExistNP (DetCN (DetQuant IndefArt NumPl) cn) ;

    ex_ExistsNP : NP -> Cl =
      \np ->
        ExistNP np ;

}