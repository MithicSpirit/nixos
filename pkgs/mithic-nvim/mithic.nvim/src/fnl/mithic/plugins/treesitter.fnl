(local augroup (vim.api.nvim_create_augroup :mithic-treesitter {}))
(local nvim-ts (require :nvim-treesitter))

(local hi-ignore {:latex true :gitcommit true})
(local fd-ignore {})

(local in-enable {})

(vim.api.nvim_create_autocmd
  :FileType
  { ; No pattern: always trigger, then switch based on filetype in callback
   :callback #(let [ft vim.bo.filetype
                    lang (vim.treesitter.language.get_lang ft)]
                (when (pcall #(vim.treesitter.language.inspect lang))
                  (when (not (or (. hi-ignore lang) (. hi-ignore ft)))
                    (vim.treesitter.start))
                  (when (not (or (. fd-ignore lang) (. fd-ignore ft)))
                    (set vim.wo.foldexpr "v:lua.vim.treesitter.foldexpr()")
                    (set vim.wo.foldmethod :expr))
                  (when (or (. in-enable lang) (. in-enable ft))
                    (set vim.bo.indentexpr
                         "v:lua.require'nvim-treesitter'.indentexpr()")))
                nil)
   :group augroup})
