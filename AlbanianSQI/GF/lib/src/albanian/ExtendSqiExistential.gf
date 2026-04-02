resource ExtendSqiExistential =
  open GrammarSqi, CatSqi, ResSqi, ParamX, (NS = NounSqi) in {

  oper
    -- mirrored existential / clause path
    ex_ExistS : Temp -> Pol -> NP -> S =
      \temp, pol, np ->
        UseCl temp pol (ExistNP np) ;

    -- mirrored existential / question path
    ex_ExistNPQS : Temp -> Pol -> NP -> QS =
      \temp, pol, np ->
        UseQCl temp pol (QuestCl (ExistNP np)) ;

    -- mirrored existential / question path
    ex_ExistIPQS : Temp -> Pol -> IP -> QS =
      \temp, pol, ip ->
        UseQCl temp pol (ExistIP ip) ;

    -- count noun existential: indefinite singular NP -> existential clause
    ex_ExistCN : CN -> Cl =
      \cn ->
        ExistNP (DetCN (DetQuant IndefArt NumSg) cn) ;

    -- mass noun existential: MassNP -> existential clause
    ex_ExistMassCN : CN -> Cl =
      \cn ->
        ExistNP (NS.MassNP cn) ;

    -- plural count noun existential: indefinite plural NP -> existential clause
    ex_ExistPluralCN : CN -> Cl =
      \cn ->
        ExistNP (DetCN (DetQuant IndefArt NumPl) cn) ;

    -- explicit NP existential
    ex_ExistsNP : NP -> Cl =
      \np ->
        ExistNP np ;
}