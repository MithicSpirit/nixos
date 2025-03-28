(local augroup (vim.api.nvim_create_augroup :mithic {}))

;; FileType options
; C-like
(vim.api.nvim_create_autocmd :FileType
  {:pattern [:c :cpp :java :javascript :typescript :json :jsonc :zig :rust]
   :command "setlocal shiftwidth=8 noexpandtab cindent"
   :group augroup})

; Lisp-like
(vim.api.nvim_create_autocmd :FileType
  {:pattern [:lisp :fennel :scheme :racket]
   :command "setlocal shiftwidth=2 softtabstop=0 expandtab"
   :group augroup})

; Haskell-like
(vim.api.nvim_create_autocmd :FileType
  {:pattern [:haskell :idris :idris2 :agda :ocaml :lean :lean3 :nix]
   :command "setlocal shiftwidth=2 expandtab"
   :group augroup})

; Prose
(vim.api.nvim_create_autocmd :FileType
  {:pattern [:text :tex :markdown :gitcommit :help :mail]
   :command "setlocal shiftwidth=2 expandtab formatoptions+=t"
   :group augroup})

; Configs
(vim.api.nvim_create_autocmd :FileType
  {:pattern [:conf :toml :yaml :ini]
   :command "setlocal shiftwidth=2 expandtab"
   :group augroup})

; Tabbed
(vim.api.nvim_create_autocmd :FileType
  {:pattern [:asm :tsv]
   :command "setlocal shiftwidth=0 noexpandtab" ; sw=0 -> tabstop
   :group augroup})

; Shells
(vim.api.nvim_create_autocmd :FileType
  {:pattern [:sh :zsh :fish :lua]
   :command "setlocal shiftwidth=8 noexpandtab"
   :group augroup})

; Misc
(vim.api.nvim_create_autocmd :FileType
  {:pattern :gitcommit
   :command "setlocal tabstop=8"
   :group augroup})

(vim.api.nvim_create_autocmd :FileType
  {:pattern :python
   :command "setlocal textwidth=79"
   :group augroup})

(vim.api.nvim_create_autocmd :FileType
  {:pattern [:lean :lean3]
   :command "setlocal textwidth=100"
   :group augroup})

(vim.api.nvim_create_autocmd :FileType
  {:pattern :help
   :command "setlocal scrolloff=1 colorcolumn=\"\""
   :group augroup})

(vim.api.nvim_create_autocmd :FileType
  {:pattern :sml
   :command "setlocal commentstring=(*\\ %s\\ *)"
   :group augroup})

(vim.api.nvim_create_autocmd :FileType
  {:pattern [:sml :ocaml]
   :command "setglobal fo=cr/qnl1j | setlocal fo<"
   :group augroup})

(vim.api.nvim_create_autocmd :FileType
  {:pattern [:mail]
   :command "setlocal textwidth=70"
   :group augroup})


;; Mappings
(vim.api.nvim_create_autocmd :FileType
 {:pattern :tex
  ; TODO: use a snippet
  :callback
    (fn []
      (vim.keymap.set :i "\"" "``" {:buffer true})
      (vim.keymap.set :i "$" "\\(" {:buffer true}))
  :group augroup})


;; Misc
(vim.api.nvim_create_autocmd :TextYankPost
  {:callback #(vim.highlight.on_yank) :group augroup})

(vim.api.nvim_create_autocmd :TermOpen
 {:command "setlocal nonumber norelativenumber"
  :group augroup})
