{ pkgs, ... }: {
  programs.neovim.plugins = [
    {
      plugin = pkgs.vimPlugins.lean-nvim;
      config = "require 'lean'.setup {}";
    }
    pkgs.vimPlugins.plenary-nvim # dep
  ];
  home.packages = [ pkgs.elan ];
}
