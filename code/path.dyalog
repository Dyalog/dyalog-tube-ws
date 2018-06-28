 path←{                      ⍝ Shortest path from/to ⍵ in graph ⍺.
     graph←⍺                 ⍝ ⍺ is graph vector.
     fm to←⍵                 ⍝ starting and target vertex(ices).
     tree←¯2+(⍳⍴⍺)∊fm        ⍝ initial spanning tree.
     free←{(¯2=tree[⍵])/⍵}   ⍝ free vertices in ⍵.
     ⍬{                      ⍝ path accumulator.
         ⍵<0:(⍵=¯2)↓⍺        ⍝ root or unvisited vertex: finished.
         (⍵,⍺)∇ ⍵⊃tree       ⍝ otherwise: prefix previous (parent) vertex.
     }{                      ⍝ find partial spanning tree:
         ⍵≡⍬:¯1              ⍝ no vertices left: stitched.
         1∊to∊⍵:1↑⍵∩to       ⍝ found target: finished.
         next←free¨graph[⍵]  ⍝ next vertices to visit.
         back←↑,/⍵+0×next    ⍝ back links.
         wave←↑,/next        ⍝ vertex wave front.
         tree[wave]←back     ⍝ set back links in tree.
         ∇∪wave              ⍝ advance wave front.
     }fm                     ⍝ from starting vertex.
 }
