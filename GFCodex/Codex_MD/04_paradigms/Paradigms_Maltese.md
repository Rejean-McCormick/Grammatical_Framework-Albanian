# Paradigms: Maltese

#LParadigms

source [``../src/maltese/ParadigmsMlt.gf`` http://www.grammaticalframework.org/lib/src/maltese/ParadigmsMlt.gf]

|| Function  | Type  | Explanation ||
| ``masculine`` | [Gender #Gender] | //-// |
| ``feminine`` | [Gender #Gender] | //-// |
| ``singular`` | [Number #Number] | //-// |
| ``plural`` | [Number #Number] | //-// |
| ``form1`` | [VDerivedForm #VDerivedForm] | //Binyan I: daħal// |
| ``form2`` | [VDerivedForm #VDerivedForm] | //Binyan II: daħħal// |
| ``form3`` | [VDerivedForm #VDerivedForm] | //Binyan III: wieġeb// |
| ``form4`` | [VDerivedForm #VDerivedForm] | //Binyan IV: wera// |
| ``form5`` | [VDerivedForm #VDerivedForm] | //Binyan V: ddaħħal// |
| ``form6`` | [VDerivedForm #VDerivedForm] | //Binyan VI: twieġeb// |
| ``form7`` | [VDerivedForm #VDerivedForm] | //Binyan VII: ndaħal// |
| ``form8`` | [VDerivedForm #VDerivedForm] | //Binyan VIII: ftakar// |
| ``form9`` | [VDerivedForm #VDerivedForm] | //Binyan IX: sfar// |
| ``form10`` | [VDerivedForm #VDerivedForm] | //Binyan X: stieden// |
| ``strong`` | [VClass #VClass] | //Strong tri. verb: kiteb (k-t-b)// |
| ``liquidMedial`` | [VClass #VClass] | //Strong liquid-medial tri. verb: ħareġ (ħ-r-ġ)// |
| ``geminated`` | [VClass #VClass] | //Strong geminated tri. verb: ħabb (ħ-b-b)// |
| ``assimilative`` | [VClass #VClass] | //Weak-initial tri. verb: wieġeb (w-ġ-b)// |
| ``hollow`` | [VClass #VClass] | //Weak-medial tri. verb: ried (r-j-d)// |
| ``lacking`` | [VClass #VClass] | //Weak-final tri. verb: mexa (m-x-j)// |
| ``defective`` | [VClass #VClass] | //GĦ-final tri. verb: qata' (q-t-għ)// |
| ``quad`` | [VClass #VClass] | //Strong quad. verb: ħarbat (ħ-r-b-t)// |
| ``quadWeak`` | [VClass #VClass] | //Weak-final quad. verb: kanta (k-n-t-j)// |
| ``irregular`` | [VClass #VClass] | //Irregular verb: af ('-'-f)// |
| ``loan`` | [VClass #VClass] | //Loan verb: ipparkja (no root)// |
| ``mkN`` | ``Str`` ``->`` [N #N] | //Noun paradigm 1: Take the singular and infer plural// |
| ``mkN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //Noun paradigm 1: Explicit gender// |
| ``mkN`` | ``Str`` ``->`` ``Str`` ``->`` [N #N] | //Noun paradigm 1: Take the singular and explicit plural// |
| ``mkN`` | ``Str`` ``->`` ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //Noun paradigm 1: Explicit gender// |
| ``mkN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [N #N] | //Noun paradigm 1x: Take singular and both plurals// |
| ``mkN`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //Noun paradigm 1x: Explicit gender// |
| ``mkNColl`` | ``Str`` ``->`` [N #N] | //Noun paradigm 2c: Collective form only// |
| ``mkNColl`` | ``Str`` ``->`` ``Str`` ``->`` [N #N] | //Noun paradigm 2b: Collective and plural// |
| ``mkNColl`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [N #N] | //Noun paradigm 2: Singular, collective and plural// |
| ``mkNColl`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [N #N] | //Noun paradigm 2x: Singular, collective and both plurals// |
| ``mkNNoPlural`` | ``Str`` ``->`` [N #N] | //Noun paradigm 3: No plural// |
| ``mkNNoPlural`` | ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //Noun paradigm 3: Explicit gender// |
| ``mkNDual`` | ``Str`` ``->`` [N #N] | //Noun paradigm 4: Infer dual, plural and gender from singular// |
| ``mkNDual`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [N #N] | //Noun paradigm 4: Singular, dual, plural// |
| ``mkNDual`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //Noun paradigm 4: Explicit gender// |
| ``mkNDual`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [N #N] | //Noun paradigm 4x: Singular, dual, both plurals// |
| ``mkNDual`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Gender #Gender] ``->`` [N #N] | //Noun paradigm 4x: Explicit gender// |
| ``mkPN`` | ``Str`` ``->`` [Gender #Gender] ``->`` [Number #Number] ``->`` [ProperNoun #ProperNoun] | //Proper noun// |
| ``mkN2`` | [N #N] ``->`` [Prep #Prep] ``->`` [N2 #N2] | //-// |
| ``mkN2`` | [N #N] ``->`` ``Str`` ``->`` [N2 #N2] | //-// |
| ``mkN2`` | [N #N] ``->`` [N2 #N2] | //use "ta'"// |
| ``mkN3`` | [Noun #Noun] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [N3 #N3] | //-// |
| ``possN`` | [N #N] ``->`` [N #N] | //Mark a noun as taking possessive enclitic pronouns: missieri, missierek...// |
| ``mkRoot`` | [Root #Root] | //Null root// |
| ``mkRoot`` | ``Str`` ``->`` [Root #Root] | //From hyphenated string: "k-t-b"// |
| ``mkRoot`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Root #Root] | //Tri-consonantal root// |
| ``mkRoot`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [Root #Root] | //Quadri-consonantal root// |
| ``mkVowels`` | [Vowels #Vowels] | //Null vowel sequence// |
| ``mkVowels`` | ``Str`` ``->`` [Vowels #Vowels] | //Only single vowel// |
| ``mkVowels`` | ``Str`` ``->`` ``Str`` ``->`` [Vowels #Vowels] | //Two-vowel sequence// |
| ``mkV`` | ``Str`` ``->`` [V #V] | //With no root, automatically treat as loan verb// |
| ``mkV`` | ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Take an explicit root, implying it is a root & pattern verb// |
| ``mkV`` | ``Str`` ``->`` ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Takes an Imperative of the word for when it behaves less predictably// |
| ``mkV`` | [VClass #VClass] ``->`` [VDerivedForm #VDerivedForm] ``->`` [Root #Root] ``->`` [Vowels #Vowels] ``->`` ``(_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_`` ``:`` ``Str)`` ``->`` [V #V] | //All forms: mkV (Strong Regular) (FormI) (mkRoot "k-t-b") (mkVowels "i" "e") "ktibt" "ktibt" "kiteb" "kitbet" "ktibna" "ktibtu" "kitbu" "nikteb" "tikteb" "jikteb" "tikteb" "niktbu" "tiktbu" "jiktbu" "ikteb" "iktbu"// |
| ``mkV_II`` | ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Form II verb: mkV_II "waqqaf" (mkRoot "w-q-f")// |
| ``mkV_II`` | ``Str`` ``->`` ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Form II verb with explicit imperative form: mkV_II "waqqaf" "waqqaf" (mkRoot "w-q-f")// |
| ``mkV_III`` | ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Form III verb: mkV_III "qiegħed" (mkRoot "q-għ-d")// |
| ``mkV_V`` | ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Form V verb: mkV_V "twaqqaf" (mkRoot "w-q-f")// |
| ``mkV_VI`` | ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Form VI verb: mkV_VI "tqiegħed" (mkRoot "q-għ-d")// |
| ``mkV_VII`` | ``Str`` ``->`` ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Form VII verb: mkV_VII "xeħet" "nxteħet" (mkRoot "x-ħ-t")// |
| ``mkV_VIII`` | ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Form VIII verb: mkV_VIII "xteħet" (mkRoot "x-ħ-t")// |
| ``mkV_IX`` | ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Form IX verb: mkV_IX "sfar" (mkRoot "s-f-r")// |
| ``mkV_X`` | ``Str`` ``->`` [Root #Root] ``->`` [V #V] | //Form X verb: mkV_X "stagħġeb" (mkRoot "għ-ġ-b")// |
| ``presPartV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //Add the present participle to a verb: ħiereġ// |
| ``presPartV`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [V #V] ``->`` [V #V] | //Add the present participle to a verb: ħiereġ, ħierġa, ħierġin// |
| ``pastPartV`` | ``Str`` ``->`` [V #V] ``->`` [V #V] | //Add the past participle to a verb: miktub// |
| ``pastPartV`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [V #V] ``->`` [V #V] | //Add the past participle to a verb: miktub, miktuba, miktubin// |
| ``mkVS`` | [V #V] ``->`` [VS #VS] | //sentence-compl// |
| ``mkV3`` | [V #V] ``->`` [V3 #V3] | //ditransitive: give,_,_// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //two prepositions: speak, with, about// |
| ``mkV3`` | [V #V] ``->`` [Prep #Prep] ``->`` [V3 #V3] | //one preposition: give,_,to// |
| ``mkV2V`` | [V #V] ``->`` [Prep #Prep] ``->`` [Prep #Prep] ``->`` [V2V #V2V] | //want (noPrep NP) (to VP)// |
| ``mkConj`` | ``Str`` ``->`` [Conj #Conj] | //Conjunction: wieħed tnejn u tlieta// |
| ``mkConj`` | ``Str`` ``->`` ``Str`` ``->`` [Conj #Conj] | //Conjunction: wieħed , tnejn u tlieta// |
| ``mkA`` | ``Str`` ``->`` [A #A] | //Regular adjective with predictable feminine and plural forms: bravu// |
| ``mkA`` | ``Str`` ``->`` ``Str`` ``->`` [A #A] | //Infer feminine from masculine; no comparative form: sabiħ, sbieħ// |
| ``mkA`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [A #A] | //Explicit feminine form; no comparative form: sabiħ, sabiħa, sbieħ// |
| ``mkA`` | ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` ``Str`` ``->`` [A #A] | //All forms: sabiħ, sabiħa, sbieħ, isbaħ// |
| ``sameA`` | ``Str`` ``->`` [A #A] | //Adjective with same forms for masculine, feminine and plural: blu// |
| ``mkA2`` | [A #A] ``->`` [Prep #Prep] ``->`` [A2 #A2] | //-// |
| ``mkA2`` | [A #A] ``->`` ``Str`` ``->`` [A2 #A2] | //-// |
| ``mkAS`` | [A #A] ``->`` [AS #AS] | //-// |
| ``mkAdv`` | ``Str`` ``->`` [Adv #Adv] | //post-verbal adverb: illum// |
| ``mkAdV`` | ``Str`` ``->`` [AdV #AdV] | //preverbal adverb: dejjem// |
| ``mkAdA`` | ``Str`` ``->`` [AdA #AdA] | //adverb modifying adjective: pjuttost// |
| ``mkAdN`` | ``Str`` ``->`` [AdN #AdN] | //adverb modifying numeral: madwar// |
