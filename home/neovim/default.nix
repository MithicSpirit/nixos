{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    plugins = [ pkgs.mithic-nvim ];
  };
}
