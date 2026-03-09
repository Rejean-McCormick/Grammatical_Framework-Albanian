concrete RelativeSqi of Relative = CatSqi **
  open ResSqi, Prelude in {

  oper
    relPart : Str = "që" ;
    sp : Str = " " ;

  lin
    -- Invariant:
    --   []        = no RP tail
    --   non-empty = already includes its own leading space
    IdRP = {s = []} ;

    FunRP prep np rp =
      {s = sp ++ np.s ! Nom ++ sp ++ prep.s ++ rp.s} ;

    RelCl _ =
      {s = relPart} ;

    RelVP rp _ =
      {s = relPart ++ rp.s} ;

    RelSlash rp _ =
      {s = relPart ++ rp.s} ;
}