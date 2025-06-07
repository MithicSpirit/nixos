(fn _G.cmd [...]
  (.. "<Cmd>" (table.concat [...] " | ") "<Cr>"))


(set _G.unicode
     (or (= vim.env.TERM "alacritty")
         (= vim.env.TERM "xterm-kitty")
         (= vim.env.TERM "xterm-ghostty")))

(set _G.border (if _G.unicode :rounded :single))
