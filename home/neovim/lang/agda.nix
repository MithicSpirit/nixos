{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = cornelis;
      type = "fennel";
      config = ''
        (set vim.g.cornelis_use_global_binary 1)
        (require :custom.cornelis)
      '';
    }
    vim-textobj-user
    nvim-hs-vim
  ];
  home.packages = with pkgs.unstable;
    with agdaPackages; [
      agda
      cornelis
      standard-library
      cubical
      agda-prelude
      _1lab
    ];
}
