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

(vim.keymap.set :n "<leader>gA" (_G.cmd "Gitsigns stage_buffer"))
(vim.keymap.set [:n :x] "<leader>ga" (_G.cmd "Gitsigns stage_hunk"))
(vim.keymap.set [:n :x] "<leader>gD" (_G.cmd "Gitsigns reset_hunk"))
(vim.keymap.set [:n :x] "<leader>gw" (_G.cmd "Gitsigns preview_hunk"))
(vim.keymap.set "" "]g" (_G.cmd "Gitsigns next_hunk"))
(vim.keymap.set "" "[g" (_G.cmd "Gitsigns prev_hunk"))
