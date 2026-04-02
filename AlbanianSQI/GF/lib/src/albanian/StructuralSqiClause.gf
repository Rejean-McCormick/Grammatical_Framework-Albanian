-- GF/lib/src/albanian/StructuralSqiClause.gf
resource StructuralSqiClause =
  open Prelude, ParamX, CatSqi, (R = ResSqi), (P = ParadigmsSqi) in {

oper
  -- =========================================================
  -- CLAUSE / DISCOURSE STRUCTURAL VOCABULARY
  -- Strategy: keep clause-level closed-class items here.
  -- Use paradigm constructors where they exist.
  -- Use mkPrep for prepositions; use direct record construction only
  -- for genuinely surface-only local categories such as DConj, CAdv, Utt.
  -- =========================================================

  mkDConj : Str -> DConj = \s -> lin DConj {s = s} ;

  -- Prepositions
  above_Prep : Prep = R.mkPrep "sipër" ;
  after_Prep : Prep = R.mkPrep "pas" ;
  before_Prep : Prep = R.mkPrep "para" ;
  behind_Prep : Prep = R.mkPrep "pas" ;
  between_Prep : Prep = R.mkPrep "midis" ;
  by8agent_Prep : Prep = R.mkPrep "nga" ;
  by8means_Prep : Prep = R.mkPrep "me" ;
  during_Prep : Prep = R.mkPrep "gjatë" ;
  for_Prep : Prep = R.mkPrep "për" ;
  from_Prep : Prep = R.mkPrep "nga" ;
  in8front_Prep : Prep = R.mkPrep "përpara" ;
  in_Prep : Prep = R.mkPrep "në" ;
  on_Prep : Prep = R.mkPrep "mbi" ;
  part_Prep : Prep = R.mkPrep "prej" ;
  possess_Prep : Prep = R.mkPrep "i" ;
  through_Prep : Prep = R.mkPrep "përmes" ;
  to_Prep : Prep = R.mkPrep "në" ;
  under_Prep : Prep = R.mkPrep "nën" ;
  with_Prep : Prep = R.mkPrep "me" ;
  without_Prep : Prep = R.mkPrep "pa" ;
  except_Prep : Prep = R.mkPrep "përveç" ;

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