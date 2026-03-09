--# -path=.:albanian:common:abstract:prelude

resource TrySqi =
  SyntaxSqi-[mkAdN],
  LexiconSqi,
  ParadigmsSqi - [mkAdv,mkAdN,mkQuant,mkVoc]
  ** open (P = ParadigmsSqi) in {

  oper
    mkAdv = overload SyntaxSqi {
      mkAdv : Str -> Adv = P.mkAdv ;
    } ;

    mkAdN = overload {
      mkAdN : CAdv -> AdN = SyntaxSqi.mkAdN ;
      mkAdN : Str  -> AdN = P.mkAdN ;
    } ;

}