((. (require :nvim-treesitter.configs) :setup)
 {:ensure_installed
  [:vim :vimdoc :lua :fennel :query :comment :markdown :markdown_inline]
  :sync_install false
  :auto_install true
  :ignore_install []
  :highlight
  {:enable true
   :additional_vim_regex_highlighting true
   :disable [:latex]}
  :indent {:enable true :disable []}
  :incremental_selection
  {:enable true :disable []
   :keymaps {:init_selection "gf"
             :node_incremental "gf"
             :node_decremental "gd"
             :scope_incremental "gh"}}})
(set vim.opt.foldexpr "nvim_treesitter#foldexpr()")
