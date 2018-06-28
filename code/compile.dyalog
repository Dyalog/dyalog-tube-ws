 compile←{⎕IO ⎕ML←1 0                    ⍝ Compile graph from ⍵.source.

     zip←{↓⍉↑⍵} ⋄ cat←{↑,/⍵}             ⍝ transpose/concatenate vec-of-vecs.

     lines stats ctrls←zip zip¨{         ⍝ first pass: source → line sections.
         vecs←{↓⎕FMT↑⍵}                  ⍝ normalise source to vector-of-vectors.
         rcom←{(∧\~'//'⍷⍵)/⍵}            ⍝ remove comments '// ···' from line.
         rbls←{(∨/¨' '≠⍵)/⍵}             ⍝ remove blanks lines: ''  '' ···
         segt←{(' '≠⊃¨⍵)⊂⍵}              ⍝ segment at non-blank first column.
         trim←{(∨\⍵≠' ')/⍵}{⌽⍺⍺⌽⍺⍺ ⍵}    ⍝ remove blanks, fore and aft.
         tupl←'+↓∊'{⍺(trim ⍵~⍺⍺)(⍺⍺∩⍵)}  ⍝ tupl: (line stat ctrl).
         tups←{(⊂trim⊃⍵)tupl¨1↓⍵}        ⍝ tuples: tupl tupl ···.
         tups¨segt rbls rcom¨vecs ⍵      ⍝ line segments.
     }⍵.source

     seqs←{(⍳¨⍵)+0,+\¯1↓⍵}               ⍝ sequence of sequences.
     csids←{⍵\¨seqs+/¨⍵}'+'∊¨¨ctrls      ⍝ stations marked as cross-tracks.
     stops←zip¨zip lines stats csids     ⍝ subway stops.
     plats←{↓⍵∘.,'^∨'}¨stops             ⍝ platform for each direction.
     slist←{⍵[⍋↑⍵]}∪cat stats            ⍝ sorted station list.
     verts←slist,∪cat cat plats          ⍝ graph vertices.
     platx←{↓verts⍳↑⍵}¨plats             ⍝ platform indices within graph.
     statx←{2/¨verts⍳⍵}¨stats            ⍝ station indices within graph.
     linex←{(∪⍵)⍳⍵}⊃¨lines               ⍝ line indices per segment.
     rests←'↓∊'∘∊¨¨ctrls                 ⍝ restrictions: 1-way sects and forks.

     plinks←cat¨2{                       ⍝ platform-to-platform links / section.
         links((ow fk)_)←zip ⍺ ⍵         ⍝ directions and restrictions.
         rev←{⌽⍵}\                       ⍝ reverse second pair.
         oway←{⍺:1↑⍵ ⋄ rev ⍵}            ⍝ one-way section.
         fork←{⍺:⌽zip rev ⍵ ⋄ zip ⍵}     ⍝ fork.
         ow oway fk fork links           ⍝ ⍺←→⍵ links.
     }/¨zip¨zip platx rests              ⍝ pairwise for each line section.

     clinks←((∪linex)=⊂linex)/¨⊂plinks   ⍝ link sections collected by line.

     llinks←cat↑{                        ⍝ connected sections for all lines.
         next←⍺~⍵                        ⍝ next section, duplicates removed.
         clash←↑∪zip∩⌿↑zip¨next ⍵        ⍝ incompatible directions.
         diffs←⍉¯1 1∘.×-/clash           ⍝ vertex index differences.
         avecs←↑+/,diffs×clash=⊂next     ⍝ adjustment vectors.
         (next+avecs),⍵                  ⍝ connected line subsections.
     }/¨clinks                           ⍝ for each section of each line.

     slinks←cat zip¨zip cat¨statx platx  ⍝ (stat plat) ··· links.
     elinks←0 1∘.⌽slinks                 ⍝ station-platform each-way links.
     nlinks←{⍵[⍋↑⍵]}∪(,elinks),llinks    ⍝ combined network-wide links.
     ⍵.graph←↑{(⍺≠¯1⌽⍺)⊂⍵}/zip nlinks    ⍝ network graph.

     stags←2/⌽¨2↑¨∪cat stops             ⍝ (stop line) label pairs.
     slabs←cat¨zip¨zip(⊂4 1↑¨⊂'')stags   ⍝ indented stop labels.
     ⍵.labels←slist,slabs                ⍝ station/stop labels.

     1:shy←⍵                             ⍝ shy result: namespace ref.
 }
