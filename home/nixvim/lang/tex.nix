{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.vimtex ];
    extraConfigLua = "require 'mithic.vimtex'";
  };
}
