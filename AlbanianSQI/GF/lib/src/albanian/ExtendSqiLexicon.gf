-- GF/lib/src/albanian/ExtendSqiLexicon.gf

resource ExtendSqiLexicon =
  open Prelude, ParamX, CatSqi, ExtendSqiHelpers, (R = ResSqi) in {

  oper
    -- =========================================================
    -- LEXICAL TAIL
    -- Strategy:
    -- - keep extension-specific lexical entries here
    -- - keep DAP -> NP wrappers lexical and explicitly provisional
    -- - do not move structural repair logic into this module
    --
    -- Note:
    -- In the current Albanian setup, DAP is still too shallow to support
    -- a richer DAP-aware NP realization here, so these wrappers remain
    -- compatibility-based until the category boundary is improved upstream.
    -- =========================================================

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

    -- =========================================================
    -- LEXICAL WRAPPERS
    -- Strategy:
    -- - keep all DAP-to-NP compatibility routing in one helper
    -- - preserve the documented emergency defaults by wrapper
    -- =========================================================

    lex_dapAsNP : R.Gender -> Number -> DAP -> NP =
      \g,n,dap ->
        mkCompatNPFromStr dap.s g n ;

    lex_UseDAP : DAP -> NP =
      \dap -> lex_dapAsNP R.Masc Sg dap ;

    lex_UseDAPMasc : DAP -> NP =
      \dap -> lex_dapAsNP R.Masc Sg dap ;

    lex_UseDAPFem : DAP -> NP =
      \dap -> lex_dapAsNP R.Fem Sg dap ;

} ;