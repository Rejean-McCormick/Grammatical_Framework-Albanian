concrete PhraseSqi of Phrase = CatSqi ** open Prelude, ResSqi in {

  lin
    PhrUtt pconj utt voc = {s = pconj.s ++ utt.s ++ voc.s} ;

    UttS s = s ;
    UttNP np = {s = np.s ! Nom} ;
    UttQS qs = qs ;
    UttImpS imp = imp ;
    UttAdv adv = adv ;
    UttIAdv iadv = iadv ;
    UttIP ip = ip ;
    UttInterj i = i ;

    NoPConj = {s = []} ;
    NoVoc = {s = []} ;

}