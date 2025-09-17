((. (require :lean) :setup)
 {:mappings true
  :abbreviations {:enable true :extra {"n" "\\n"}}
  :goal_markers {:unsolved "✗" :accomplished "✓"}})

(vim.api.nvim_create_autocmd :FileType
  {:pattern [:lean :lean3]
   :callback
   (fn []
     (vim.keymap.set :n "<LocalLeader>s" (_G.cmd "LeanSorryFill") {:buffer true}))
   :group (vim.api.nvim_create_augroup :mithic-lean {})})
