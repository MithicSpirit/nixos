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
        {:use_icons vim.o.termguicolors
         :content
         {:active #(let [(mode mode_hl) (s.section_mode {:trunc_width 120})
                         diff (s.section_diff {:trunc_width 75})
                         diag (s.section_diagnostics {:trunc_width 75})
                         lsp (s.section_lsp {:trunc_width 75})
                         finfo (s.section_fileinfo {:trunc_fileinfo 120})
                         loc (s.section_location {:trunc_width 75})
                         search (s.section_searchcount {:trunc_width 75})]
                     (s.combine_groups
                       [{:hl mode_hl :strings [mode]}
                        "%<" ; truncate point
                        {:hl :MiniStatuslineFilename
                         :strings [(fname)]}
                        {:hl :MiniStatuslineFileinfo :strings [loc search]}
                        "%=" ; center
                        {:hl :MiniStatuslineFileinfo :strings [finfo]}
                        {:hl mode_hl :strings [diff diag lsp]}]))
          :inactive fname}}))

; (mini :surround)
