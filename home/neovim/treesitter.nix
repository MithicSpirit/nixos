{ pkgs, ... }: {
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.nvim-treesitter;
    type = "fennel";
    config = "(require :custom.treesitter)";
  }] ++ (with builtins;
    filter (p: typeOf p == "set")
    (attrValues pkgs.vimPlugins.nvim-treesitter-parsers));
}
