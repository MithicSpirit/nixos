{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.hop-nvim ];
    extraConfigLua = "require 'mithic.hop'";
  };
}
