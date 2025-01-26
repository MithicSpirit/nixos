(set vim.opt.showmode false)
(set vim.opt.mouse :nv)
(set vim.opt.mousemodel :extend)
(set vim.opt.mousescroll "ver:2,hor:4")

(set vim.opt.conceallevel (if _G.unicode 2 0))
(set vim.opt.guifont "Iosevka Mithic:h12:#e-antialias:#h-full")
(set vim.opt.linespace 0)
(set vim.opt.timeout false)
(set vim.opt.cursorline true)
(set vim.opt.allowrevins true)
(set vim.opt.tildeop true)
(vim.opt.path:append "**")
(set vim.opt.completeopt "menu,menuone,noinsert,noselect,popup")

(set vim.opt.spelllang :en_us)

(set vim.opt.ignorecase true)
(set vim.opt.smartcase true)
(set vim.opt.hlsearch true)
(set vim.opt.incsearch true)

(set vim.opt.undodir (.. (vim.fn.stdpath :cache) "/undodir"))
(set vim.opt.undofile true)
(set vim.opt.undolevels (^ 2 15))

(set vim.opt.scrolloff 6)
(set vim.opt.sidescrolloff 6)
(set vim.opt.number true)
(set vim.opt.relativenumber false)
(set vim.opt.numberwidth 4)
(set vim.opt.signcolumn :yes:1)

(set vim.opt.splitbelow true)
(set vim.opt.splitright true)

(set vim.opt.textwidth 80)
(set vim.opt.colorcolumn "+1")
(set vim.opt.formatoptions "cro/qnl1j")
(set vim.opt.wrap false)

(set vim.opt.tabstop 8)
(set vim.opt.shiftwidth 4)
(set vim.opt.softtabstop -1)  ; stay in sync with sw
(set vim.opt.expandtab true)

(set vim.g.loaded_node_provider 0)
(set vim.g.loaded_perl_provider 0)
(set vim.g.loaded_ruby_provider 0)

(set vim.g.tex_flavor :latex)
(set vim.g.zig_fmt_autosave 0)

(set vim.g.markdown_recommended_style 0)
(set vim.g.python_recommended_style 0)
(set vim.g.rust_recommended_style 0)

(set vim.opt.listchars
   {:extends "$"
    :lead "|"
    :leadmultispace "|   "
    :nbsp "~"
    :precedes "$"
    :tab "> "
    :trail "⏹"})
(set vim.opt.list true)
