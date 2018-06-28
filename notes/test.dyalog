 test←{                                  ⍝ Run test script: no news => good news.
     ⍺←0                                 ⍝ default: don't show progress.
     ⍵≡'':⍺ ∇ ⎕NL 2                      ⍝ null: test all scripts.
     2=⍴⍴⍵:⍺ ∇↓⍵                         ⍝ matrix: each row is a script.
     2=≡⍵:⍺ ∇¨⍵                          ⍝ nested: test each script.

     tag scr←{                           ⍝ name and content of script.
         ⎕PATH←''                        ⍝ isolate test.
         6::{'' ''}⎕←'No test.',⍵        ⍝ value error:: display message.
         ⍵(⍎⍵)                           ⍝ name and content.
     }⍵

     exec←{⎕ML←0                         ⍝ execute script lines in tmp space.
         0=⍴⍵:⍺                          ⍝ no more, finished.
         ⎕←show⊃⍵                        ⍝ show expression.
         exp←unc⊃⍵                       ⍝ uncommented first line.
         ''≡exp~' ':⍺ ∇ 1↓⍵              ⍝ ignore blank line.
         1∊'←{'⍷unq exp:⍺ ∇ dfn ⍵        ⍝ make local dfn.
         '←'∊unq exp:⍺ ∇ asgn ⍵          ⍝ make local var.
         act←tmp{6::0 0⍴'' ⋄ ⍺⍎⍵}exp     ⍝ actual result.
         ⎕←show act                      ⍝ show result.
         ok rem←act check 1↓⍵            ⍝ check against expected result.
         (⍺∧ok)∇ rem                     ⍝ check remaining script.
     }

     check←{⎕ML←0
         act←↓tmp.⎕FMT ⍺                 ⍝ actual result,
         exp←(⍴act)↑⍵                    ⍝ expected result,
         act≡exp:1,⊂(⍴act)↓⍵             ⍝ match: continue.
         dexp dact←dots¨exp act          ⍝ dots for spaces in,
         ⎕←tag,⊂dexp'→'dact              ⍝ display of differences.
         0,⊂(⍴act)↓⍵                     ⍝ and continue.
     }

     dfn←{                               ⍝ fix temp dfn.
         raw←unq∘unc¨⍵                   ⍝ raw code
         depth←+\{⊃⌽-⌿+\'{}'∘.=⍵}¨raw    ⍝ {}-nesting depth per line.
         lines←1++/∧\×depth              ⍝ no of lines in defn.
         _←tmp.⎕FX↑lines↑⍵               ⍝ fix dfn in temp space.
         ⎕←show↑1↓lines↑⍵                ⍝ show dfn body.
         lines↓⍵                         ⍝ continue with remaining lines.
     }

     nest←{⎕ML←0                         ⍝ split line vector,
         nl←⊃2↓⎕TC                       ⍝ at nl char into,
         1↓¨(1,⍵=nl)⊂nl,⍵                ⍝ vector of char vecs.
     }

     dots←{⎕IO←0                         ⍝ replace ' ' with '·' in diff display.
         sx←⎕AV⍳' '                      ⍝ index of space.
         to←(sx↑⎕AV),'·',1↓sx↓⎕AV        ⍝ [·/ ]⎕av
         ↑{(⎕AV⍳⍵)⊃¨⊂to}¨⍵               ⍝ translated value.
     }

     asgn←{_←tmp⍎⊃⍵ ⋄ 1↓⍵}               ⍝ assign local name.
     unq←{(~≠\''''=⍵){⍺\⍺/⍵}⍵}           ⍝ unquoted chars.
     unc←{(∧\'⍝'≠unq ⍵)/⍵}               ⍝ uncommented line.
     show←⍺∘{↑⍺/↓⎕FMT ⍵}                 ⍝ show progress.

     tmp←##.(⎕NS ⎕NL 3 4 9)              ⍝ tmp space for evaluation.
     ''≡scr:ok←0                         ⍝ bad script name.
     2=≡⍵:ok←1 exec scr                  ⍝ vector of vectors: go ahead,
     1:ok←1 exec nest scr                ⍝ split line vector.
 }
