 trip←{⎕IO ⎕ML←1 0                       ⍝ Trip from/to ⍵ in network space ⍺.

     0=⍺.⎕NC'graph':⍺{                   ⍝ source not compiled for this space.
         ⎕←'compiling graph ...'         ⍝ explain slight delay.
         (compile ⍺)trip ⍵               ⍝ try again with compiled graph.
     }⍵

     access←⍺.((1=≡¨labels)/labels)      ⍝ access via station entrances.

     legs←{                              ⍝ start and end station indices.
         hits←∨/⍵⍷↑access                ⍝ stations containing supplied string.
         best←1+⊃⍋↑⍴¨hits/access         ⍝ best (tightest) fit.
         best⊃0,hits/⍳⍴hits              ⍝ index of chosen station.
     }¨⍵                                 ⍝ for each leg of the journey.

     0∊legs:'Can''t find: ',↑{           ⍝ misspelled station name:
         ⍺,' or ',⍵                      ⍝ (one or more stations)
     }/(0=legs)/⍵                        ⍝ give up :-(

     find←⍺.graph{⍺⍺ path ⍺ ⍵}           ⍝ find one leg of the route.
     route←↑{⍺,1↓⍵}/2 find/legs          ⍝ suggested route via all points.

     labels←⍺.labels[route]              ⍝ labels for all legs of route.

     masks←1 2=⊂≡¨labels                 ⍝ masks of stations and stops.
     stats stops←masks/¨⊂labels          ⍝ station and stop labels.

     zip←{↓⍉↑⍵}                          ⍝ transpose vector-of-vectors.
     cat←{↑,/⍵}                          ⍝ concatenate   ..      ..
     pad←{↓↑⍵}                           ⍝ pad vectors with blanks.

     slabs←cat¨zip pad¨zip stops         ⍝ aligned stop labels.
     ↑(stats,slabs)[⍋⍋2⊃masks]           ⍝ merged stations and stops.
 }
