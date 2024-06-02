; FIXME: make more modular

; vim-surround
(set vim.g.surround_no_insert_mappings 0)
(vim.keymaps.set :i "<C-s>" "<Plug>Isurround")

; gitsigns-nvim
(require :custom.gitsigns)

; indent-blankline-nvim
(require :custom.ibl)

; hop-nvim
(require :custom.hop)

; vim-sneak
(tset vim.g :sneak#use_ic_scs 1)
(vim.keymaps.set "" "f" "<Plug>Sneak_f")
(vim.keymaps.set "" "F" "<Plug>Sneak_F")
(vim.keymaps.set "" "t" "<Plug>Sneak_t")
(vim.keymaps.set "" "F" "<Plug>Sneak_T")

; undotree
(set vim.g.undotree_SetFocusWhenToggle 1)
(set vim.g.undotree_ShortIndicators 1)
(vim.keymaps.set :n "<leader>u" "<Cmd>UndotreeToggle<CR>")

; nvim-lspconfig
(require :custom.lsp)

; telescope-nvim
(require :custom.telescope)

; nvim-treesitter
(require :custom.treesitter)

; cornelis
(set vim.g.cornelis_use_global_binary 1)
(require :custom.cornelis)

; Coqtail
(set vim.g.coqtail_map_prefix "<localleader>")

; idris2-nvim
((. (require :idris2) :setup) {})

; lean-nvim
((. (require :lean) :setup) {})

; vimtex
(require :custom.vimtex)
