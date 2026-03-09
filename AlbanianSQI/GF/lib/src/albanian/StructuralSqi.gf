concrete StructuralSqi of Structural = CatSqi **
  open Prelude, ParamX, ResSqi, (P = ParadigmsSqi) in {

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

  mkSubj : Str -> Subj =
    \x -> lin Subj {s = x} ;

lin
  above_Prep = ResSqi.mkPrep "sipër" ;
  after_Prep = ResSqi.mkPrep "pas" ;
  all_Predet = P.mkPredet "të gjithë" ;
  almost_AdA = {s = "pothuajse"} ;
  almost_AdN = {s = "pothuajse"} ;
  although_Subj = mkSubj "megjithëse" ;
  always_AdV = {s = "gjithmonë"} ;
  and_Conj = P.mkConj "dhe" ;
  because_Subj = mkSubj "sepse" ;
  before_Prep = ResSqi.mkPrep "para" ;
  behind_Prep = ResSqi.mkPrep "pas" ;
  between_Prep = ResSqi.mkPrep "midis" ;

  both7and_DConj = P.mkConj "si edhe" ;

  but_PConj = P.mkPConj "por" ;
  by8agent_Prep = ResSqi.mkPrep "nga" ;
  by8means_Prep = ResSqi.mkPrep "me" ;

  can8know_VV = P.mkVV (P.mkV "di") ;
  can_VV = P.mkVV (P.mkV "mundem") ;

  during_Prep = ResSqi.mkPrep "gjatë" ;

  either7or_DConj = P.mkConj "ose" ;

  every_Det = mkDetInv "çdo" Sg ;
  everybody_NP = mkNPConstP3 "të gjithë" ;
  everything_NP = mkNPConstP3 "gjithçka" ;
  everywhere_Adv = P.mkAdv "kudo" ;

  few_Det = mkDetInv "pak" Pl ;

  for_Prep = ResSqi.mkPrep "për" ;
  from_Prep = ResSqi.mkPrep "nga" ;

  he_Pron = ResSqi.mkPron "ai" "atë" "atij" "atij" "e" "i" (GSg Masc) P3 ;
  here_Adv = P.mkAdv "këtu" ;
  here7to_Adv = P.mkAdv "deri këtu" ;
  here7from_Adv = P.mkAdv "prej këtu" ;

  how_IAdv = P.mkIAdv "si" ;
  how8many_IDet = P.mkIDet "sa" ;
  how8much_IAdv = P.mkIAdv "sa" ;

  i_Pron = ResSqi.mkPron "unë" "mua" "mua" "meje" "më" "më" (GSg Masc) P1 ;

  if_Subj = mkSubj "nëse" ;
  in8front_Prep = ResSqi.mkPrep "përpara" ;
  in_Prep = ResSqi.mkPrep "në" ;

  it_Pron = ResSqi.mkPron "ai" "atë" "atij" "atij" "e" "i" (GSg Masc) P3 ;

  less_CAdv = {s = "më pak" ; p = "se"} ;

  many_Det = mkDetInv "shumë" Pl ;
  more_CAdv = {s = "më" ; p = "se"} ;

  most_Predet = P.mkPredet "shumica" ;
  much_Det = mkDetInv "shumë" Sg ;

  must_VV = P.mkVV (P.mkV "duhet") ;

  no_Phr = {s = "jo"} ;
  no_Utt = {s = "jo"} ;

  on_Prep = ResSqi.mkPrep "mbi" ;

  one_Quant = mkQuantInv "një" ;

  only_Predet = P.mkPredet "vetëm" ;

  or_Conj = P.mkConj "ose" ;
  otherwise_PConj = P.mkPConj "përndryshe" ;

  part_Prep = ResSqi.mkPrep "prej" ;

  please_Voc = P.mkVoc "ju lutem" ;

  possess_Prep = ResSqi.mkPrep "i" ;

  quite_Adv = {s = "mjaft"} ;

  she_Pron = ResSqi.mkPron "ajo" "atë" "asaj" "asaj" "e" "i" (GSg Fem) P3 ;

  so_AdA = {s = "aq"} ;

  someSg_Det = mkDetInv "disa" Sg ;
  somePl_Det = mkDetInv "disa" Pl ;

  somebody_NP = mkNPConstP3 "dikush" ;
  something_NP = mkNPConstP3 "diçka" ;
  somewhere_Adv = P.mkAdv "diku" ;

  that_Quant =
    ResSqi.mkQuant "ai"   "ata"   "ajo"  "ato"
                   "atë"  "ata"   "atë"  "ato"
                   "atij" "atyre" "asaj" "atyre"
                   "atij" "atyre" "asaj" "atyre" ;

  that_Subj = mkSubj "që" ;

  there_Adv = P.mkAdv "atje" ;
  there7to_Adv = P.mkAdv "deri atje" ;
  there7from_Adv = P.mkAdv "prej andej" ;

  therefore_PConj = P.mkPConj "prandaj" ;

  they_Pron = ResSqi.mkPron "ata" "ata" "atyre" "atyre" "i" "u" GPl P3 ;

  this_Quant =
    ResSqi.mkQuant "ky"    "këta"     "kjo"   "këto"
                   "këtë"  "këtyre"   "këtë"  "këtyre"
                   "këtij" "këtyre"   "kësaj" "këtyre"
                   "këtij" "këtyre"   "kësaj" "këtyre" ;

  through_Prep = ResSqi.mkPrep "përmes" ;
  to_Prep = ResSqi.mkPrep "në" ;

  too_AdA = {s = "tepër"} ;

  under_Prep = ResSqi.mkPrep "nën" ;

  very_AdA = {s = "shumë"} ;

  want_VV = P.mkVV (P.mkV "dua") ;

  we_Pron = ResSqi.mkPron "ne" "ne" "neve" "nesh" "na" "na" GPl P1 ;

  whatPl_IP = P.mkIP "çfarë" ;
  whatSg_IP = P.mkIP "çfarë" ;

  when_IAdv = P.mkIAdv "kur" ;
  when_Subj = mkSubj "kur" ;

  where_IAdv = P.mkIAdv "ku" ;

  which_IQuant = P.mkIQuant "cili" ;

  whoPl_IP = P.mkIP "kush" ;
  whoSg_IP = P.mkIP "kush" ;

  why_IAdv = P.mkIAdv "pse" ;

  with_Prep = ResSqi.mkPrep "me" ;
  without_Prep = ResSqi.mkPrep "pa" ;

  yes_Phr = {s = "po"} ;
  yes_Utt = {s = "po"} ;

  youSg_Pron = ResSqi.mkPron "ti" "ty" "ty" "teje" "të" "të" (GSg Masc) P2 ;
  youPl_Pron = ResSqi.mkPron "ju" "ju" "juve" "jush" "ju" "ju" GPl P2 ;
  youPol_Pron = ResSqi.mkPron "ju" "ju" "juve" "jush" "ju" "ju" GPl P2 ;

  no_Quant = mkQuantInv "asnjë" ;
  not_Predet = P.mkPredet "jo" ;

  if_then_Conj = P.mkConj "nëse . atëherë" ;

  at_least_AdN = {s = "të paktën"} ;
  at_most_AdN = {s = "të shumtën"} ;

  nobody_NP = mkNPConstP3 "askush" ;
  nothing_NP = mkNPConstP3 "asgjë" ;

  except_Prep = ResSqi.mkPrep "përveç" ;

  as_CAdv = {s = "po aq" ; p = "sa"} ;

  have_V2 = P.mkV2 (P.mkV "kam") ;

  language_title_Utt = {s = "shqip"} ;

} ;