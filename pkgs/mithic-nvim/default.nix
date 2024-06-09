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
  propagatedBuildInputs =
    (if old ? propagatedBuildInputs then old.propagatedBuildInputs else [ ])
    ++ (with pkgs.vimPlugins; [

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
      pkgs.fd

      # lsp
      nvim-lspconfig
      pkgs.fennel-ls
      pkgs.zls
      pkgs.rustup
      pkgs.clang-tools
      pkgs.haskell-language-server
      pkgs.ruff
      # pkgs.basedpyright
      pkgs.texlab
      pkgs.ltex-ls

      # lean
      lean-nvim
      plenary-nvim
      pkgs.elan

      # coq
      Coqtail
      pkgs.coq

      # agda
      cornelis
      vim-textobj-user
      nvim-hs-vim
      pkgs.cornelis

      # treesitter
      nvim-treesitter

    ]) ++ (with builtins;
      filter isAttrs (attrValues pkgs.vimPlugins.nvim-treesitter-parsers));
})
