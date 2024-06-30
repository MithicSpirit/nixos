(vim.cmd.highlight :clear)
(set vim.g.colors_name :mithic)

(local
  palette
  (let [nord
        {:00 "#2e3440"
         :01 "#3b4252"
         :02 "#434c5e"
         :03 "#4c566a"
         :04 "#d8dee9"
         :05 "#e5e9f0"
         :06 "#eceff4"
         :07 "#8fbcbb"
         :08 "#88c0d0"
         :09 "#81a1c1"
         :10 "#5e81ac"
         :11 "#bf616a"
         :12 "#d08770"
         :13 "#ebcb8b"
         :14 "#a3be8c"
         :15 "#b48ead"}]
    {:border [nord.01 :Blue]
     :selection [nord.02 :Blue]
     :marker [nord.03 :Blue]
     :fake [nord.04 :Blue]
     :highlight [nord.07 :Cyan]
     :accent [nord.08 :DarkCyan]
     :bad [nord.11 :DarkRed]
     :advanced [nord.12 :Yellow]
     :warn [nord.13 :DarkYellow]
     :good [nord.14 :DarkGreen]
     :strange [nord.15 :DarkMagenta]
     :comment [nord.04 :DarkBlue]
     :name [nord.05 :White]
     :syntax [nord.06 :Gray]
     :type [nord.07 :Cyan]
     :function [nord.08 :DarkCyan]
     :special [nord.09 :DarkBlue]
     :pragma [nord.10 :Blue]
     :string [nord.14 :DarkGreen]
     :number [nord.15 :DarkMagenta]
     }))

(fn mk-get [n]
  (fn [name]
    (when name (let [c (. palette name)]
                 (if c (. c n) name)))))

(local get-truecolor (mk-get 1))
(local get-cterm (mk-get 2))

(fn convert [opts]
  (let [merged
        (vim.tbl_deep_extend
          :force
          opts
          {:fg (get-truecolor opts.fg)
           :ctermfg (get-cterm (or opts.ctermfg opts.fg))
           :bg (get-truecolor opts.bg)
           :ctermbg (get-cterm (or opts.ctermbg opts.bg))
           :sp (get-truecolor opts.sp)})]
    merged))

(fn hi [name opts overrides]
  (vim.api.nvim_set_hl
    0 name
    (if (= (type opts) "string") {:force true :link opts}
        (vim.tbl_deep_extend
          :force
          {:force true}
          (convert (or opts {}))
          (or overrides {})))))

; TODO: FloatTitle FloatFooter, Pmenu*, TabLine*, Title, WildMenu, WinBar*,
; User1..9, Menu, Scrollbar, Tooltip, QuickFixLine

(hi :Normal)
(hi :MsgArea :Normal)
(hi :NormalFloat :Normal)
(hi :NormalNC :Normal)

(hi :Cursor)
(hi :lCursor :Cursor)
(hi :CursorIM :Cursor)
(hi :TermCursor :Cursor) ; TODO
(hi :TermCursorNC) ; TODO

(hi
  :Visual
  {:bg :selection :ctermbg :NONE :ctermfg :selection :cterm {:reverse true}})
(hi :VisualNOS :Visual)
(hi :ColorColumn :Visual)
(hi :CursorColumn :Visual)
(hi :CursorLine :Visual)
(hi :Search :Visual)
(hi :CurSearch :Visual)
(hi :IncSearch :Visual)
(hi :Substitute :Visual)

(hi :NonText {:fg :marker})
(hi :EndOfBuffer :NonText)
(hi :SnippetTabstop :NonText)
(hi :Whitespace :NonText)

(hi :LineNr {:fg :comment})
(hi :LineNrAbove :LineNr)
(hi :LineNrBelow :LineNr)
(hi :CursorLineNr {:fg :accent :bold true})

(hi
  :StatusLine
  {:bg :border :ctermbg :NONE :ctermfg :border :cterm {:reverse true}})
(hi :MsgSeparator :StatusLine)
; TODO: (hi :StatusLineNC)

(hi :WinSeparator {:fg :border})
(hi :FloatBorder :WinSeparator)

(hi :Conceal {:fg :fake})
(hi :SpecialKey :Conceal)
(hi :Folded :Conceal)
(hi :FoldColumn :Conceal) ; TODO
(hi :CursorLineFold :FoldColumn)
(hi :SignColumn :Conceal) ; TODO
(hi :CursorLineSign :SignColumn)
(hi :Ignore :Conceal)

(hi :ErrorMsg {:fg :bad})
(hi :WarningMsg {:fg :warn})

(hi :Question {:fg :accent})
(hi :MoreMsg :Question)

(hi :SpellBad {:sp :bad :undercurl true})
(hi :SpellCap {:sp :advanced :undercurl true})
(hi :SpellLocal {:sp :warn :undercurl true})
(hi :SpellRare {:sp :accent :undercurl true})

(hi :ModeMsg {:fg :comment})
(hi :MatchParen {:bold true :fg :accent})



(hi :Comment {:fg :comment :italic true})

(hi :Identifier)
(hi :Constant :Identifier)

(hi :String {:fg :good})
(hi :Character :String)

(hi :Number {:fg :number})
(hi :Float :Number)
(hi :Boolean :Number)

(hi :Function {:fg :function})
(hi :Directory :Function)

(hi :Statement {:fg :syntax :bold true})
(hi :Conditional :Statement)
(hi :Repeat :Statement)
(hi :Label :Statement)
(hi :Keyword :Statement)
(hi :Exception :Statement)

(hi :PreProc {:fg :pragma})
(hi :Include :PreProc)
(hi :Define :PreProc)
(hi :Macro :PreProc)
(hi :PreCondit :PreProc)

(hi :Type {:fg :type})
(hi :StorageClass {:fg :special})
(hi :Typedef {:fg :syntax})
(hi :Structure :Typedef)

(hi :Special {:fg :warn})
(hi :SpecialChar :Special)

(hi :SpecialComment {:fg :pragma})
(hi :Todo {:fg :pragma :bold true :underline true :nocombine true})

(hi :Operator {:fg :special})
(hi :Tag {:fg :special})
(hi :Debug {:fg :warn})
(hi :Delimiter {:fg :syntax})
(hi :Error {:fg :bad :reverse true})

(hi :Added {:fg :good})
(hi :DiffAdd :Added)
(hi :Changed {:fg :warn})
(hi :DiffChange :Changed)
(hi :Removed {:fg :bad})
(hi :DiffDelete :Removed)
(hi :DiffText {:bg :selection :ctermbg :NONE})


(hi :DiagnosticError {:fg :bad})
(hi :DiagnosticWarn {:fg :warn})
(hi :DiagnosticInfo {:fg :accent})
(hi :DiagnosticHint {:fg :highlight})
(hi :DiagnosticOk {:fg :good})
(hi :DiagnosticUnderlineError {:sp :bad :underline true})
(hi :DiagnosticUnderlineWarn {:sp :warn :underline true})
(hi :DiagnosticUnderlineInfo {:sp :accent :underline true})
(hi :DiagnosticUnderlineHint {:sp :highlight :underline true})
(hi :DiagnosticUnderlineOk {:sp :good :underline true})
(hi :DiagnosticDeprecated {:strikethrough true})

(hi "@variable")

(when (vim.fn.exists :syntax_on) (vim.cmd.syntax :reset))
