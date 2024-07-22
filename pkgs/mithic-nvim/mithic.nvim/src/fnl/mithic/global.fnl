(fn _G.cmd [...]
  (.. "<Cmd>" (table.concat [...] " | ") "<Cr>"))


(set _G.unicode
     (or (= vim.env.TERM "alacritty")
         (= vim.env.TERM "xterm-kitty")))

(set _G.border (if _G.unicode :rounded :single))
