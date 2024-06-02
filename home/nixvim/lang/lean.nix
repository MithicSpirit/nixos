{ pkgs, ... }: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [ lean-nvim plenary-nvim ];
    extraPackages = [ pkgs.elan ];
    extraConfigLua = "require 'lean'.setup {}";
  };
}
