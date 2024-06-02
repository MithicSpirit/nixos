{ pkgs, ... }: {
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.indent-blankline-nvim ];
    extraConfigLua = "require 'mithic.ibl'";
  };
}
