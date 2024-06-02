{ pkgs, ... }: {
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.Coqtail ];
    extraConfigLua = "vim.g.coqtail_map_prefix = '<localleader>'";
  };
}
