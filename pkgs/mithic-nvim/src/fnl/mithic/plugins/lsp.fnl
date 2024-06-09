(local lsp_setting (require (.. ... :.settings)))

(each [name conf (pairs lsp_setting)]
  ((. (require :lspconfig) name :setup) conf))

(tset (require :lspconfig.ui.windows) :default_options :border _G.border)

(each [k v (pairs
             {"d" :definition
              "D" :declaration
              "t" :signature_help
              "T" :type_definition
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
            client (vim.lsp.get_client_by_id event.data.client_id)]
        (when client.server_capabilities.inlayHintProvider
          (vim.lsp.inlay_hint.enable true {:bufnr buf})))
      false)}) ; return false to not delete autocmd
