{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = telescope-nvim;
        type = "fennel";
        config = "(require :custom.telescope)";
      }
      telescope-zf-native-nvim
      telescope-file-browser-nvim
    ];
    extraPackages = [ pkgs.fd ];
  };
}
