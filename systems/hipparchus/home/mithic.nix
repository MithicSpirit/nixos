{
  config,
  pkgs,
  root,
  ...
}:
{

  imports = builtins.map (path: root + /home + path) [
    /bat
    /bemenu
    /git
    /gpg
    /kitty
    /librewolf # TODO: waiting on #5684
    /mpv
    /neovim
    /newsboat
    /sway
    /xdg
    /zathura
    /cliphist
    /scripts
    /dunst
    /kdeconnect
    /fastfetch
    /theme
    /man
    /less
    /zsh
    /language
    /btop
    /gaming
    /dev
    /ssh
    /desktop
    /rclone
  ];

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # use-xdg-base-directories = true;
  };

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

    # TODO: ranger and rifle replacement(s?) yazi?

    packages = with pkgs; [
      mediainfo
      rmtrash
      ugrep
      yazi
      (parallel-full.override { willCite = true; })

      du-dust
      duf
      eza
      fd
      procs
      ripgrep
      sd

      pcmanfm
      swayimg
      xdragon
      xournalpp
      libreoffice-fresh

      firefox
      librewolf
      tor-browser
      ungoogled-chromium

      libqalculate
      qalcmenu
      qalculate-gtk
    ];
    enableDebugInfo = true;
  };

  home.stateVersion = "24.05"; # WARNING: do not change
}
