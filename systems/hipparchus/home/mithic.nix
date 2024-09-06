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
  ];

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";

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
      rclone

      du-dust
      duf
      eza
      fd
      procs
      ripgrep
      sd

      pcmanfm
      qalcmenu
      swayimg
      xdragon
      xournalpp

      firefox
      librewolf
      tor-browser
      ungoogled-chromium

      libqalculate
      qalculate-gtk
    ];
    enableDebugInfo = true;
  };

  systemd.user.timers."rclone-school" = {
    Unit.Description = "Resynchronize school directory with rsync often";
    Timer = {
      OnUnitActiveSec = "15m";
      OnCalendar = "*-*-* *:00/15:00";
      AccuracySec = "1m";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services."rclone-school" = {
    Unit = {
      Description = "Resynchronize school directory with rsync using standard script";
      Wants = "network-online.target";
      After = "network-online.target";
    };
    Service = {
      Type = "oneshot";
      ExecStartPre = "sleep 5";
      ExecStart = "'${config.xdg.userDirs.documents}/school/rclone-sync' --dry-run";
      # TODO: remove --dry-run
    };
  };

  home.stateVersion = "24.05"; # WARNING: do not change
}
