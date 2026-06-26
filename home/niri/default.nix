{
  pkgs,
  lib,
  root,
  config,
  inputs,
  ...
}: let
  wallpaper = import (root + /common/wallpaper);
  colors = import (root + /common/colorscheme.nix);
in {
  imports = [inputs.niri.homeModules.niri-nix];

  wayland.windowManager.niri = {
    enable = true;
    package = pkgs.niri;
    settings = lib.mkMerge [
      {
        # misc
        input = {
          keyboard = {
            numlock = [];
            xkb.layout = "us,gr";
            xkb.options = "grp:win_space_toggle,compose:rctrl,lv3:ralt_switch";
          };
          touchpad = {
            accel-speed = -0.3;
            accel-profile = "adaptive";
            scroll-factor = 0.5;
            natural-scroll = [];
            tap = [];
            dwt = [];
            click-method = "button-areas";
            # TODO: keybind for off
          };
          mouse = {
            accel-speed = -0.22;
            accel-profile = "flat";
            scroll-factor = 1.0; # NOTE: I like 0.8, but changing this breaks wine
          };
          touch.off = [];

          focus-follows-mouse._props.max-scroll-amount = "0%";
          warp-mouse-to-focus = [];
          only-focus-on-click = [];
        };

        layout = {
          gaps = 6;
          # logical, so assume 1920x1080
          struts = {
            # ~3%
            left = 60;
            right = 60;
            top = 0;
            bottom = 0;
          };

          border = {
            width = 2;
            active-color = colors.hash.accent;
            inactive-color = colors.hash.bg;
            urgent-color = colors.hash.advanced;
          };
          focus-ring.off = [];
          shadow.off = [];

          tab-indicator = {
            width = 4;
            gap = 2;
            gaps-between-tabs = 2;
            hide-when-single-tab = [];
            place-within-column = [];
            inactive-color = colors.hash.fake;
          };

          background-color = colors.hash.floor;

          center-focused-column = "never";
          always-center-single-column = [];

          default-column-display = "tabbed";

          preset-column-widths._children = [
            {proportion = 0.7;}
            {proportion = 0.5;}
            {proportion = 0.3;}
          ];
          default-column-width = {
            _props.maximize = true;
            proportion = 0.5;
          };

          preset-window-heights._children = [
            {proportion = 0.8;}
            {proportion = 0.5;}
            {proportion = 0.2;}
          ];
        };
        environment = {
          CLUTTER_BACKEND = "wayland";
          NIXOS_OZONE_WL = "1";

          SDL_VIDEODRIVER = "wayland,x11";
          SDL_AUDIODRIVER = "pipewire,pulseaudio,pulse";

          QT_QPA_PLATFORM = "wayland;xcb";
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        };

        # TODO: overview?
        recent-windows.off = [];

        gestures = {
          hot-corners.off = [];
        };
        animations = {
          window-open = {
            duration-ms = 150;
            curve = "ease-out-expo";
          };
          window-close = {
            duration-ms = 150;
            curve = "ease-out-quad";
          };
          screenshot-ui-open = {
            duration-ms = 200;
            curve = "ease-out-quad";
          };
          workspace-switch.spring._props = {
            damping-ratio = 1.1;
            stiffness = 3000;
            epsilon = 0.001;
          };
          horizontal-view-movement.spring._props = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
          window-movement.spring._props = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
          window-resize.spring._props = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
          config-notification-open-close.spring._props = {
            damping-ratio = 0.6;
            stiffness = 1000;
            epsilon = 0.001;
          };
          exit-confirmation-open-close.spring._props = {
            damping-ratio = 0.6;
            stiffness = 500;
            epsilon = 0.01;
          };
          overview-open-close.spring._props = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
          recent-windows-close.spring._props = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.001;
          };
        };

        hotkey-overlay.skip-at-startup = [];
        prefer-no-csd = [];
        prevent-idle-inhibit = [];
        screenshot-path = "${config.xdg.userDirs.pictures}/screenshots/%Y-%m-%d_%H-%M-%S.png";
        xwayland-satellite.path = "${lib.getExe pkgs.xwayland-satellite}";

        window-rule = [
          {
            ignore-client-size = true;
            match._props.is-floating = false;
          }
          {
            open-floating = true;
            match =
              (map (x: {_props.app-id = "^${x}$";}) [
                "xdg-desktop-portal(|-.*)"
                "qalculate-gtk"
                "Matplotlib"
                "swayimg(|_.*)"
                "dev-nohus-rift-MainKt"
              ])
              ++ (map (x: {_props = x;}) [
                {
                  app-id = "^librewolf$";
                  title = "^Library$";
                }
                {
                  app-id = "^librewolf$";
                  title = "^Picture-in-Picture$";
                }
                {
                  app-id = "^thunderbird$";
                  title = "^$"; # events
                }
                {
                  app-id = "^thunderbird$";
                  title = "^Check Spelling$";
                }
              ]);
          }
          {
            open-floating = true;
            match._props.app-id = "^steam$";
            exclude._props.title = "^Steam$";
          }
          {
            variable-refresh-rate = true;
            force-render = true;
            force-render-fps = 15;
            match =
              [
                {_props.xdg-tag = "^proton-game$";}
              ]
              ++ map (x: {_props.app-id = "^${x}$";}) [
                "^steam_app_.*$"
                "^dota2$"
                "^Terraria\\.bin\\.x86_64$"
                "^factorio$"
                "^openttd$"
                "^net-runelite-client-RuneLite$"
              ];
          }
        ];
        layer-rule = [
          {
            block-out-from = "screencast";
            match = map (x: {_props.namespace = "^${x}$";}) [
              "waybar"
              "menu"
              "notifications"
            ];
          }
          {
            priority = 10;
            match._props.namespace = "^notifications$";
          }
        ];
        binds = lib.mergeAttrsList [
          (builtins.mapAttrs (_: x: x // {_props.repeat = false;}) {
            "Mod+Return" = {spawn-sh = "bemenu-run -p Run </dev/null >>/tmp/exec.log 2>&1";};
            "Mod+Shift+Return" = {spawn-sh = "$TERMINAL </dev/null >>/tmp/exec.log 2>&1";};
            "Mod+Ctrl+Return" = {spawn-sh = "$BROWSER </dev/null >>/tmp/exec.log 2>&1";};
            "Mod+Ctrl+Shift+Return" = {
              spawn-sh = "bemenu -p 'niri msg' </dev/null 2>>/tmp/exec.log | xargs niri msg >>/tmp/exec.log 2>&1";
            };

            "Mod+Shift+X" = {close-window = [];};
            "Mod+Ctrl+X" = {spawn = ["loginctl" "lock-session"];};
            "Mod+Ctrl+Shift+X" = {spawn = "${./power-menu.sh}";};

            "Mod+J" = {focus-window-down = [];};
            "Mod+K" = {focus-window-up = [];};
            "Mod+H" = {focus-column-left = [];};
            "Mod+L" = {focus-column-right = [];};

            "Mod+Shift+J" = {move-window-down = [];};
            "Mod+Shift+K" = {move-window-up = [];};
            "Mod+Shift+H" = {move-column-left = [];};
            "Mod+Shift+L" = {move-column-right = [];};

            "Mod+Ctrl+J" = {focus-workspace-down = [];};
            "Mod+Ctrl+K" = {focus-workspace-up = [];};
            "Mod+Ctrl+H" = {focus-monitor-left = [];};
            "Mod+Ctrl+L" = {focus-monitor-right = [];};

            "Mod+Ctrl+Shift+J" = {move-window-to-workspace-down = [];};
            "Mod+Ctrl+Shift+K" = {move-window-to-workspace-up = [];};
            "Mod+Ctrl+Shift+H" = {move-window-to-monitor-left = [];};
            "Mod+Ctrl+Shift+L" = {move-window-to-monitor-right = [];};

            "Mod+O" = {consume-window-into-column = [];};
            "Mod+I" = {consume-window-into-column-left = [];};
            "Mod+Shift+O" = {expel-focused-window-from-column = [];};
            "Mod+Shift+I" = {expel-focused-window-from-column-left = [];};
            "Mod+Ctrl+O" = {expel-window-from-column = [];};
            "Mod+Ctrl+I" = {expel-window-from-column-left = [];};

            "Mod+M" = {switch-preset-column-width = [];};
            "Mod+Shift+M" = {switch-preset-column-width-back = [];};
            "Mod+Ctrl+M" = {expand-column-to-available-width = [];};
            "Mod+Ctrl+Shift+M" = {set-column-width = "100%";};

            "Mod+N" = {switch-preset-window-height = [];};
            "Mod+Shift+N" = {switch-preset-window-height-back = [];};
            "Mod+Ctrl+N" = {reset-window-height = [];};
            "Mod+Ctrl+Shift+N" = {set-window-height = "100%";};

            "Mod+Z" = {maximize-window-to-edges = [];};
            "Mod+Shift+Z" = {fullscreen-window = [];};
            "Mod+Ctrl+Z" = {toggle-window-floating = [];};
            "Mod+Ctrl+Shift+Z" = {switch-focus-between-floating-and-tiling = [];};

            "Mod+Tab" = {maximize-column = [];};
            "Mod+Shift+Tab" = {toggle-column-tabbed-display = [];};
            "Mod+Ctrl+Tab" = {center-visible-columns = [];};
            "Mod+Ctrl+Shift+Tab" = {center-column = [];};

            "Mod+P" = {screenshot-screen = [];};
            "Mod+Shift+P" = {screenshot-window = [];};
            "Mod+Ctrl+P" = {screenshot._props.show-pointer = false;};

            "Mod+V" = {spawn = "bemenu-cliphist";};
            "Mod+Shift+V" = {spawn-sh = "cliphist list | bemenu -p Delete -cl 10 -W 0.5 | cliphist delete";};
            "Mod+Ctrl+Shift+V" = {spawn-sh = "wl-copy -c; cliphist wipe";};

            "Mod+U" = {spawn = "=";};
            "Mod+Shift+U" = {spawn = "pcmanfm";};
            "Mod+Ctrl+U" = {spawn = "clipbrowse";};

            "Mod+B" = {spawn = ["dunstctl" "context"];};
            "Mod+Shift+B" = {spawn = ["dunstctl" "close"];};
            "Mod+Ctrl+Shift+B" = {spawn = ["dunstctl" "close-all"];};
          })
          (builtins.mapAttrs (_: x: x // {_props.allow-when-locked = true;}) {
            "XF86MonBrightnessUp" = {spawn = ["brightnessctl" "-e" "set" "2%+"];};
            "XF86MonBrightnessDown" = {spawn = ["brightnessctl" "-e" "set" "2%-"];};
            "XF86AudioRaiseVolume" = {spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];};
            "XF86AudioLowerVolume" = {spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];};
          })
          (builtins.mapAttrs (_: x:
            x
            // {
              _props = {
                allow-when-locked = true;
                repeat = false;
              };
            }) {
            "XF86AudioMute" = {spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];};
            "XF86AudioMicMute" = {spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];};
            "XF86AudioPlay" = {spawn = ["playerctl" "play-pause"];};
            "XF86AudioPause" = {spawn = ["playerctl" "pause" "--all-players"];};
            "XF86AudioStop" = {spawn = ["playerctl" "stop" "--all-players"];};
            "XF86AudioPrev" = {spawn = ["playerctl" "previous"];};
            "XF86AudioNext" = {spawn = ["playerctl" "next"];};
          })
          {
            "Mod+Minus" = {set-column-width = "-5%";};
            "Mod+Equal" = {set-column-width = "+5%";};
            "Mod+Ctrl+Minus" = {set-window-height = "-5%";};
            "Mod+Ctrl+Equal" = {set-window-height = "+5%";};
            "Mod+Escape" = {
              _props = {
                repeat = false;
                allow-inhibiting = false;
              };
              toggle-keyboard-shortcuts-inhibit = [];
            };
          }
        ];
      }
      {
        # startup
        spawn-at-startup =
          map (x: {_args = x;})
          [
            ["xdg-terminal-exec" "--app-id=btop" "--title=btop" "--" "btop"]
            ["thunderbird"]
            ["org.signal.Signal"]
            ["vesktop"]
            ["zulip"]
            ["element-desktop"]
          ];
        window-rule =
          [
            {
              open-on-workspace = "1";
              open-maximized-to-edges = true;
              open-focused = true;
              match._props = {
                app-id = "^btop$";
                at-startup = true;
              };
            }
          ]
          ++ (lib.imap1 (i: x: {
              open-on-workspace = toString (i + 1);
              open-maximized-to-edges = true;
              open-focused = false;
              match._props = {
                app-id = "^${x}$";
                at-startup = true;
              };
            }) [
              "thunderbird"
              "org\\.signal\\.Signal"
              "vesktop"
              "Zulip"
              "element"
            ]);
      }
      (
        let
          workspaces = [
            "1"
            "2"
            "3"
            "4"
            "5"
            "6"
            "7"
            "8"
            "9"
            "0"
            "q"
            "w"
            "e"
            "r"
            "a"
            "s"
            "d"
            "f"
          ];
        in {
          workspace = map (x: {_args = [x];}) workspaces;
          binds = lib.mergeAttrsList (map (x: {
              "Mod+${x}" = {focus-workspace = x;};
              "Mod+Shift+${x}" = {move-window-to-workspace = x;};
              "Mod+Ctrl+${x}" = {
                move-window-to-workspace = {
                  _args = [x];
                  _props.focus = false;
                };
              };
              "Mod+Ctrl+Shift+${x}" = {move-column-to-workspace = x;};
            })
            workspaces);
        }
      )
    ];
  };

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

  systemd.user.services."niri" = let
    niri = config.wayland.windowManager.niri.package or pkgs.niri;
  in {
    Service = {
      ExecStart = "${lib.getExe niri} --session";
      ExecReload = "${lib.getExe niri} msg action load-config-file";
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
      X-ReloadTriggers = [config.xdg.configFile."niri/config.kdl".source];
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
