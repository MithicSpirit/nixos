{ pkgs, ... }: {
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.vimtex;
    config = "require 'custom.vimtex'";
  }];
  home.packages = [ pkgs.texliveFull ];
}
