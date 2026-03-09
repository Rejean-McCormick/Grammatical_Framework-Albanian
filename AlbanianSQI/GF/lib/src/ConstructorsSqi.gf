--# -path=.:albanian:common:abstract:prelude

resource ConstructorsSqi =
  SyntaxSqi - [
    i_Pron, youSg_Pron, he_Pron, she_Pron, it_Pron,
    we_Pron, youPl_Pron, they_Pron,
    this_Quant, that_Quant
  ]
  ** open Prelude in {

}