{ pkgs, ... }: {
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.idris2-nvim;
    config = "require 'idris2'.setup {}";
  }];
  home.packages = [ pkgs.idris2 ];
}
