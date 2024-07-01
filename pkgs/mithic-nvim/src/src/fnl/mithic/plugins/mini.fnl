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
      {:use_icons false})

; (mini :surround)
