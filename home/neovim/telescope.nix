{ pkgs, ... }: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-zf-native-nvim
      telescope-file-browser-nvim
    ];
    extraLuaConfig = "require 'custom.telescope'";
    extraPackages = [ pkgs.fd ];
  };
}
