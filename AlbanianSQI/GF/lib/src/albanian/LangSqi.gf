--# -path=.:../abstract:../common:../prelude:../api

concrete LangSqi of Lang =
  GrammarSqi,
  LexiconSqi
  ** {

flags
  startcat = Phr ;

} ;