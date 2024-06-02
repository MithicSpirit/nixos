(local trouble (require :trouble))

(trouble.setup
 {:auto_open false
  :auto_close true
  :auto_preview true
  :auto_refresh true
  :focus false
  :restore true
  :follow true
  :indent_guides true
  :multiline false})

(each [k v (pairs
             {"x" :diagnostics
              "q" :quickfix
              "l" :loclist
              "t" :telescope
              "s" :symbols})]
  (vim.keymap.set :n (.. "<leader>x" k) #(trouble.toggle v)))
(vim.keymap.set "" "]x" #(trouble.next {:skip_groups true :jump true}))
(vim.keymap.set "" "[x" #(trouble.previous {:skip_groups true :jump true}))
