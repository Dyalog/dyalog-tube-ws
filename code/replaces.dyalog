 replaces←{                                     ⍝ For use with Pocket APL.
                                               ⍝ replace DAN component.
     fullname←{                                   ⍝ full file name.
         GetModuleFileNameW←{}                      ⍝ local function.
         102::⍵                                     ⍝ running on PC?
         _←⎕NA'coredll|GetModuleFileNameW U >0T2 U' ⍝ associate name.
         exename←GetModuleFileNameW 0 255 255       ⍝ executable name.
         rtdir←{(⌽∨\⌽'\'=⍵)/⍵}exename               ⍝ runtime directory.
         dvdir←'\My Documents\Pocket APL\'          ⍝ development directory.
         isdevt←1∊'dyalog.exe'⍷lcase exename        ⍝ development version?
         (⊃isdevt⌽rtdir dvdir),⍵                    ⍝ full name.
     }

     lcase←{                                      ⍝ Lower-casification,
         lc←'abcdefghijklmnopqrstuvwxyz'            ⍝ (lower case alphabet)
         uc←'ABCDEFGHIJKLMNOPQRSTUVWXYZ'            ⍝ (upper case alphabet)
         (lc,⎕AV)[(uc,⎕AV)⍳⍵]                       ⍝ ... of simple array.
     }

     tie←(fullname'dan.dcf')⎕FTIE 0               ⍝ open DAN component file.
     error←{⍵ ⎕SIGNAL ⍺⊣⎕FUNTIE tie}              ⍝ error: untie and signal.
     elarg←'Left arg must be city namespace'      ⍝ bad left arg.
     ecity←'Can''t find "',(⍕,⍵),'"'              ⍝ mis-spelled city?
     get←{⎕FREAD tie ⍵}                           ⍝ get component from file.
     put←{⍵ ⎕FREPLACE tie ⍺}                      ⍝ replace component on file.
     rel←⎕FUNTIE∘⎕FRESIZE                         ⍝ release file.
     city cvec←get 1                              ⍝ city status vector.
     names←⊃¨cvec                                 ⍝ city names.

     0=⎕NC'⍺':names{                              ⍝ remove city.
         ~(⊂⍵)∊names:6 error ecity                  ⍝ abort if bad city name.
         cno←⍺⍳⊂⍵                                   ⍝ city number.
         cc←city⌊¯1+⍴cvec                           ⍝ new current city.
         _←1 put cc,⊂(cno≠⍳⍴cvec)/cvec              ⍝ put updated state vector.
         pairs←{(⊂1 1),2,/(⍺≤⍵)/⍵}                  ⍝ component pairs.
         _←put∘get/¨cno pairs⍳⍴cvec                 ⍝ shuffle removed comp to end.
         rel tie⊣⎕FDROP tie ¯1                      ⍝ drop comp and release file.
     }⍵

     9≠⎕NC'⍺':11 error elarg                      ⍝ not space: abort.
     ecomp←'compile ',⍕⍺                          ⍝ must compile.
     0=⍺.⎕NC'graph':11 error ecomp                ⍝ no graph: must compile.
     graph←{{↑,/⍵}¨((⍴¨⍵)↑¨1)⍵}⍺.graph            ⍝ stripped graph.
     stats←{(1=≡¨⍵)/⍵}⍺.labels                    ⍝ nested station list.
     stops←⊖⍉↑{0 1 0 1∘/¨(2=≡¨⍵)/⍵}⍺.labels       ⍝ line-station names.
     lines←∪⊃↓stops                               ⍝ unique line names.
     labels←{↑,/(⊃⌽⎕TC),¨⍵}¨lines stats           ⍝ nl-prefaced names.
     stopx←↑lines stats⍳¨↓stops                   ⍝ line-station indices.
     comp←labels stopx graph                      ⍝ file component.
     indx←⍵(5 2)⍬(1 1)({10}¨lines)                ⍝ first component index.
     (⊂⍵)∊names:{                                 ⍝ replace existing component.
         _←(⍵+1)put comp                            ⍝ replace graph component.
         (⍵⊃cvec)←indx                              ⍝ update city index.
         _←1 put city cvec                          ⍝ replace index component.
         rel tie                                    ⍝ release file.
     }names⍳⊂⍵                                    ⍝ city index.
     _←comp ⎕FAPPEND tie                          ⍝ append new city component.
     _←1 put city,⊂cvec,⊂indx                     ⍝ put cities index.
     rel tie                                      ⍝ relesae file.
 }
