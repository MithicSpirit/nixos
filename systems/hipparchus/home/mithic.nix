{
  config,
  pkgs,
  root,
  ...
}: {
  imports = builtins.map (path: root + /home + path) [
    /bat
    /bemenu
    /git
    /gpg
    /kitty
    /ghostty
    /librewolf
    /thunderbird
    /mpv
    /neovim
    /newsboat
    /niri # or hyprland, sway
    /swayimg
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

  wayland.windowManager = {
    sway.extraConfig = ''
      output eDP-2 {
        mode 2560x1600@165Hz
        scale ${toString (160 / 120.)}
        adaptive_sync on
        color_profile icc ${../BOE_CQ_NE160QDM-NZ6-icc-profile.icm}
      }
    '';
    hyprland.settings = {
      monitorv2 = [
        {
          output = "eDP-2";
          mode = "2560x1600@165";
          position = "0x0";
          scale = toString (160 / 120.);
          vrr = 1;
        }
      ];
      render = {
        cm_fs_passthrough = 0;
        cm_auto_hdr = 0;
      };
      workspace = [
        "1, monitor:eDP-2, default:true"
        "r[2-10], monitor:eDP-2"
      ];
    };
    niri.settings = {
      output = let
        pos = x: y: {_props = {inherit x y;};};
      in [
        {
          _args = ["eDP-2"];
          mode = "2560x1600@165.000";
          scale = 1.33;
          variable-refresh-rate = [];
          focus-at-startup = [];
          position = pos 0 0;
        }
        {
          _args = ["LG Electronics LG FULL HD 0x0006B85D"];
          mode = "1920x1080@74.973";
          scale = 1;
          position = pos (-(1920 + 40)) 0;
        }
      ];
    };
  };
  services.dunst.settings.global = {
    monitor = "eDP-2";
    follow = "none";
  };

  systemd.user.settings.Manager = {
    DefaultTimeoutStopSec = "30s";
  };

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
      curlFull
      dust
      duf
      eza
      fd
      fselect
      mediainfo
      qpdf
      nix-output-monitor
      procs
      ripgrep
      ripgrep-all
      rmtrash
      sd
      termdown
      ugrep
      yazi
      (parallel-full.override {willCite = true;})

      pcmanfm
      dragon-drop
      xournalpp
      onlyoffice-desktopeditors

      libreoffice-fresh
      hunspell
      hunspellDicts.en-us-large
      hyphen
      hyphenDicts.en-us

      ungoogled-chromium
      firefox
      brave
      tor-browser

      libqalculate
      qalcmenu
      qalculate-gtk
    ];
    enableDebugInfo = true;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
    ];
  };

  services.blueman-applet.enable = true;

  services.mpris-proxy = {
    enable = true;
    package = pkgs.bluez-mpris-proxy;
  };

  services.podman = {
    enable = true;
    enableTypeChecks = true;
    autoUpdate.enable = false;
    settings = {
      containers.engine.detach_keys = "ctrl-q,ctrl-z";
    };
  };

  services.network-manager-applet.enable = true;
  services.pasystray = {
    enable = true;
    extraOptions = [
      "--volume-inc=5"
      "--notify=sink"
      "--notify=source"
    ];
  };
  services.playerctld.enable = true;

  programs.imv.enable = true;

  home.stateVersion = "24.05"; # XXX: do not change
}
