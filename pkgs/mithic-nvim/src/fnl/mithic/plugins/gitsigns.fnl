((. (require :gitsigns) :setup)
 {:signs
  {:add {:text "+"} :change {:text "~"} :changedelete {:text "="}
   :delete {:text "_"} :topdelete {:text "‾"} :untracked {:text "|"}}
  :signs_staged_enable false ; TODO
  :attach_to_untracked true
  :current_line_blame true
  :current_line_blame_opts
  {:delay 0
   :ignore_whitespace false
   :virt_text_pos :eol}
  :current_line_blame_formatter
  " <author>@<author_time:%Y-%m-%d>(<abbrev_sha>) <summary>"
  :preview_config
  {:border _G.border
   :style :minimal
   :relative :cursor}})

(vim.keymap.set :n "<leader>gA" "<Cmd>Gitsigns stage_buffer<Cr>")
(vim.keymap.set [:n :x] "<leader>ga" "<Cmd>Gitsigns stage_hunk<Cr>")
(vim.keymap.set [:n :x] "<leader>gD" "<Cmd>Gitsigns reset_hunk<Cr>")
(vim.keymap.set [:n :x] "<leader>gw" "<Cmd>Gitsigns preview_hunk<Cr>")
(vim.keymap.set "" "]g" "<Cmd>Gitsigns next_hunk<Cr>")
(vim.keymap.set "" "[g" "<Cmd>Gitsigns prev_hunk<Cr>")
