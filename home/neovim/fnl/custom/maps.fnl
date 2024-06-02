(fn cmd [...]
  (.. "<Cmd>" (table.concat [...] " | ") "<Cr>"))

(set vim.g.mapleader " ")
(set vim.g.maplocalleader "\\")
(vim.keymap.set "" "<leader>" "<Nop>")
(vim.keymap.set "" "<localleader>" "<Nop>")

(vim.keymap.set :n "Y" :y$)
(vim.keymap.set :n "x" "\"_x")
(vim.keymap.set :n "~~" "g~l")
(vim.keymap.set :n "<Esc>" (cmd :nohlsearch :mode))
(vim.keymap.set :n "ZQ" (cmd :cquit))

(vim.keymap.set :n "<leader>s" (cmd :write))
(vim.keymap.set :n "<leader>e" (cmd "!%:p"))
(vim.keymap.set :n "<leader>E" (cmd :write "botright 13split +terminal\\ %:p"))
(vim.keymap.set :n "<leader>t" (cmd "botright 19split +terminal" :startinsert))

(vim.keymap.set [:n :x] "<leader>y" "\"+y" {:remap true})
(vim.keymap.set [:n :x] "<leader>Y" "\"+Y" {:remap true})
(vim.keymap.set :n "<leader><C-Y>" #(vim.fn.setreg "+" (vim.fn.getreg "")))
(vim.keymap.set [:n :x] "<leader>p" "\"+p" {:remap true})
(vim.keymap.set [:n :x] "<leader>P" "\"+P" {:remap true})

(vim.keymap.set :n "gQ"
  #(let [c (vim.api.nvim_win_get_cursor 0)]
     (vim.cmd "normal! gggqG")
     (pcall #(vim.api.nvim_win_set_cursor 0 c))))
(vim.keymap.set :i "<C-Space>" "<C-x><C-o>") ; TODO: set options about this i forger
(vim.keymap.set :n "<C-W>," "<C-w><")
(vim.keymap.set :n "<C-W>." "<C-w>>")
(vim.keymap.set :t "<C-\\><C-\\>" "<C-\\><C-n>")
(vim.keymap.set :v "J" ":move '>+1<Cr>gv" {:silent true})
(vim.keymap.set :v "K" ":move '<-2<Cr>gv" {:silent true})
(vim.keymap.set :v ">" ">gv")
(vim.keymap.set :v "<" "<gv")
(vim.keymap.set :n "<C-d>" "<C-d>zz")
(vim.keymap.set :n "<C-u>" "<C-u>zz")
(vim.keymap.set :n "n" "nzz")
(vim.keymap.set :n "N" "Nzz")
(vim.keymap.set :n "<leader>." (cmd "edit ."))

(vim.keymap.set [:i :t] "<C-Bs>" "<C-h>" {:remap true})
(vim.keymap.set :i "<C-h>" "<C-g>u<C-w><C-g>u")

(vim.keymap.set :n "<leader>ld" vim.diagnostic.open_float)
(vim.keymap.set "" "[d" vim.diagnostic.goto_prev)
(vim.keymap.set "" "]d" vim.diagnostic.goto_next)

(vim.keymap.set "" "s" "<Nop>")
(vim.keymap.set "" "S" "<Nop>")

(vim.api.nvim_create_user_command :Cdfile
  #(vim.api.nvim_set_current_dir (vim.fn.expand "%:p:h"))
  {:desc "cd to the parent of the current file" :force false})

(vim.api.nvim_create_user_command :Checkhealth
  (fn [] (vim.cmd "Lazy! load all") (vim.cmd.checkhealth))
  {:desc "Load all plugins and check health" :force false})
