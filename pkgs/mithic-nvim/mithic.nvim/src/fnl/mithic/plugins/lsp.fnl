(each [k v (pairs
             {"d" :signature_help
              "t" :type_definition
              "h" :typehierarchy
              "i" :implementation
              "r" :rename
              "a" :code_action})]
  (vim.keymap.set :n (.. "<leader>l" k) (. vim.lsp.buf v)))
(vim.keymap.set :n "<leader>lc" vim.lsp.codelens.run)

(vim.api.nvim_create_autocmd
  :LspAttach
  {:callback
    (fn [event]
      (let [buf event.buf
            client (vim.lsp.get_client_by_id event.data.client_id)
            opts {:buffer buf}]

        (when client.server_capabilities.documentFormattingProvider
          (vim.keymap.set :n "gQ" vim.lsp.buf.format opts))

        (when client.server_capabilities.definitionProvider
          (vim.keymap.set :n "gd" vim.lsp.buf.definition opts))

        (when client.server_capabilities.declarationProvider
          (vim.keymap.set :n "gD" vim.lsp.buf.declaration opts)))

        ;(when client.server_capabilities.inlayHintProvider
        ;  (vim.lsp.inlay_hint.enable true {:bufnr buf})))

      false)}) ; return false to not delete autocmd

(each [name conf (pairs (require (.. ... :.settings)))]
  (vim.lsp.config name conf)
  (vim.lsp.enable name))
