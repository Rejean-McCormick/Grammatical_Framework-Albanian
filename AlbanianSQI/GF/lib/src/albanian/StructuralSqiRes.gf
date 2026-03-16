-- GF/lib/src/albanian/StructuralSqiRes.gf
resource StructuralSqiRes =
  open Prelude, ParamX, ResSqi, CatSqi in {

oper
  mkNPConst : Str -> GenNum -> Person -> CatSqi.NP =
    \x,gn,p -> lin NP {
      s = table {
        Nom   => x ;
        Acc   => x ;
        Dat   => x ;
        Ablat => x
      } ;
      a = {gn = gn ; p = p}
    } ;

  mkNPConstP3 : Str -> CatSqi.NP =
    \x -> mkNPConst x (GSg Masc) P3 ;

  mkDetInv : Str -> Number -> CatSqi.Det =
    \x,n -> lin Det {
      s = table {
        Nom   => table {Masc => x ; Fem => x} ;
        Acc   => table {Masc => x ; Fem => x} ;
        Dat   => table {Masc => x ; Fem => x} ;
        Ablat => table {Masc => x ; Fem => x}
      } ;
      spec = Indef ;
      n = n
    } ;

  mkQuantInv : Str -> CatSqi.Quant =
    \x -> lin Quant {
      s = table {
        Nom => table {
          Masc => table {Sg => x ; Pl => x} ;
          Fem  => table {Sg => x ; Pl => x}
        } ;
        Acc => table {
          Masc => table {Sg => x ; Pl => x} ;
          Fem  => table {Sg => x ; Pl => x}
        } ;
        Dat => table {
          Masc => table {Sg => x ; Pl => x} ;
          Fem  => table {Sg => x ; Pl => x}
        } ;
        Ablat => table {
          Masc => table {Sg => x ; Pl => x} ;
          Fem  => table {Sg => x ; Pl => x}
        }
      } ;
      spec = Indef
    } ;

} ;