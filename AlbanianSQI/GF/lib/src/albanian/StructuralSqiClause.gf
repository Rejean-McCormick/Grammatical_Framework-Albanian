-- GF/lib/src/albanian/StructuralSqiClause.gf
resource StructuralSqiClause =
  open Prelude, ParamX, CatSqi, ResSqi, (P = ParadigmsSqi) in {

oper
  -- Local DConj record type for this resource.
  DConj : Type = {s : Str} ;

  -- Local DConj constructor: keep DConj separate from Conj.
  mkDConj : Str -> DConj = \s -> {s = s} ;

  -- Prepositions
  above_Prep : CatSqi.Prep = ResSqi.mkPrep "sipër" ;
  after_Prep : CatSqi.Prep = ResSqi.mkPrep "pas" ;
  before_Prep : CatSqi.Prep = ResSqi.mkPrep "para" ;
  behind_Prep : CatSqi.Prep = ResSqi.mkPrep "pas" ;
  between_Prep : CatSqi.Prep = ResSqi.mkPrep "midis" ;
  by8agent_Prep : CatSqi.Prep = ResSqi.mkPrep "nga" ;
  by8means_Prep : CatSqi.Prep = ResSqi.mkPrep "me" ;
  during_Prep : CatSqi.Prep = ResSqi.mkPrep "gjatë" ;
  for_Prep : CatSqi.Prep = ResSqi.mkPrep "për" ;
  from_Prep : CatSqi.Prep = ResSqi.mkPrep "nga" ;
  in8front_Prep : CatSqi.Prep = ResSqi.mkPrep "përpara" ;
  in_Prep : CatSqi.Prep = ResSqi.mkPrep "në" ;
  on_Prep : CatSqi.Prep = ResSqi.mkPrep "mbi" ;
  part_Prep : CatSqi.Prep = ResSqi.mkPrep "prej" ;
  possess_Prep : CatSqi.Prep = ResSqi.mkPrep "i" ;
  through_Prep : CatSqi.Prep = ResSqi.mkPrep "përmes" ;
  to_Prep : CatSqi.Prep = ResSqi.mkPrep "në" ;
  under_Prep : CatSqi.Prep = ResSqi.mkPrep "nën" ;
  with_Prep : CatSqi.Prep = ResSqi.mkPrep "me" ;
  without_Prep : CatSqi.Prep = ResSqi.mkPrep "pa" ;
  except_Prep : CatSqi.Prep = ResSqi.mkPrep "përveç" ;

  -- Conjunctions and subordinators
  although_Subj : Subj = P.mkSubj "megjithëse" ;
  and_Conj : Conj = P.mkConj "dhe" ;
  because_Subj : Subj = P.mkSubj "sepse" ;
  both7and_DConj : DConj = mkDConj "si edhe" ;
  but_PConj : PConj = P.mkPConj "por" ;
  either7or_DConj : DConj = mkDConj "ose" ;
  if_Subj : Subj = P.mkSubj "nëse" ;
  if_then_Conj : Conj = P.mkConj "nëse atëherë" ;
  or_Conj : Conj = P.mkConj "ose" ;
  otherwise_PConj : PConj = P.mkPConj "përndryshe" ;
  that_Subj : Subj = P.mkSubj "që" ;
  therefore_PConj : PConj = P.mkPConj "prandaj" ;
  when_Subj : Subj = P.mkSubj "kur" ;

  -- Adverbs and adverbials
  almost_AdA : AdA = P.mkAdA "pothuajse" ;
  almost_AdN : AdN = P.mkAdN "pothuajse" ;
  always_AdV : AdV = P.mkAdV "gjithmonë" ;
  everywhere_Adv : Adv = P.mkAdv "kudo" ;
  here_Adv : Adv = P.mkAdv "këtu" ;
  here7to_Adv : Adv = P.mkAdv "deri këtu" ;
  here7from_Adv : Adv = P.mkAdv "prej këtu" ;
  how_IAdv : IAdv = P.mkIAdv "si" ;
  how8much_IAdv : IAdv = P.mkIAdv "sa" ;
  quite_Adv : AdA = P.mkAdA "mjaft" ;
  so_AdA : AdA = P.mkAdA "aq" ;
  somewhere_Adv : Adv = P.mkAdv "diku" ;
  there_Adv : Adv = P.mkAdv "atje" ;
  there7to_Adv : Adv = P.mkAdv "deri atje" ;
  there7from_Adv : Adv = P.mkAdv "prej andej" ;
  too_AdA : AdA = P.mkAdA "tepër" ;
  very_AdA : AdA = P.mkAdA "shumë" ;
  when_IAdv : IAdv = P.mkIAdv "kur" ;
  where_IAdv : IAdv = P.mkIAdv "ku" ;
  why_IAdv : IAdv = P.mkIAdv "pse" ;
  at_least_AdN : AdN = P.mkAdN "të paktën" ;
  at_most_AdN : AdN = P.mkAdN "të shumtën" ;

  -- Comparative adverbs
  less_CAdv : CAdv = lin CAdv {s = "më pak" ; p = "se"} ;
  more_CAdv : CAdv = lin CAdv {s = "më" ; p = "se"} ;
  as_CAdv : CAdv = lin CAdv {s = "po aq" ; p = "sa"} ;

  -- Utterances and vocatives
  no_Utt : Utt = lin Utt {s = "jo"} ;
  yes_Utt : Utt = lin Utt {s = "po"} ;
  please_Voc : Voc = P.mkVoc "ju lutem" ;
  language_title_Utt : Utt = lin Utt {s = "shqip"} ;

} ;