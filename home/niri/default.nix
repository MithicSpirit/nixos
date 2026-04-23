{
  pkgs,
  lib,
  root,
  config,
  ...
}: let
  niri-pkg = pkgs.niri;
  wallpaper = import (root + /common/wallpaper);
  colors = import (root + /common/colorscheme.nix);
in {
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  home.file."niri-power-menu.sh".source = ./power-menu.sh;

  home.file.".login" = {
    enable = true;
    executable = true;
    text =
      # sh
      ''
        #!/usr/bin/env sh
        if [ -z "$WAYLAND_DISPLAY" -a -z "$DISPLAY" -a "$XDG_VTNR" -eq 1 -a -z "$LOGGED_IN" ]
        then LOGGED_IN=1 exec ${./startup.sh}
        fi
      '';
  };

  systemd.user.services."niri" = {
    Service = {
      ExecStart = "${lib.getExe niri-pkg} --session";
      ExecReload = "${lib.getExe niri-pkg} msg action load-config-file";
      Type = "notify";
      Slice = "session.slice";
    };
    Unit = {
      Description = "A scrollable-tiling Wayland compositor";
      BindsTo = "graphical-session.target";
      Before = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
      X-SwitchMethod = "reload";
      X-ReloadTriggers = [
        config.xdg.configFile."niri/config.kdl".source
      ];
    };
  };

  xdg.portal = {
    config.niri = {
      default = ["gtk" "gnome"];
      "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  home.packages = with pkgs; [
    niri-pkg
    xwayland-satellite
    brightnessctl
    playerctl
  ];

  services.gammastep = {
    enable = true;
    enableVerboseLogging = true;
    provider = "geoclue2";
    tray = true;

    temperature.day = 5500;
    temperature.night = 3000;
    settings.general = {
      brightness-day = 1.0;
      brightness-night = 1.0;

      fade = true;
      transition = true;
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = {
        monitor = "";
        path = "${wallpaper}";
      };
    };
  };

  services.swayidle = let
    lock-time = 600;
    alert-time = 30;
    off-time = 60;
  in {
    enable = true;
    extraArgs = [
      "-w"
      "idlehint"
      "${toString (lock-time + 5)}"
    ];
    timeouts = [
      {
        timeout = lock-time - alert-time;
        command = "brightnessctl -s set 0";
        resumeCommand = "brightnessctl -r";
      }
      {
        timeout = lock-time;
        command = "loginctl lock-session";
      }
      {
        timeout = lock-time + off-time;
        command = "niri msg action power-off-monitors";
        resumeCommand = "niri msg action power-on-monitors";
      }
    ];
    events = {
      before-sleep = "loginctl lock-session";
      after-resume = "niri msg action power-on-monitors"; # TODO: force-idle
      lock = "sudo -K; if ! pidof -q hyprlock; then hyprlock & fi";
      unlock = "killall -USR1 hyprlock";
    };
  };
  systemd.user.services."swayidle".Service.Environment = lib.mkForce [];

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      auth = {
        fingerprint.enabled = true;
      };

      animations.enabled = false;
      background = {
        path = "${wallpaper}";
        color = colors.rgb.floor;
        blur_size = 6;
        blur_passes = 3;
      };
      input-field = {
        size = "160,160";
        outline_thickness = 10;
        hide_input = true;
        invert_numlock = true;

        outer_color = "rgba(${colors.raw.lower}dd)";
        inner_color = "rgba(${colors.raw.bg}aa)";
        hide_input_base_color = colors.rgb.accent;
        check_color = colors.rgb.warning;
        fail_color = colors.rgb.bad;
        capslock_color = colors.rgb.advanced;
        numlock_color = colors.rgb.advanced;
        bothlock_color = colors.rgb.advanced;

        font_family = "monospace";
        fail_text = "$ATTEMPTS";
        placeholder_text = "";
      };
    };
  };

  programs.waybar = let
    icon-size = 16;
  in {
    enable = true;
    systemd.enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 24;
        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];
        modules-right = [
          "tray"
          "custom/status"
        ];

        "niri/workspaces" = {
          format-named = "{name}";
          format = "#{index}";
          sort-by = "id";
          hide-empty = true;
        };

        "niri/window" = {
          inherit icon-size;
          separate-outputs = true;
          icon = true;
          format = "{title} ({app_id})";
          rewrite = {
            " \\(\\)" = "";
          };
        };

        "custom/status" = {
          exec = lib.getExe (
            pkgs.writeCBin "niri-waybar-status" (builtins.readFile ./status.c)
          );
        };

        "tray" = {
          inherit icon-size;
          reverse-direction = true;
        };
      }
    ];

    style =
      # css
      ''
        window#waybar {
          font-size: 9pt;
          font-family: monospace;
        }
        tooltip, #tray, #window {
          font-family: sans-serif;
        }

        window#waybar {
          background: ${colors.hash.floor};
          color: ${colors.hash.fg};
        }
        #custom-status {
          background: ${colors.hash.bg};
        }
        #workspaces button {
          color: ${colors.hash.lower};
          background: ${colors.hash.floor};
        }
        #workspaces button.current_output {
          color: ${colors.hash.fg};
          background: ${colors.hash.bg};
        }
        #workspaces button.active {
          color: ${colors.hash.colored};
        }
        #workspaces button.empty {
          color: ${colors.hash.fake};
        }
        #workspaces button.focused {
          color: ${colors.hash.accent};
          background: ${colors.hash.shadow};
        }

        #window {
          padding: 0 0.25em;
        }
        #window > image {
          padding-top: 1pt;
        }
        #window > label {
          padding-top: 2pt;
        }
        #windowcount {
          padding: 0 0.25em;
        }
        #workspaces {
          padding-right: 0.25em;
        }
        #workspaces button {
          padding: 1px 0.5em;
          border-radius: 0;
          border-width: 0;
        }
        #workspaces button > box {
          min-height: 1.5em;
          min-width: 1.5em;
        }
        #tray > widget > image {
          padding: 0 0.25em;
        }
        #custom-status {
          padding: 0 0.5em;
        }
      '';
  };
}
