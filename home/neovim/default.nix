{ pkgs, config, ... }:
let
  me = pkgs.mithic-nvim;
in
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = [ me ] ++ me.vimPlugins;
    extraLuaConfig = # lua
      ''
        vim.g.vimtex_callback_progpath =
          '${pkgs.lib.getExe config.programs.neovim.finalPackage}'
        require 'mithic'
      '';
    extraPackages = me.extraPackages;
  };

}
