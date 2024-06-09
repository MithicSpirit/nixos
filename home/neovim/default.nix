{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = let me = pkgs.mithic-nvim; in [ me ] ++ me.vimPlugins;
    extraLuaConfig = "require 'mithic'";
  };
}
