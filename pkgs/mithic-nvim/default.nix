{ pkgs, buildVimPlugin ? pkgs.vimUtils.buildVimPlugin, fennel ? pkgs.fennel
, python3 ? pkgs.python3 }:
# TODO: get a statusline (NOT lualine please for the love of god please)
# TODO: theme
(buildVimPlugin {

  pname = "mithic-nvim"; # mithic.nvim
  version = "";

  src = ./mithic.nvim;

  buildPhase = ''
    python3 build.py
    cd out
  '';

}).overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [ fennel python3 ];

  vimPlugins = (with pkgs.vimPlugins; [

    mini-nvim
    gitsigns-nvim
    indent-blankline-nvim # ibl
    hop-nvim
    trouble-nvim
    vim-sneak
    undotree
    nvim-parinfer
    #firenvim
    vimtex
    idris2-nvim

    # tpope
    vim-sleuth
    vim-eunuch
    vim-rsi
    vim-fugitive
    vim-repeat
    vim-surround

    # telescope
    telescope-nvim
    telescope-zf-native-nvim
    telescope-file-browser-nvim

    # lsp
    nvim-lspconfig

    # lean
    lean-nvim
    plenary-nvim

    # coq
    Coqtail

    # agda
    cornelis
    vim-textobj-user
    nvim-hs-vim

    # treesitter
    nvim-treesitter
  ]) ++ (with builtins;
    filter isAttrs (attrValues pkgs.vimPlugins.nvim-treesitter-parsers));

  extraPackages = with pkgs; [

    fd # telescope
    lean4 # lean
    idris2Packages.idris2Lsp
    coq
    cornelis

    # lsp
    lua-language-server
    fennel-ls
    clang-tools
    haskell-language-server
    nil
    rust-analyzer
    zls
    ruff
    basedpyright
    texlab
    ltex-ls

  ];
})
