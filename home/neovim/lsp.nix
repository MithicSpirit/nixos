{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [{
      plugin = nvim-lspconfig;
      config = "require 'custom.lsp'";
    }];
    extraPackages = with pkgs; [
      fennel-ls
      zls
      rustup
      clang-tools
      haskell-language-server
      ruff
      basedpyright
      texlab
      ltex-ls
    ];
    extraLuaPackages = luaPkgs: [ luaPkgs.lua-lsp ];
  };
}
