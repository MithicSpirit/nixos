{ config, pkgs, root, overlays, ... }: {

  imports = [
    /${root}/home/bat
    /${root}/home/bemenu
    /${root}/home/fonts
    /${root}/home/git
    /${root}/home/gpg
    /${root}/home/kitty
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
  ];

  programs.home-manager.enable = true;

  nixpkgs.overlays = overlays;

  home = {
    username = "mithic";
    homeDirectory = "/home/${config.home.username}";

    # TODO: ranger and rifle replacement(s?)

    packages = with pkgs; [
      rmtrash
      fasd
      mediainfo
      ugrep
      yt-dlp

      eza
      fd
      ripgrep
      duf
      du-dust
      procs
      sd

      pcmanfm
      xdragon
      gnome.gnome-characters
      thunderbird
      vlc
      swayimg
      wev
      xorg.xev
      xorg.xprop
      xournalpp

      librewolf
      firefox
      ungoogled-chromium
      tor-browser

      iosevka-mithic
      overpass
      lmodern
      lmmath
      noto-fonts
      noto-fonts-cjk-sans
      twemoji-color-font

      libqalculate
      qalculate-gtk

      texliveFull
      tectonic
    ];
    enableDebugInfo = true;
  };

  home.stateVersion = "24.05"; # WARNING: do not change
}
