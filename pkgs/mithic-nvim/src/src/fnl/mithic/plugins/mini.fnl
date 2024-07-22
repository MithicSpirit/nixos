(fn mini [name opts]
  (let [m (require (.. :mini. name))]
    (m.setup (when opts (opts m)))))

(mini :ai)

(mini :bracketed)

(mini :bufremove
      (fn [m] (vim.keymap.set :n "<S-Tab>" #(m.delete 0))))

; (mini :comment)

(mini :hipatterns
      (fn [m]
        {:highlighters
         {:fixme {:pattern "%f[%w]()FIXME()%f[%W]" :group :MiniHipatternsFixme}
          :hack {:pattern "%f[%w]()HACK()%f[%W]" :group :MiniHipatternsHack}
          :todo {:pattern "%f[%w]()TODO()%f[%W]" :group :MiniHipatternsTodo}
          :note {:pattern "%f[%w]()NOTE()%f[%W]" :group :MiniHipatternsNote}
          :hex_color (m.gen_highlighter.hex_color {:style :inline})}}))

; (mini :pairs)

(mini :statusline
      (fn [m]
        (let [fname #(if (= vim.bo.buftype :terminal) "%t" "%h%f%m%r")]
          {:use_icons _G.unicode
           :content
           {:active #(let [(mode mode_hl) (m.section_mode {:trunc_width 100})
                           diff (m.section_diff {:trunc_width 70})
                           diag (m.section_diagnostics {:trunc_width 70})
                           lsp (m.section_lsp {:trunc_width 70})
                           finfo (m.section_fileinfo {:trunc_fileinfo 100})
                           loc (m.section_location {:trunc_width 120})]
                       (m.combine_groups
                         [{:hl mode_hl :strings [mode]}
                          "%<" ; truncate point
                          {:hl :User9 :strings [(fname)]}
                          {:hl :StatusLine :strings [loc]}
                          "   %=" ; center
                          {:hl :StatusLine :strings [finfo]}
                          {:hl mode_hl :strings [diff diag lsp]}]))
            :inactive #(m.combine_groups
                         {:hl :StatusLineNC :strings [(fname)]})}})))

; (mini :surround)
