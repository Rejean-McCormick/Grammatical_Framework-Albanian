-- GF/lib/src/albanian/SymbolSqi.gf
concrete SymbolSqi of Symbol = CatSqi
  ** open Prelude, Predef, ParamX, ResSqi, ParadigmsSqi in {

  lincat
    Symb, [Symb] = SS ;

  oper
    agr3 : Number -> Gender -> Agr = \n,g ->
      { gn = case n of {Sg => GSg g ; Pl => GPl} ; p = P3 } ;

    mkNP_NumCN : Str -> Number -> Gender -> (Case => Str) -> CatSqi.NP =
      \numStr,n,g,cnCase ->
        lin NP {
          s = \\c => numStr ++ cnCase ! c ;
          a = agr3 n g
        } ;

    cnCaseIndef : CatSqi.CN -> Number -> (Case => Str) = \cn,n ->
      table {
        Nom   => cn.s ! Indef ! Nom   ! n ;
        Acc   => cn.s ! Indef ! Acc   ! n ;
        Dat   => cn.s ! Indef ! Dat   ! n ;
        Ablat => cn.s ! Indef ! Ablat ! n
      } ;

    cnCaseWithDet : CatSqi.Det -> CatSqi.CN -> (Case => Str) = \det,cn ->
      table {
        Nom   => det.s ! Nom   ! cn.g ++ cn.s ! det.spec ! Nom   ! det.n ;
        Acc   => det.s ! Acc   ! cn.g ++ cn.s ! det.spec ! Acc   ! det.n ;
        Dat   => det.s ! Dat   ! cn.g ++ cn.s ! det.spec ! Dat   ! det.n ;
        Ablat => det.s ! Ablat ! cn.g ++ cn.s ! det.spec ! Ablat ! det.n
      } ;

  lin
    MkSymb s = s ;

    BaseSymb = infixSS "dhe" ;
    ConsSymb = infixSS "," ;

    SymbPN symb = mkPN symb.s ;

    IntPN i = mkPN i.s ;
    FloatPN f = mkPN f.s ;
    NumPN c = mkPN c.s ;

    SymbNum symb = mkCard symb.s ;

    SymbOrd symb =
      lin Ord {s = symb.s} ;

    SymbS symb = symb ;

    CNIntNP cn i =
      let
        n : CatSqi.CN = lin CN cn ;
      in
      mkNP_NumCN i.s Pl n.g (cnCaseIndef n Pl) ;

    CNNumNP cn c =
      let
        n : CatSqi.CN = lin CN cn ;
      in
      mkNP_NumCN c.s Pl n.g (cnCaseIndef n Pl) ;

    CNSymbNP det cn syms =
      let
        d : CatSqi.Det = lin Det det ;
        n : CatSqi.CN  = lin CN cn ;
      in
      lin NP {
        s = \\c => cnCaseWithDet d n ! c ++ syms.s ;
        a = agr3 d.n n.g
      } ;

} ;