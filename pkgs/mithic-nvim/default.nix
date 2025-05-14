{
  lib,
  vimUtils,
  fennel,
  python3,
  vimPlugins,
  # dependencies
  fd,
  elan,
  coq,
  idris2Packages,
  lua-language-server,
  fennel-ls,
  clang-tools,
  haskell-language-server,
  nixd,
  rustup,
  zls,
  ruff,
  basedpyright,
  texlab,
  ltex-ls-plus,
  millet,
}:
vimUtils.buildVimPlugin {

  pname = "mithic-nvim"; # mithic.nvim
  version = "";

  src = ./mithic.nvim;

  buildPhase = ''
    python3 build.py
    cd out
  '';

  nativeBuildInputs = [
    fennel
    python3
  ];

  dependencies = with vimPlugins; [
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
    nvim-lspconfig
    lean-nvim
    Coqtail
    cornelis
    nvim-treesitter.withAllGrammars

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
  ];

  propagatedBuildInputs = [
    fd
    elan
    coq
    idris2Packages.idris2Lsp
    lua-language-server
    fennel-ls
    clang-tools
    haskell-language-server
    nixd
    rustup
    zls
    ruff
    basedpyright
    texlab
    ltex-ls-plus
    millet
  ];

  meta = with lib; {
    description = "MithicSpirit's Neovim configuration";
    platforms = platforms.all;
    maintainers = [ maintainers.mithicspirit ];
  };
}
