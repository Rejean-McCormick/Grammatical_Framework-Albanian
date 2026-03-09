-- FILE: ConstructionSqi.gf
concrete ConstructionSqi of Construction = CatSqi **
  open ResSqi, Prelude, Predef, ParamX in {

  oper
    -- GF 3.12: Int is a built-in type; convert via Predef.show when needed.
    showIntStr : Int -> Str = \i -> Predef.show Predef.Int i ;

    -- Constant noun (same surface form everywhere), with a gender
    mkNConst : Gender -> Str -> Noun = \g,w ->
      mkNoun w w w w w w w w w w w w w w w w g ;

    -- Constant NP (same surface form in all cases)
    -- Use `lin NP` so any lock field required by the RGL lincat is added.
    mkNPConst : Gender -> Number -> Str -> NP = \g,n,w ->
      lin NP { s = \\_ => w ; a = agrgP3 g n } ;

    copBe : Str = "është" ;

  lin
    -- Dates / time adverbs (simple concatenation fallbacks)
    dayMonthAdv d m = {s = d.s ++ m.s} ;
    dayMonthYearAdv d m y = {s = d.s ++ m.s ++ y.s} ;

    monthAdv m = {s = m.s} ;
    monthYearAdv m y = {s = m.s ++ y.s} ;
    yearAdv y = {s = y.s} ;

    -- Months / weekdays as nouns / proper names
    monthN m = mkNConst Masc m.s ;
    monthPN m = {s = m.s} ;

    weekdayN w = mkNConst Fem w.s ;
    weekdayPN w = {s = w.s} ;
    weekdayLastAdv w = {s = w.s ++ "e" ++ "kaluar"} ;
    weekdayNextAdv w = {s = w.s ++ "e" ++ "ardhshme"} ;
    weekdayPunctualAdv w = {s = "të" ++ w.s} ;
    weekdayHabitualAdv w = {s = "çdo" ++ w.s} ;

    intMonthday i = {s = i.s} ;
    intYear i = {s = i.s} ;

    -- Languages
    InLanguage lang = {s = "në" ++ lang.s} ;

    languageCN lang = mkNConst Fem ("gjuhë" ++ lang.s) ;
    languageNP lang = mkNPConst Fem Sg ("gjuha" ++ lang.s) ;

    -- Age / name / questions (stringy fallbacks)
    has_age_VP c = {s = c.s ++ "vjeç"} ;

    -- name behaves NP-like in your setup (name.s : Case => Str), so pick Nom
    have_name_Cl np name = {s = np.s ! Nom ++ "quhet" ++ name.s ! Nom} ;
    what_name_QCl np = {s = "si" ++ "quhet" ++ np.s ! Nom} ;

    how_old_QCl np = {s = "sa" ++ "vjeç" ++ copBe ++ np.s ! Nom} ;
    how_far_QCl np = {s = "sa" ++ "larg" ++ copBe ++ np.s ! Nom} ;

    married_Cl np other =
      {s = np.s ! Nom ++ copBe ++ "i" ++ "martuar" ++ "me" ++ other.s ! Nom} ;

    hungry_VP  = {s = "i" ++ "uritur"} ;
    thirsty_VP = {s = "i" ++ "etur"} ;
    tired_VP   = {s = "i" ++ "lodhur"} ;
    ill_VP     = {s = "i" ++ "sëmurë"} ;
    scared_VP  = {s = "i" ++ "frikësuar"} ;
    ready_VP   = {s = "gati"} ;

    is_right_VP = {s = "me" ++ "të" ++ "drejtë"} ;
    is_wrong_VP = {s = "gabim"} ;

    -- Weather: "moti është AP"
    weather_adjCl ap =
      {s = "moti" ++ copBe ++ ap.s ! Indef ! Nom ! Masc ! Sg} ;

    -- Time unit adverbials / quantity constructions
    timeunitAdv c tu = {s = c.s ++ tu.s} ;

    n_units_AP c cn a = {
      s = \\spec,cas,g,n =>
            c.s ++ cn.s ! Indef ! cas ! Pl ++ a.s ! cas ! g ! n
    } ;

    n_units_of_NP c cn np =
      lin NP {
        s = \\cas => c.s ++ cn.s ! Indef ! cas ! Pl ++ "prej" ++ np.s ! Ablat ;
        a = agrgP3 Masc Pl
      } ;

}