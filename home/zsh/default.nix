{ config, pkgs, ... }:
let
  ZDOTDIR = "${config.xdg.configHome}/zsh";
  session-vars =
    "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh";
in {

  home.file."${ZDOTDIR}/.zshrc" = {
    enable = true;
    text = ''
      SYSTEMPLUGINS=( # keep in sync with pkgs below
        '${pkgs.zsh-autosuggestions}/zsh-autosuggestions.zsh'
        '${pkgs.zsh-completions}/zsh-completions.plugin.zsh'
        '${pkgs.zsh-history-substring-search}/zsh-history-substring-search.zsh'
        '${pkgs.zsh-powerlevel10k}/powerlevel10k.zsh-theme'
        '${pkgs.zsh-syntax-highlighting}/zsh-syntax-highlighting.zsh'
      )
      CONFDIR='${./config}'
      HISTFILE='${config.xdg.cacheHome}/zsh/history'
      source "$CONFDIR/zshrc"
    '';
  };

  home.file."${ZDOTDIR}/.zshenv" = {
    enable = true;
    text = "source ${session-vars}";
  };

  home.file.".zshenv" = { # TODO: symlink to above
    enable = true;
    text = "source ${session-vars}";
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
