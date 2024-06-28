;; clear lc.lms and prevent automatic resetting
(vim.api.nvim_create_augroup :mithic-lc-lms {:clear true})
(vim.opt_global.listchars:remove [:lead :leadmultispace])

((. (require :ibl) :setup)
 {:indent {:char "▎" :tab_char "║"}
           ; :highlight [:RainbowRed :RainbowYellow :RainbowBlue
           ;             :RainbowOrange :RainbowViolet :RainbowGreen]}
  :scope {:char "▍" :show_start false :show_end false}})
