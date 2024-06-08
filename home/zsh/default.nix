{ config, pkgs, ... }:
let
  ZDOTDIR = "${config.xdg.configHome}/zsh";
  zsh_histdir = "${config.xdg.cacheHome}/zsh";
in {

  home.file = let
    symlink = file: {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/${file}";
    };
  in {
    ".zshenv" = symlink ".profile";
    "${ZDOTDIR}/.zshenv" = symlink ".profile";
    "${ZDOTDIR}/.zlogin" = symlink ".login";

    "${zsh_histdir}/.keep" = {
      enable = true;
      text = "";
    };

    "${ZDOTDIR}/.zshrc" = {
      enable = true;
      text = ''
        SYSTEMPLUGINS=( # keep in sync with pkgs below
          '${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh'
          '${pkgs.zsh-completions}/share/zsh-completions/zsh-completions.plugin.zsh'
          '${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh'
          '${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme'
          '${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
        )
        CONFDIR='${./config}'
        HISTFILE='${zsh_histdir}/history'
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

  home.sessionVariables = { inherit ZDOTDIR; };

  # TODO: setup command-not-found

}
