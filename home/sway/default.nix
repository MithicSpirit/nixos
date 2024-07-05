{ config, pkgs, root, ... }:
let wallpaper = import /${root}/common/wallpaper;
in {

  # TODO: bar
  # TODO: .login
  # TODO: device-specific output config
  wayland.windowManager.sway = {
    enable = true;
    # package = pkgs.swayfx;
    config = null;
    extraConfig = ''
      set $confdir ${./confdir}
      set $wallpaper ${wallpaper}
      include $confdir/config
    '';
    xwayland = true;

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
          font = "Iosevka Mithic 12";
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
    text = ''
      #!/usr/bin/env sh

      if [ -z "$WAYLAND_DISPLAY" ] && [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
              resway() {
                      while ! sway >>/tmp/sway.log 2>&1
                      do
                              notify-send -w 'Sway restart' &
                      done
              }
              exec resway
      fi

      # vi: ft=sh
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
      image = builtins.toString wallpaper;
      scaling = "fill";
      font = "Iosevka Mithic";
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

  services.swayidle = let
    lock = 600;
    notify-send = "${pkgs.libnotify}/bin/notify-send";
    loginctl = "${pkgs.systemd}/bin/loginctl";
    sleep = "${pkgs.coreutils}/bin/sleep";
    pkill = "${pkgs.procps}/bin/pkill";
    dunstctl = "${config.services.dunst.package}/bin/dunstctl";
    swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
    swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  in {
    enable = true;
    extraArgs = [ "-w" "idlehint" "${builtins.toString (lock / 2)}" ];
    timeouts = [
      {
        timeout = lock - 31;
        command = "${notify-send} -et 30000";
      }
      {
        timeout = lock - 1;
        command = "${dunstctl} set-paused true";
        resumeCommand = "${dunstctl} set-paused false";
      }
      {
        timeout = lock;
        command = "${loginctl} lock-session";
      }
      {
        timeout = lock + 15;
        command = ''${swaymsg} "output * power off"'';
        resumeCommand = ''${swaymsg} "output * power on"'';
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = ''
          ${loginctl} lock-session; ${swaymsg} "output * power off"; ${sleep} 0.1'';
      }
      {
        event = "after-resume";
        command = ''${sleep} 0.2; ${swaymsg} "output * power on"'';
      }
      {
        event = "lock";
        command = "${swaylock} -f; sleep 0.1";
      }
      {
        event = "unlock";
        command = ''${pkill} -USR1 "^swaylock$"'';
      }
    ];
  };

  xdg.portal = {
    config.sway.default = [ "wlr" "gtk" ];
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
  };

  home.packages = with pkgs; [
    swaybg
    sway-contrib.grimshot
    brightnessctl
    playerctl
  ];
}
