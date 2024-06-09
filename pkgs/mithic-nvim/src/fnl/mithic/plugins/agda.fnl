(local augroup (vim.api.nvim_create_augroup :mithic-cornelis {}))

(set vim.g.cornelis_use_global_binary 1)

(vim.api.nvim_create_autocmd :FileType
  {:pattern :agda
   :callback
   #(let [opts {:buffer true}]
      (vim.keymap.set :n "<localleader>l" vim.cmd.CornelisLoad opts)
      (vim.keymap.set :n "<localleader>r" vim.cmd.CornelisRefine opts)
      (vim.keymap.set :n "<localleader>d" vim.cmd.CornelisMakeCase opts)
      (vim.keymap.set :n "<localleader>," vim.cmd.CornelisTypeContext opts)
      (vim.keymap.set :n "<localleader>." vim.cmd.CornelisTypeContextInfer opts)
      (vim.keymap.set :n "<localleader>n" vim.cmd.CornelisSolve opts)
      (vim.keymap.set :n "<localleader>a" vim.cmd.CornelisAuto opts)
      (vim.keymap.set :n "<localleader>[" vim.cmd.CornelisPrevGoal opts)
      (vim.keymap.set :n "<localleader>]" vim.cmd.CornelisNextGoal opts)
      (vim.keymap.set :n "gd" vim.cmd.CornelisGoToDefinition opts)
      (vim.keymap.set :n "<C-A>" vim.cmd.CornelisInc opts)
      (vim.keymap.set :n "<C-X>" vim.cmd.CornelisDec opts))
   :group augroup})

(vim.api.nvim_create_autocmd :BufWritePost
  {:pattern ["*.agda" "*.lagda"]
   :command "CornelisLoad"
   :group augroup})
