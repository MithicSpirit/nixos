{ pkgs, ... }: {
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.nvim-treesitter;
    config = "require 'custom.treesitter'";
  }] ++ (builtins.attrValues pkgs.vimPlugins.nvim-treesitter-parsers);
}
