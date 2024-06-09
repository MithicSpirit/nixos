(fn hop [typ dir opts]
  #(let [cole vim.o.conceallevel]
     (set vim.opt.conceallevel 0)
     ((. (require :hop) typ)
      (vim.tbl_deep_extend :force
        {:direction (. (require :hop.hint) :HintDirection dir)}
        (or opts {})))
     (set vim.opt.conceallevel cole)))

(each [k v (pairs
             {"f" [:hint_char1 :AFTER_CURSOR]}
             {"F" [:hint_char1 :BEFORE_CURSOR]}
             {"t" [:hint_char1 :AFTER_CURSOR {:hint_offset -1}]}
             {"T" [:hint_char1 :BEFORE_CURSOR {:hint_offset 1}]}
             {"j" [:hint_vertical :AFTER_CURSOR]}
             {"k" [:hint_vertical :BEFORE_CURSOR]}
             {"w" [:hint_words :AFTER_CURSOR]}
             {"b" [:hint_words :BEFORE_CURSOR]}
             {"/" [:hint_patterns :AFTER_CURSOR]}
             {"?" [:hint_patterns :BEFORE_CURSOR]})]
  (vim.keymap.set "" (.. "gs" k) (hop (_G.unpack v))))
