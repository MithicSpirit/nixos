(vim.cmd.highlight :clear)
(set vim.g.colors_name :mithic)

(local
  palette
  (let [nord
        {:00 "#2e3440"
         :01 "#3b4252"
         :02 "#434c5e"
         :03 "#4c566a"
         :04 "#7484a2" ; #d8dee9
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
    {:lift [nord.01 :NONE]
     :marker [nord.02 :Blue]
     :selection [nord.03 :NONE]
     :fake [nord.04 :DarkBlue]
     :accent [nord.08 :DarkCyan]
     :bad [nord.11 :DarkRed]
     :advanced [nord.12 :Red]
     :warn [nord.13 :DarkYellow]
     :good [nord.14 :DarkGreen]
     :strange [nord.15 :DarkMagenta]
     :comment [nord.04 :Blue]
     :name [nord.05 :LightGray]
     :syntax [nord.06 :White]
     :type [nord.07 :Cyan]
     :function [nord.08 :DarkCyan]
     :special [nord.09 :Blue]
     :pragma [nord.10 :DarkBlue]
     :string [nord.14 :DarkGreen]
     :number [nord.15 :DarkMagenta]
     :red [nord.11 :DarkRed]
     :green [nord.14 :DarkGreen]
     :yellow [nord.13 :DarkYellow]
     :blue [nord.09 :DarkBlue]
     :magenta [nord.15 :DarkMagenta]
     :cyan [nord.08 :DarkCyan]}))

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
; Menu, Scrollbar, Tooltip, QuickFixLine


;; UI
(hi :Normal)
(hi :MsgArea :Normal)
(hi :NormalFloat :Normal)
(hi :NormalNC :Normal)

(hi :Cursor)
(hi :lCursor :Cursor)
(hi :CursorIM :Cursor)
(hi :TermCursor {:fg :accent :bg :NONE :reverse true})
(hi :TermCursorNC)

(hi :ColorColumn
    {:bg :marker :ctermbg :NONE :ctermfg :marker :cterm {:reverse true}})
(hi :CursorLine {:bg :lift})
(hi :CursorColumn :CursorLine)

(hi :Visual {:bg :selection :cterm {:reverse true}})
(hi :VisualNOS :Visual)
(hi :Search :Visual)
(hi :CurSearch :Search)
(hi :IncSearch :Search)
(hi :Substitute :Search)

(hi :LineNr {:fg :comment})
(hi :LineNrAbove :LineNr)
(hi :LineNrBelow :LineNr)
(hi :CursorLineNr {:fg :accent :bold true})

(hi :StatusLine {:fg :NONE :bg :lift})
(hi :MsgSeparator :StatusLine)
(hi :StatusLineNC {:fg :fake :bg :lift})
(let [rev (fn [name] {:fg name :bg :NONE :reverse true})]
  (hi :User1 (rev :blue)) ; normal
  (hi :User2 (rev :green)) ; insert
  (hi :User3 (rev :yellow)) ; visual
  (hi :User4 (rev :red)) ; replace
  (hi :User5 (rev :magenta)) ; command
  (hi :User6 (rev :cyan))) ; other
(hi :User9 {:fg :NONE :bg :marker :ctermbg :NONE :bold true}) ; file

(hi :WinSeparator {:fg :marker})
(hi :FloatBorder :WinSeparator)

(hi :NonText {:fg :marker})
(hi :EndOfBuffer :NonText)
(hi :SnippetTabstop :NonText)
(hi :Whitespace :NonText)
(hi :Ignore :NonText)

(hi :Conceal {:fg :fake})
(hi :SpecialKey :Conceal)
(hi :Folded :Conceal)
(hi :FoldColumn :Conceal) ; TODO
(hi :CursorLineFold :FoldColumn)
(hi :SignColumn :Conceal) ; TODO
(hi :CursorLineSign :SignColumn)

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


;; Syntax
(hi :Comment {:fg :comment :italic true})

(hi :Identifier {:fg :name})
(hi :Constant :Identifier)
(hi "@variable" :Identifier)

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
(hi :DiffText {:bg :selection})

(hi :LspInlayHint :Conceal)
(hi :LspCodeLens :Conceal)

(hi :DiagnosticError {:fg :bad})
(hi :DiagnosticWarn {:fg :warn})
(hi :DiagnosticInfo {:fg :comment})
(hi :DiagnosticHint {:fg :accent})
(hi :DiagnosticOk {:fg :good})
(hi :DiagnosticUnderlineError {:sp :bad :underline true})
(hi :DiagnosticUnderlineWarn {:sp :warn :underline true})
(hi :DiagnosticUnderlineInfo {:sp :comment :underline true})
(hi :DiagnosticUnderlineHint {:sp :accent :underline true})
(hi :DiagnosticUnderlineOk {:sp :good :underline true})
(hi :DiagnosticDeprecated {:strikethrough true})


;; Plugins
(hi :MiniStatuslineModeNormal  :User1)
(hi :MiniStatuslineModeInsert  :User2)
(hi :MiniStatuslineModeVisual  :User3)
(hi :MiniStatuslineModeReplace :User4)
(hi :MiniStatuslineModeCommand :User5)
(hi :MiniStatuslineModeOther   :User6)

(hi :MiniHipatternsFixme :User4)
(hi :MiniHipatternsHack  :User3)
(hi :MiniHipatternsTodo  :User6)
(hi :MiniHipatternsNote  :User1)

(hi :GitSignsCurrentLineBlame :Conceal)

;; Language-specific
(hi :texCmd :Function)

(hi :leanGoalsAccomplishedSign :DiagnosticOk)
(hi :leanUnsolvedGoals :DiagnosticError)


(when (vim.fn.exists :syntax_on) (vim.cmd.syntax :reset))
