{ pkgs, ... }: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-zf-native-nvim
      telescope-file-browser-nvim
    ];
    extraConfigLua = "require 'mithic.telescope'";
    extraPackages = [ pkgs.fd ];
  };
}
