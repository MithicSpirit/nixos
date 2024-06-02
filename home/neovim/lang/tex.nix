{ pkgs, ... }: {
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.vimtex;
    type = "fennel";
    config = "(require :custom.vimtex)";
  }];
  home.packages = [ pkgs.texliveFull ];
}
