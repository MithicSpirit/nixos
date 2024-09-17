{
  vimPlugins,
  mithic-nvim-unwrapped,
  pkgs,
}:
mithic-nvim-unwrapped.overrideAttrs (old: {

  name = "${old.name}-with-deps";
  pname = "${old.pname}-with-deps";

  vimPlugins =
    (old.vimPlugins or [ ])
    ++ (with vimPlugins; [

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

    ]);

  extraPackages =
    (old.extraPackages or [ ])
    ++ (with pkgs; [

      fd # telescope
      elan
      coq
      cornelis

      # lsp
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
      ltex-ls

    ]);
})
