-- GF/lib/src/albanian/StructuralSqi.gf
concrete StructuralSqi of Structural = CatSqi **
  open (SN = StructuralSqiNominal),
       (SV = StructuralSqiVerbal),
       (SC = StructuralSqiClause) in {

flags optimize = all ;

lin
  -- =========================================================
  -- STRUCTURAL AGGREGATOR
  -- Strategy: pure re-export join point over nominal, verbal,
  -- and clause structural subresources.
  -- Keep ownership in the submodules; do not add local repair logic here.
  -- =========================================================

  -- Prepositions
  above_Prep = SC.above_Prep ;
  after_Prep = SC.after_Prep ;
  before_Prep = SC.before_Prep ;
  behind_Prep = SC.behind_Prep ;
  between_Prep = SC.between_Prep ;
  by8agent_Prep = SC.by8agent_Prep ;
  by8means_Prep = SC.by8means_Prep ;
  during_Prep = SC.during_Prep ;
  for_Prep = SC.for_Prep ;
  from_Prep = SC.from_Prep ;
  in8front_Prep = SC.in8front_Prep ;
  in_Prep = SC.in_Prep ;
  on_Prep = SC.on_Prep ;
  part_Prep = SC.part_Prep ;
  possess_Prep = SC.possess_Prep ;
  through_Prep = SC.through_Prep ;
  to_Prep = SC.to_Prep ;
  under_Prep = SC.under_Prep ;
  with_Prep = SC.with_Prep ;
  without_Prep = SC.without_Prep ;
  except_Prep = SC.except_Prep ;

  -- Conjunctions and subordinators
  although_Subj = SC.although_Subj ;
  and_Conj = SC.and_Conj ;
  because_Subj = SC.because_Subj ;
  both7and_DConj = SC.both7and_DConj ;
  but_PConj = SC.but_PConj ;
  either7or_DConj = SC.either7or_DConj ;
  if_Subj = SC.if_Subj ;
  if_then_Conj = SC.if_then_Conj ;
  or_Conj = SC.or_Conj ;
  otherwise_PConj = SC.otherwise_PConj ;
  that_Subj = SC.that_Subj ;
  therefore_PConj = SC.therefore_PConj ;
  when_Subj = SC.when_Subj ;

  -- Adverbs and adverbials
  almost_AdA = SC.almost_AdA ;
  almost_AdN = SC.almost_AdN ;
  always_AdV = SC.always_AdV ;
  everywhere_Adv = SC.everywhere_Adv ;
  here_Adv = SC.here_Adv ;
  here7to_Adv = SC.here7to_Adv ;
  here7from_Adv = SC.here7from_Adv ;
  how_IAdv = SC.how_IAdv ;
  how8much_IAdv = SC.how8much_IAdv ;
  quite_Adv = SC.quite_Adv ;
  so_AdA = SC.so_AdA ;
  somewhere_Adv = SC.somewhere_Adv ;
  there_Adv = SC.there_Adv ;
  there7to_Adv = SC.there7to_Adv ;
  there7from_Adv = SC.there7from_Adv ;
  too_AdA = SC.too_AdA ;
  very_AdA = SC.very_AdA ;
  when_IAdv = SC.when_IAdv ;
  where_IAdv = SC.where_IAdv ;
  why_IAdv = SC.why_IAdv ;
  at_least_AdN = SC.at_least_AdN ;
  at_most_AdN = SC.at_most_AdN ;

  -- Comparative adverbs
  less_CAdv = SC.less_CAdv ;
  more_CAdv = SC.more_CAdv ;
  as_CAdv = SC.as_CAdv ;

  -- Utterances and vocatives
  no_Utt = SC.no_Utt ;
  yes_Utt = SC.yes_Utt ;
  please_Voc = SC.please_Voc ;
  language_title_Utt = SC.language_title_Utt ;

  -- Determiners, quantifiers, predeterminers
  all_Predet = SN.all_Predet ;
  every_Det = SN.every_Det ;
  few_Det = SN.few_Det ;
  how8many_IDet = SN.how8many_IDet ;
  many_Det = SN.many_Det ;
  most_Predet = SN.most_Predet ;
  much_Det = SN.much_Det ;
  only_Predet = SN.only_Predet ;
  someSg_Det = SN.someSg_Det ;
  somePl_Det = SN.somePl_Det ;
  that_Quant = SN.that_Quant ;
  this_Quant = SN.this_Quant ;
  which_IQuant = SN.which_IQuant ;
  no_Quant = SN.no_Quant ;
  not_Predet = SN.not_Predet ;

  -- Pronouns and noun phrases
  everybody_NP = SN.everybody_NP ;
  everything_NP = SN.everything_NP ;
  he_Pron = SN.he_Pron ;
  i_Pron = SN.i_Pron ;
  it_Pron = SN.it_Pron ;
  she_Pron = SN.she_Pron ;
  somebody_NP = SN.somebody_NP ;
  something_NP = SN.something_NP ;
  they_Pron = SN.they_Pron ;
  we_Pron = SN.we_Pron ;
  whatPl_IP = SN.whatPl_IP ;
  whatSg_IP = SN.whatSg_IP ;
  whoPl_IP = SN.whoPl_IP ;
  whoSg_IP = SN.whoSg_IP ;
  youSg_Pron = SN.youSg_Pron ;
  youPl_Pron = SN.youPl_Pron ;
  youPol_Pron = SN.youPol_Pron ;
  nobody_NP = SN.nobody_NP ;
  nothing_NP = SN.nothing_NP ;

  -- Verbal items
  can8know_VV = SV.can8know_VV ;
  can_VV = SV.can_VV ;
  want_VV = SV.want_VV ;
  have_V2 = SV.have_V2 ;

  -- Keep disabled until the crash source is isolated in the verbal helper.
  -- must_VV = SV.must_VV ;

} ;