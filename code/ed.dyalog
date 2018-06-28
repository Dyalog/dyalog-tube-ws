 ed←{                    ⍝ Edit source for subway ⍵.
     _←'→'⍵.⎕ED'source'  ⍝ edit source.
     _←⍵.⎕EX'graph'      ⍝ force recompilation by removing: graph,
     _←⍵.⎕EX'labels'     ⍝ and vertex labels.
 }
