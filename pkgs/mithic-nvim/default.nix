{ pkgs, buildVimPlugin ? pkgs.vimUtils.buildVimPlugin, fennel ? pkgs.fennel }:
# TODO: get a statusline (NOT lualine please for the love of god please)
# TODO: theme
(buildVimPlugin {

  pname = "mithic-nvim"; # mithic.nvim
  version = "";

  src = ./src;

  buildPhase = ''
    for i in $(find fnl -type f); do
      dir="lua/$(realpath -s --relative-to ./fnl $(dirname "$i"))"
      name="$(basename "$i" .fnl)"
      mkdir -p "$dir"
      fennel --globals vim,_G --correlate --compile "$i" > "$dir/$name.lua"
      rm "$i"
    done
    find fnl -type d -empty -delete
  '';

}).overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [ fennel ];
  vimPlugins = (with pkgs.vimPlugins; [

    colorizer

    gitsigns-nvim
    indent-blankline-nvim # ibl
    hop-nvim
    #trouble-nvim
    vim-sneak
    undotree
    #nvim-parinfer
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
    vim-commentary # TODO: nvim 0.10

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

  propagatedBuildInputs =
    (if old ? propagatedBuildInputs then old.propagatedBuildInputs else [ ])
    ++ (with pkgs; [
      fd # telescope
      elan # lean
      coq
      cornelis
      # lsp
      fennel-ls
      zls
      rustup
      clang-tools
      haskell-language-server
      ruff
      #basedpyright
      texlab
      ltex-ls
    ]);
})
