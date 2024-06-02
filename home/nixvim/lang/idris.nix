{ pkgs, ... }: {
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.idris2-nvim ];
    extraConfigLua = "require 'idris2'.setup {}";
  };
}
