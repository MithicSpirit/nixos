(local augroup (vim.api.nvim_create_augroup :mithic-treesitter {}))
(local nvim-ts (require :nvim-treesitter))

(local hi-ignore {:latex true})
(local fd-ignore {})
(local in-ignore {})

(vim.api.nvim_create_autocmd
  :FileType
  { ; No pattern: always trigger, then switch based on filetype in callback
   :callback #(let [ft vim.bo.filetype]
                (when (pcall
                        #(vim.treesitter.language.inspect
                           (vim.treesitter.language.get_lang ft)))
                  (when (not (. hi-ignore ft))
                    (vim.treesitter.start))
                  (when (not (. fd-ignore ft))
                    (set vim.wo.foldexpr "v:lua.vim.treesitter.foldexpr()")
                    (set vim.wo.foldmethod :expr))
                  (when (not (. in-ignore ft))
                       (set vim.bo.indentexpr
                                  "v:lua.require'nvim-treesitter'.indentexpr()")))
                nil)
   :group augroup})
