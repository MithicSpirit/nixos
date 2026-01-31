{
  pkgs,
  config,
  lib,
  ...
}: let
  me = pkgs.mithic-nvim;
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = [me];
    initLua =
      # lua
      ''
        vim.g.vimtex_callback_progpath =
          '${lib.getExe config.programs.neovim.finalPackage}'
        require 'mithic'
      '';
    extraPackages = me.propagatedBuildInputs;
  };
}
