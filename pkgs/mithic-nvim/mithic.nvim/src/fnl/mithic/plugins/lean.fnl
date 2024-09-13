((. (require :lean) :setup) {:mappings true})

(vim.api.nvim_create_autocmd :FileType
  {:pattern [:lean :lean3]
   :callback
   #(vim.keymap.set :n "<LocalLeader>s" (_G.cmd "LeanSorryFill") {:buffer true})
   :group (vim.api.nvim_create_augroup :mithic-lean {})})
