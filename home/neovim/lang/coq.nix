{ pkgs, ... }: {
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.Coqtail;
    type = "fennel";
    config = ''(set vim.g.coqtail_map_prefix "<localleader>")'';
  }];
  home.packages = [ pkgs.coq ];
}
