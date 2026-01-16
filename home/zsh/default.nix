{
  config,
  pkgs,
  ...
}: let
  zdotdir = "${config.xdg.configHome}/zsh";
  histdir = "${config.xdg.cacheHome}/zsh";
in {
  home.file = let
    symlink = file: {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${file}";
    };
  in {
    ".zshenv" = symlink ".profile";
    "${zdotdir}/.zshenv" = symlink ".profile";
    "${zdotdir}/.zlogin" = symlink ".login";

    "${histdir}/.keep" = {
      enable = true;
      text = "";
    };

    "${zdotdir}/.zshrc" = {
      enable = true;
      text =
        /*
        sh
        */
        ''
          SYSTEMPLUGINS=( # keep in sync with pkgs below
            '${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
            '${pkgs.zsh-completions}/share/zsh-completions/zsh-completions.plugin.zsh'
            '${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh'
            '${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme'
            '${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
          )
          CONFDIR='${./config}'
          HISTFILE='${histdir}/history'
          source "$CONFDIR/zshrc"
        '';
    };
  };

  home.packages = with pkgs; [
    zsh
    # plugins (keep in sync with SYSTEMPLUGINS above)
    zsh-powerlevel10k # TODO: investigate replacement
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    zsh-syntax-highlighting
    # misc
    nix-zsh-completions
    zoxide # TODO: my own thing
  ];

  programs.direnv = {
    enable = true;
    config = {}; # TODO
    nix-direnv.enable = true;
  };

  home.sessionVariables."ZDOTDIR" = zdotdir;
}
