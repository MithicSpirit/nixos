{ pkgs, ... }: {
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.nvim-treesitter;
    config = "require 'custom.treesitter'";
  }] ++ (with builtins;
    filter (p: typeOf p == "set")
    (attrValues pkgs.vimPlugins.nvim-treesitter-parsers));
}
