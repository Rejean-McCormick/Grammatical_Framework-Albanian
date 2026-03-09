--# -path=.:./abstract:./albanian

resource SyntaxSqi = open Prelude, Predef,
  CatSqi, ResSqi,
  NounSqi, AdjectiveSqi, PhraseSqi, StructuralSqi
in {

oper
  mkCN : N -> CN = UseN ;
  mkCN : AP -> CN -> CN = AdjCN ;
  mkCN : A -> CN -> CN = \a,cn -> AdjCN (PositA a) cn ;
  mkCN : A -> N -> CN  = \a,n  -> mkCN a (mkCN n) ;

  mkAP : A -> AP = PositA ;

  mkDet : Quant -> Num -> Det = DetQuant ;

  mkNP : Det -> CN -> NP = DetCN ;
  mkNP : Det -> N  -> NP = \det,n -> DetCN det (UseN n) ;

  mkNP : Pron -> NP = UsePron ;

  mkNP : Quant -> CN -> NP = \q,cn -> DetCN (DetQuant q NumSg) cn ;
  mkNP : Quant -> N  -> NP = \q,n  -> mkNP q (mkCN n) ;
  mkNP : Quant -> Num -> CN -> NP = \q,num,cn -> DetCN (DetQuant q num) cn ;

  the_Det   : Det = DetQuant DefArt   NumSg ;
  a_Det     : Det = DetQuant IndefArt NumSg ;

  this_Det  : Det = DetQuant this_Quant NumSg ;
  these_Det : Det = DetQuant this_Quant NumPl ;
  that_Det  : Det = DetQuant that_Quant NumSg ;
  those_Det : Det = DetQuant that_Quant NumPl ;

  mkUtt : S -> Utt = UttS ;
  mkUtt : NP -> Utt = UttNP ;
  mkUtt : Interj -> Utt = UttInterj ;

  mkPhr : Utt -> Phr = \utt -> PhrUtt NoPConj utt NoVoc ;
  mkPhr : PConj -> Utt -> Voc -> Phr = PhrUtt ;

}