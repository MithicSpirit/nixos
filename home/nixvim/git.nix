{ pkgs, ... }: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [ vim-fugitive gitsigns-nvim ];
    extraConfigLua = "require 'mithic.git'";
  };
}
