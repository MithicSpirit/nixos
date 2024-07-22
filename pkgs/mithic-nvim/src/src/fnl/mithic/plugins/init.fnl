(local
  mods
  [:mini
   :gitsigns
   :ibl
   :hop
   :trouble
   :sneak
   :undotree
   :tex
   :idris
   :tpope
   :telescope
   :lsp
   :lean
   :coq
   :agda
   :treesitter])

(each [_ mod (pairs mods)]
  (require (.. ... "." mod)))
