{ pkgs, ... }:
let me = pkgs.mithic-nvim;
in {

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = [ me ] ++ me.vimPlugins;
    extraLuaConfig = "require 'mithic'";
    extraPackages = me.extraPackages;
  };

}
