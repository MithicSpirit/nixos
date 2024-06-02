{ pkgs, ... }: {
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.Coqtail;
    config = "vim.g.coqtail_map_prefix = '<localleader>'";
  }];
  home.packages = [ pkgs.coq ];
}
