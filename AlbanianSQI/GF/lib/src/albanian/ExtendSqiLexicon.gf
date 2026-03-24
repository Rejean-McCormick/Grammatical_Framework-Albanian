-- GF/lib/src/albanian/ExtendSqiLexicon.gf

resource ExtendSqiLexicon =
  open Prelude, Predef, ParamX, CatSqi, ExtendSqiHelpers, (R = ResSqi) in {

  oper
    lex_ReflPossPron : Quant =
      lin Quant {
        s    = \\c,g,n => "vet" ;
        spec = R.Indef
      } ;

    lex_iFem_Pron : Pron =
      mkPronConst "unë" "mua" "mua" "më" "më" R.Fem Sg ;

    lex_youFem_Pron : Pron =
      mkPronConst "ti" "ty" "ty" "të" "të" R.Fem Sg ;

    lex_weFem_Pron : Pron =
      mkPronConst "ne" "ne" "ne" "na" "na" R.Fem Pl ;

    lex_youPlFem_Pron : Pron =
      mkPronConst "ju" "ju" "ju" "ju" "ju" R.Fem Pl ;

    lex_theyFem_Pron : Pron =
      mkPronConst "ato" "ato" "atyre" "" "" R.Fem Pl ;

    lex_theyNeutr_Pron : Pron =
      mkPronConst "ata" "ata" "atyre" "" "" R.Masc Pl ;

    lex_youPolFem_Pron : Pron =
      mkPronConst "ju" "ju" "ju" "ju" "ju" R.Fem Sg ;

    lex_youPolPl_Pron : Pron =
      mkPronConst "ju" "ju" "ju" "ju" "ju" R.Masc Pl ;

    lex_youPolPlFem_Pron : Pron =
      mkPronConst "ju" "ju" "ju" "ju" "ju" R.Fem Pl ;

    lex_UseDAP : DAP -> NP =
      \dap -> mkCompatNPFromStr dap.s R.Masc Sg ;

    lex_UseDAPMasc : DAP -> NP =
      \dap -> mkCompatNPFromStr dap.s R.Masc Sg ;

    lex_UseDAPFem : DAP -> NP =
      \dap -> mkCompatNPFromStr dap.s R.Fem Sg ;

} ;