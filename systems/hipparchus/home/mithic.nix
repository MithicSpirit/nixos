{
  config,
  pkgs,
  root,
  ...
}:
{

  imports = [
    /${root}/home/bat
    /${root}/home/bemenu
    /${root}/home/git
    /${root}/home/gpg
    /${root}/home/kitty
    /${root}/home/librewolf # TODO: waiting on #5684
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
    /${root}/home/dev
    /${root}/home/ssh
    /${root}/home/desktop
    /${root}/home/rclone
  ];

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    use-xdg-base-directories = true;
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
