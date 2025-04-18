{
  config,
  pkgs,
  root,
  lib,
  hostConfig,
  ...
}:
let
  wallpaper = import (root + /common/wallpaper);
in
{

  # TODO: bar
  # TODO: .login
  # TODO: device-specific output config
  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraConfig =
      let
        status = lib.getExe (
          pkgs.writeCBin "swaybar-status" (builtins.readFile ./swaybar-status.c)
        );
      in
      ''
        set $confdir ${./cfg}
        set $wallpaper ${wallpaper}
        include $confdir/config
        bar 0 status_command ${status}
      '';
    xwayland = true;

    # package = pkgs.swayfx;
    # checkConfig = false; # must be disabled for swayfx

    systemd = {
      enable = true;
      xdgAutostart = false;
    };
    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    swaynag = {
      enable = true;
      settings = {
        "<config>" = {
          font = "${builtins.head config.fonts.fontconfig.defaultFonts.monospace} 12";
          edge = "top";
          layer = "overlay";
          background = "2e3440";
          button-background = "3b4252";
          details-background = "3b4252";
          text = "eceff4";
          button-text = "eceff4";
          border = "d8dee9";
          border-botton = "d8dee9";
        };
        warning = {
          text = "ebcb8b";
          button-text = "ebcb8b";
          border = "ebcb8b";
          border-botton = "ebcb8b";
        };
        error = {
          text = "bf616a";
          button-text = "bf616a";
          border = "bf616a";
          border-botton = "bf616a";
        };
      };
    };
  };

  home.file.".login" = {
    enable = true;
    executable = true;
    text = # sh
      ''
        #!/usr/bin/env sh
        [ -z "$WAYLAND_DISPLAY" -a -z "$DISPLAY" -a "$XDG_VTNR" -eq 1 ] \
          && exec sway >>/tmp/sway.log 2>&1
        :
      '';
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # ignore-empty-password = true; # annoying with fprintd
      show-failed-attempts = true;
      show-keyboard-layout = true;
      indicator-caps-lock = true;
      image = "${wallpaper}";
      scaling = "fill";
      font = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
      clock = true;
      indicator-idle-visible = true;
      timestr = "%H:%M:%S";
      datestr = "%a, %b %d, %Y";
      grace-no-touch = true;

      bs-hl-color = "ebcb8b";
      caps-lock-bs-hl-color = "ebcb8b";
      caps-lock-key-hl-color = "88c0d0";
      inside-color = "2e3440a0";
      inside-clear-color = "2e3440a0";
      inside-caps-lock-color = "2e3440a0";
      inside-ver-color = "2e3440a0";
      inside-wrong-color = "2e3440a0";
      key-hl-color = "88c0d0";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "eceff4";
      line-color = "2e3440";
      line-clear-color = "2e3440";
      line-caps-lock-color = "2e3440";
      line-wrong-color = "2e3440";
      ring-color = "a3be8c";
      ring-clear-color = "ebcb8b";
      ring-caps-lock-color = "d08770";
      ring-ver-color = "8fbcbb";
      ring-wrong-color = "bf616a";
      separator-color = "2e3440";
      text-color = "eceff4";
      text-clear-color = "ebcb8b";
      text-caps-lock-color = "d08770";
      text-ver-color = "8fbcbb";
      text-wrong-color = "bf616a";

      # swaylock-effects
      effect-blur = "24x4"; # TODO: effects-scale?
    };
  };

  services.swayidle =
    let
      lock-time = 600;
      alert-time = 30;
      notify-send = lib.getExe pkgs.libnotify;
      loginctl = lib.getExe' hostConfig.systemd.package "loginctl";
      sleep = lib.getExe' pkgs.coreutils "sleep";
      pkill = lib.getExe' pkgs.procps "pkill";
      dunstctl = lib.getExe' config.services.dunst.package "dunstctl";
      swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
      swaylock = lib.getExe config.programs.swaylock.package;
    in
    {
      enable = true;
      extraArgs = [
        "-w"
        "idlehint"
        "${builtins.toString (lock-time / 2)}"
      ];
      timeouts = [
        {
          timeout = lock-time - alert-time - 1;
          command = "${notify-send} -et ${toString (alert-time * 1000)} -u low -a swayidle 'Locking soon'";
        }
        {
          timeout = lock-time - 1;
          command = "${dunstctl} set-paused true";
          resumeCommand = "${dunstctl} set-paused false";
        }
        {
          timeout = lock-time;
          command = "${loginctl} lock-session";
        }
        {
          timeout = lock-time + 15;
          command = ''${swaymsg} "output * power off"'';
          resumeCommand = ''${swaymsg} "output * power on"'';
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = ''${loginctl} lock-session; ${swaymsg} "output * power off"; ${sleep} 0.2'';
        }
        {
          event = "after-resume";
          command = ''${sleep} 0.2; ${swaymsg} "output * power on"'';
        }
        {
          event = "lock";
          command = "${swaylock} -f; ${sleep} 0.1";
          # TODO: sudo -K
        }
        {
          event = "unlock";
          command = ''${pkill} -USR1 "^swaylock$"'';
        }
      ];
    };

  xdg.portal = {
    config.sway = {
      default = [
        "wlr"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  home.packages = with pkgs; [
    swaybg
    sway-contrib.grimshot
    brightnessctl
    playerctl
    jq # swaytile
  ];

  services.gammastep = {
    enable = true;
    enableVerboseLogging = true;
    provider = "geoclue2";
    tray = true;

    temperature.day = 5500;
    temperature.night = 3600;
    settings.general = {
      brightness-day = 1.0;
      brightness-night = 1.0;

      fade = true;
      transition = true;
    };
  };

  home.sessionVariables = {
    "NIXOS_OZONE_WL" = "1";
  };

}
