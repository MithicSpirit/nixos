(fn mini [name opts]
  ((. (require (.. :mini. name)) :setup) opts))

(mini :ai)

; (mini :bracketed)

; (mini :bufremove)

; (mini :comment)

; (mini :diff)

; (mini :git)

; (mini :hipatterns)

; (mini :jump)

; (mini :jumped)

; (mini :move)

; (mini :pairs)

(mini :statusline
      (let [s (require :mini.statusline)
            fname #(if (= vim.bo.buftype :terminal) "%t" "%h%f%m%r")]
        {:use_icons _G.unicode
         :content
         {:active #(let [(mode mode_hl) (s.section_mode {:trunc_width 100})
                         diff (s.section_diff {:trunc_width 70})
                         diag (s.section_diagnostics {:trunc_width 70})
                         lsp (s.section_lsp {:trunc_width 70})
                         finfo (s.section_fileinfo {:trunc_fileinfo 100})
                         loc (s.section_location {:trunc_width 120})]
                     (s.combine_groups
                       [{:hl mode_hl :strings [mode]}
                        "%<" ; truncate point
                        {:hl :User9 :strings ["%<" (fname)]}
                        {:hl :StatusLine :strings [loc]}
                        "   %=" ; center
                        {:hl :StatusLine :strings [finfo]}
                        {:hl mode_hl :strings [diff diag lsp]}]))
          :inactive #(s.combine_groups {:hl :StatusLineNC :strings [fname]})}}))

; (mini :surround)
