(vim.keymaps.set "n" "<leader>G" "<Cmd>Git<CR>")

((. (require :gitsigns) :setup)
 {:signs
  {:add {:text "+"} :change {:text "~"} :changedelete {:text "="}
   :delete {:text "_"} :topdelete {:text "‾"} :untracked {:text "|"}}
  :attach_to_untracked true
  :current_line_blame true
  :current_line_blame_opts
  {:delay 0
   :ignore_whitespace false
   :virt_text_pos :eol}
  :current_line_blame_formatter
  "<author>@<author_time:%Y-%m-%d>(<abbrev_sha>) <summary>"
  :preview_config
  {:border _G.border
   :style :minimal
   :relative :cursor}})
