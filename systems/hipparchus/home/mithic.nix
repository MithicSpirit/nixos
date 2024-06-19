{ config, pkgs, root, ... }: {

  imports = [
    /${root}/home/bat
    /${root}/home/bemenu
    /${root}/home/git
    /${root}/home/gpg
    /${root}/home/kitty
    # /${root}/home/librewolf
    /${root}/home/mpv
    /${root}/home/neovim
    /${root}/home/newsboat
    /${root}/home/sway
    /${root}/home/xdg
    /${root}/home/zathura
    /${root}/home/cliphist
    /${root}/home/scripts
    /${root}/home/dunst
    /${root}/home/kdeconnect
    /${root}/home/fastfetch
    /${root}/home/theme
    /${root}/home/man
    /${root}/home/less
    /${root}/home/zsh
    /${root}/home/language
    /${root}/home/btop
    /${root}/home/gaming
  ];

  programs.home-manager.enable = true;

  wayland.windowManager.sway.extraConfig = ''
    output eDP-2 {
      mode 2560x1600@165Hz
      scale 1.25
      adaptive_sync on
    }
  '';

  systemd.user.sessionVariables = config.home.sessionVariables;
  home.file.".profile" = {
    enable = true;
    text = ''
      . ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh
      if [ -z "$__DBUS_ENVIRON_UPDATED" ]; then
        export __DBUS_ENVIRON_UPDATED=1
        dbus-update-activation-environment --systemd --all
      fi
    '';
  };

  home = {
    username = "mithic";
    homeDirectory = "/home/${config.home.username}";

    # TODO: ranger and rifle replacement(s?)

    packages = with pkgs; [
      mediainfo
      rmtrash
      ugrep

      du-dust
      duf
      eza
      fd
      just
      procs
      ripgrep
      sd

      gnome.gnome-characters
      pcmanfm
      swayimg
      thunderbird
      vlc
      wev
      xdragon
      xorg.xev
      xorg.xprop
      xournalpp

      firefox
      librewolf
      tor-browser
      ungoogled-chromium

      libqalculate
      qalculate-gtk

      texliveFull
      tectonic
    ];
    enableDebugInfo = true;
  };

  home.stateVersion = "24.05"; # WARNING: do not change
}
