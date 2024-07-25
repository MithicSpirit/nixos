{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.trouble-nvim ]; # FIXME: dev
    extraConfigLua = "require 'mithic.trouble'";
  };
}
