{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      cornelis # FIXME: move
      vim-textobj-user # dep for cornelis
      nvim-hs-vim # dep for cornelis
    ];
    extraPackages = with pkgs; [
      luajitPackages.lua-lsp
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
    extraConfigLua = "require 'mithic.lsp'";
  };
}
