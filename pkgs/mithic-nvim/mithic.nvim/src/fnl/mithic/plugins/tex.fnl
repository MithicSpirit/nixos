(set vim.g.vimtex_enabled 1)
(set vim.g.vimtex_compiler_method :latexmk)
(set vim.g.vimtex_text_obj_enabled 1)
(set vim.g.vimtex_doc_handlers [:vimtex#doc#handlers#texdoc])

(set vim.g.vimtex_complete_enabled 1)
(set vim.g.vimtex_complete_close_braces 1)

(set vim.g.vimtex_indent_enabled 1)
(set vim.g.vimtex_indent_bib_enabled 1)
(set vim.g.vimtex_indent_tikz_commands 1)
(set vim.g.vimtex_indent_on_ampersands 0)
(set vim.g.vimtex_indent_delims {:close_indented 1})

(set vim.g.vimtex_syntax_enabled 1)
(set vim.g.vimtex_syntax_conceal
     {:accents 1 :cites 1 :fancy 1 :greek 1 :ligatures 1 :math_bounds 1
      :math_delimiters 1 :math_fracs 0 :math_super_sub 1 :math_symbols 1
      :sections 0 :spacing 0 :styles 1})
(set vim.g.vimtex_syntax_conceal_cites {:type :brackets :verbose true})

(set vim.g.vimtex_view_enabled 1)
(set vim.g.vimtex_view_automatic 1)
(set vim.g.vimtex_view_method :zathura_simple)

; (set vim.g.vimtex_format_enabled 1)

(let [ag (vim.api.nvim_create_augroup :mithic-vimtex {})
      ns (vim.api.nvim_create_namespace :mithic-vimtex)]
  (vim.api.nvim_create_autocmd
    :FileType
    {:pattern :tex
     :callback
     (fn []
       (vim.keymap.set :i "]]" "<C-g>u<Plug>(vimtex-delim-close)")
       (vim.opt_local.iskeyword:remove ":"))
     :group ag})

  (set vim.g.vimtex_quickfix_mode 0)
  (vim.api.nvim_create_autocmd
    :User
    {:pattern [:VimtexEventCompileSuccess :VimtexEventCompileFailed]
     :callback
     (fn []
       (vim.diagnostic.reset ns 0)
       (vim.diagnostic.set
         ns 0
         (vim.diagnostic.fromqflist (vim.fn.getqflist))))
     :group ag}))


(set vim.g.vimtex_mappings_prefix "<localleader>")
(set vim.g.vimtex_mappings_disable
     {:n ["tsf" "tsc" "tse" "ts$" "tsb" "tss" "<F6>" "tsd" "tsD" "<F7>" "<F8>"]
      :x ["tsf" "<F6>" "tsd" "tsD" "<F7>"]
      :i ["]]" "<F7>"]})

(set vim.g.vimtex_imaps_leader "`")
(set vim.g.vimtex_imaps_list
     [{:lhs "("  :rhs "\\subsetneq"}
      {:lhs ")"  :rhs "\\supsetneq"}
      {:lhs "0"  :rhs "\\varnothing"}
      {:lhs "8"  :rhs "\\infty"}
      {:lhs "A"  :rhs "\\forall"}
      {:lhs "E"  :rhs "\\exists"}
      {:lhs "["  :rhs "\\subseteq"}
      {:lhs "\\" :rhs "\\setminus"}
      {:lhs "]"  :rhs "\\supseteq"}
      {:lhs "wl" :rhs "\\ell"}
      {:lhs "a"  :rhs "\\alpha"}
      {:lhs "b"  :rhs "\\beta"}
      {:lhs "c"  :rhs "\\psi"}
      {:lhs "d"  :rhs "\\delta"}
      {:lhs "e"  :rhs "\\epsilon"}
      {:lhs "f"  :rhs "\\phi"}
      {:lhs "g"  :rhs "\\gamma"}
      {:lhs "h"  :rhs "\\eta"}
      {:lhs "i"  :rhs "\\iota"}
      {:lhs "j"  :rhs "\\xi"}
      {:lhs "k"  :rhs "\\kappa"}
      {:lhs "l"  :rhs "\\lambda"}
      {:lhs "m"  :rhs "\\mu"}
      {:lhs "n"  :rhs "\\nu"}
      {:lhs "p"  :rhs "\\pi"}
      {:lhs "r"  :rhs "\\rho"}
      {:lhs "s"  :rhs "\\sigma"}
      {:lhs "t"  :rhs "\\tau"}
      {:lhs "u"  :rhs "\\theta"}
      {:lhs "v"  :rhs "\\omega"}
      {:lhs "x"  :rhs "\\chi"}
      {:lhs "y"  :rhs "\\upsilon"}
      {:lhs "z"  :rhs "\\zeta"}
      {:lhs "C"  :rhs "\\Psi"}
      {:lhs "D"  :rhs "\\Delta"}
      {:lhs "F"  :rhs "\\Phi"}
      {:lhs "G"  :rhs "\\Gamma"}
      {:lhs "J"  :rhs "\\Xi"}
      {:lhs "L"  :rhs "\\Lambda"}
      {:lhs "P"  :rhs "\\Pi"}
      {:lhs "S"  :rhs "\\Sigma"}
      {:lhs "U"  :rhs "\\Theta"}
      {:lhs "V"  :rhs "\\Omega"}
      {:lhs "Y"  :rhs "\\Upsilon"}
      {:lhs "we" :rhs "\\varepsilon"}
      {:lhs "wf" :rhs "\\varphi"}
      {:lhs "wk" :rhs "\\varkappa"}
      {:lhs "wp" :rhs "\\varpi"}
      {:lhs "wr" :rhs "\\varrho"}
      {:lhs "wu" :rhs "\\vartheta"}
      {:lhs "b" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"mathbf\")"}
      {:lhs "B" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"mathbb\")"}
      {:lhs "c" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"mathcal\")"}
      {:lhs "C" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"mathscr\")"}
      {:lhs "f" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"mathfrak\")"}
      {:lhs "i" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"mathit\")"}
      {:lhs "n" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"mathnormal\")"}
      {:lhs "r" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"mathrm\")"}
      {:lhs "s" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"mathsf\")"}
      {:lhs "t" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"text\")"}
      {:lhs "T" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"mathtt\")"}
      {:lhs "v" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"vec\")"}
      {:lhs "V" :leader "#" :expr 1
       :rhs "vimtex#imaps#style_math(\"hat\")"}
      {:lhs (or vim.g.vimtex_imaps_leader "`")
       :rhs (or vim.g.vimtex_imaps_leader "`")
       :wrapper "vimtex#imaps#wrap_trivial"}])
