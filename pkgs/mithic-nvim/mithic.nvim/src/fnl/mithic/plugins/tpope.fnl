(set vim.g.surround_no_insert_mappings 1)
(vim.keymap.set :i "<C-s>" "<Plug>Isurround")
(vim.keymap.set :i "<C-S-s>" "<Plug>ISurround")

(vim.keymap.set "n" "<leader>G" (_G.cmd "Git"))

(set vim.g.sleuth_make_heuristics 0) ; Makefiles MUST use tabs
