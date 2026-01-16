{
  config,
  lib,
  root,
  pkgs,
  ...
}: let
  wallpaper = import (root + /common/wallpaper);
  colors = import (root + /common/colorscheme.nix);
  workspaces = {
    "1" = "1";
    "2" = "2";
    "3" = "3";
    "4" = "4";
    "5" = "5";
    "6" = "6";
    "7" = "7";
    "8" = "8";
    "9" = "9";
    "0" = "10";
    "q" = "11";
    "w" = "12";
    "e" = "13";
    "r" = "14";
    "a" = "15";
    "s" = "16";
    "d" = "17";
    "f" = "18";
  };
in {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    settings = {
      general = {
        layout = "master";
        snap.enabled = false;

        border_size = 2;
        gaps_in = 2;
        gaps_out = 4;
        "col.inactive_border" = colors.rgb.bg;
        "col.active_border" = colors.rgb.strange;
        "col.nogroup_border" = colors.rgb.bg;
        "col.nogroup_border_active" = colors.rgb.colored;
      };

      decoration = {
        blur = {
          enabled = false;
          size = 6;
          passes = 1;
        };
        shadow.enabled = false;
      };

      animations.enabled = false;

      input = {
        kb_layout = "us,gr,il";
        kb_variant = ",,phonetic";
        kb_options = "grp:win_space_toggle,compose:rctrl,lv3:ralt_switch";
        numlock_by_default = true;
        accel_profile = "flat";
        sensitivity = -0.22;
        scroll_factor = 0.8;
        follow_mouse = 1;

        touchpad = {
          scroll_factor = 0.4;
          natural_scroll = true;
        };
        touchdevice.enabled = false;
      };

      group = {
        auto_group = true;
        drag_into_group = 2; # groupbar
        merge_groups_on_drag = false;
        merge_groups_on_groupbar = true;
        merge_floated_into_tiled_on_groupbar = true;
        group_on_movetoworkspace = true;
        "col.border_inactive" = colors.rgb.bg;
        "col.border_active" = colors.rgb.accent;
        "col.border_locked_inactive" = colors.rgb.bg;
        "col.border_locked_active" = colors.rgb.strange;

        groupbar = {
          enabled = true;
          rounding = 0;
          gaps_out = 4;
          gaps_in = 4;
          indicator_height = 6;
          keep_upper_gap = false;

          render_titles = false;
          font_size = 10;
          font_weight_active = "ultrabold";
          font_weight_inactive = "bold";
          text_color = colors.rgb.fg;
          text_color_inactive = colors.rgb.lower;

          "col.inactive" = colors.rgb.bg;
          "col.active" = colors.rgb.accent;
          "col.locked_inactive" = colors.rgb.strange;
          "col.locked_active" = colors.rgb.accent;
        };
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_watchdog_warning = true;
        font_family = "Sans";
        force_default_wallpaper = 0;
        vrr = 2;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_autoreload = true;
        on_focus_under_fullscreen = 1;
        exit_window_retains_fullscreen = true;
        render_unfocused_fps = 15;
        lockdead_screen_delay = 2000;
        enable_anr_dialog = true;
        anr_missed_pings = 3;
      };

      binds = {
        workspace_back_and_forth = false;
        movefocus_cycles_fullscreen = true; # TODO?
      };

      xwayland = {
        enabled = true;
        force_zero_scaling = true;
      };

      render = {
        direct_scanout = 0; # breaks cursor in fullscreen
        new_render_scheduling = true;
      };

      cursor = {
        no_hardware_cursors = 2;
        no_break_fs_vrr = 2;
        enable_hyprcursor = false; # TODO: find theme
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      monitorv2 = [
        {
          output = "";
          mode = "preferred";
          position = "auto";
        }
      ];

      windowrule =
        [
          {
            name = "group-all";
            "match:float" = false;
            "match:fullscreen" = false;
            group = "set always";
          }
          {
            name = "no-group-floats";
            "match:float" = true;
            group = "override barred deny";
          }
          {
            name = "transparent-dragging";
            "match:tag" = "dragging";
            opacity = 0.6;
          }
        ]
        ++ builtins.concatLists (
          lib.mapAttrsToList
          (
            basename: {
              props,
              effects,
            }:
              lib.mapAttrsToList (
                propname: prop: {name = "${basename}:${propname}";} // effects // prop
              )
              props
          )
          {
            float = {
              effects = {
                float = true;
                group = "override barred deny";
              };
              props = {
                "xdg-desktop-portal" = {
                  # xdg-desktop-portal, xdg-desktop-portal-gtk, etc.
                  "match:class" = "xdg-desktop-portal(|-.*)";
                };
                "qalculate-gtk" = {
                  "match:class" = "qalculate-gtk";
                };
                "matplotlib" = {
                  "match:class" = "Matplotlib";
                };
                "steam-popup" = {
                  "match:class" = "steam";
                  "match:initial_title" = "negative:Steam";
                };
                "librewolf-bookmarks" = {
                  "match:class" = "librewolf";
                  "match:initial_title" = "Library";
                };
                "swayimg" = {
                  # swayimg, swayimg_123456, etc.
                  "match:class" = "swayimg(|_.*)";
                };
              };
            };
            pin = {
              effects = {
                float = true;
                pin = true;
                group = "override barred deny";
              };
              props = {
                "dragon" = {
                  "match:title" = "dragon";
                };
                "librewolf-picture-in-picture" = {
                  "match:class" = "librewolf";
                  "match:title" = "Picture-in-Picture";
                };
              };
            };
            game = {
              effects = {
                fullscreen = true;
                group = "override barred deny";
                content = "game";
                render_unfocused = true;
                immediate = true;
                suppress_event = "fullscreen maximize fullscreenoutput";
              };
              props = {
                "proton-wayland" = {
                  "match:xdg_tag" = "proton-game";
                };
                "proton-xwayland" = {
                  "match:class" = "steam_app_.*";
                };
                "dota2" = {
                  "match:class" = "dota2";
                };
                "terraria" = {
                  "match:class" = "Terraria\\.bin\\.x86_64";
                };
                "factorio" = {
                  "match:class" = "factorio";
                };
                "openttd" = {
                  "match:class" = "openttd";
                };
              };
            };
          }
        );

      layerrule = [
        {
          name = "bottom-waybar";
          "match:namespace" = "waybar";
          no_screen_share = true;
          order = 1000;
        }
        {
          name = "overlay-bemenu";
          "match:namespace" = "menu";
          no_screen_share = true;
          order = 900;
        }
        {
          name = "overlay-notifications";
          "match:namespace" = "notifications";
          no_screen_share = true;
          order = 800;
        }
      ];

      exec-once = [
        "[workspace 1; fullscreen] ${config.home.sessionVariables.TERMINAL} --class=btop --title=btop -e btop"
        "[workspace 2 silent] thunderbird"
        "[workspace 3 silent] org.signal.Signal"
        "[workspace 4] dev.vencord.Vesktop" # breaks on silent
        "[workspace 5] im.riot.Riot" # breaks on silent
      ];

      workspace =
        lib.mapAttrsToList (
          name: id: "${id}, defaultName:${name}"
        )
        workspaces;

      master = {
        mfact = 0.5;
        new_on_active = "after";
      };

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        "GDK_BACKEND,wayland,x11,*"
        "SDL_VIDEODRIVER,wayland,x11"
        "SDL_AUDIODRIVER,pipewire,pulseaudio,pulse"
        "CLUTTER_BACKEND,wayland"

        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ];

      "$mod" = "SUPER";

      bind = let
        grimblast = "grimblast --notify --openparentdir";
        scrot = "\"$XDG_PICTURES_DIR/screenshots/$(date +%Y-%m-%d_%H-%M-%S.%N).png\"";
        terminal = let
          inherit (config.home.sessionVariables) TERMINAL;
        in
          if lib.hasPrefix "ghostty" TERMINAL
          then "${TERMINAL} +new-window"
          else TERMINAL;
      in
        [
          "$mod, Return, execr, bemenu-run -p Run >>/tmp/exec.log 2>&1"
          "$mod SHIFT, Return, execr, ${terminal} >>/tmp/exec.log 2>&1"
          "$mod CONTROL, Return, execr, ${config.home.sessionVariables.BROWSER} >>/tmp/exec.log 2>&1"
          "$mod CONTROL SHIFT, Return, execr, bemenu -p hyprctl </dev/null | xargs hyprctl"

          # TODO: better keybinds for groups
          "$mod, j, layoutmsg, cyclenext"
          "$mod, k, layoutmsg, cycleprev"
          # "$mod, h, layoutmsg, focusmaster auto"
          # "$mod, l, layoutmsg, focusmaster previous"
          "$mod, h, changegroupactive, b"
          "$mod, l, changegroupactive, f"

          "$mod SHIFT, j, layoutmsg, swapnext"
          "$mod SHIFT, k, layoutmsg, swapprev"
          "$mod SHIFT, h, movegroupwindow, b"
          "$mod SHIFT, l, movegroupwindow, f"

          # "$mod CONTROL, j, layoutmsg, removemaster"
          # "$mod CONTROL, k, layoutmsg, addmaster"
          "$mod CONTROL, j, layoutmsg, mfact exact 0.5"
          "$mod CONTROL, k, layoutmsg, mfact exact 0.75"
          # "$mod CONTROL, j, togglegroup"
          # "$mod CONTROL, k, layoutmsg, mfact exact 0.5"

          "$mod, o, moveoutofgroup"
          "$mod SHIFT, o, lockactivegroup, toggle"
          "$mod SHIFT, o, denywindowfromgroup, toggle"
          "$mod CONTROL SHIFT, o, denywindowfromgroup, off"
          "$mod CONTROL SHIFT, o, togglegroup"

          "$mod, z, fullscreen, 0"
          "$mod CONTROL, z, fullscreen, 1"
          "$mod CONTROL SHIFT, z, togglefloating"

          "$mod SHIFT, z, moveoutofgroup"
          "$mod SHIFT, z, togglefloating"

          "$mod, mouse:272, moveoutofgroup"
          "$mod SHIFT, mouse:272, moveoutofgroup"
          "$mod SHIFT, mouse:272, setfloating"

          "$mod, mouse:272, tagwindow, +dragging"
          "$mod SHIFT, mouse:272, tagwindow, +dragging"
          "$mod CONTROL, mouse:272, tagwindow, +dragging"
          "$mod, mouse:273, tagwindow, +dragging"
          "$mod SHIFT, mouse:273, tagwindow, +dragging"
          "$mod CONTROL, mouse:273, tagwindow, +dragging"

          "$mod SHIFT, x, killactive"
          "$mod CONTROL, x, execr, loginctl lock-session"
          "$mod CONTROL SHIFT, x, execr, ${./power-menu.sh}"

          "$mod, v, execr, bemenu-cliphist"
          "$mod SHIFT, v, execr, cliphist list | bemenu -p Delete -cl 10 -W 0.5 | cliphist delete"
          "$mod CONTROL SHIFT, v, execr, wl-copy -c; cliphist wipe"

          "$mod, u, execr, ="
          "$mod SHIFT, u, execr, pcmanfm"
          "$mod CONTROL, u, execr, clipbrowse"

          "$mod, p, execr, ${grimblast} --cursor copysave screen ${scrot}"
          "$mod SHIFT, p, execr, ${grimblast} copysave area ${scrot}"
          "$mod CONTROL, p, execr, ${grimblast} --cursor copysave output ${scrot}"

          "$mod, n, execr, dunstctl context"
          "$mod SHIFT, n, execr, dunstctl close"
          "$mod CONTROL SHIFT, n, execr, dunstctl close-all"

          # TODO: disable touchpad
        ]
        ++ builtins.concatLists (
          lib.mapAttrsToList (name: id: [
            "$mod, ${name}, workspace, ${id}"
            "$mod SHIFT, ${name}, moveoutofgroup"
            "$mod SHIFT, ${name}, movetoworkspace, ${id}"
            "$mod CONTROL, ${name}, moveoutofgroup"
            "$mod CONTROL, ${name}, movetoworkspacesilent, ${id}"
            "$mod CONTROL SHIFT, ${name}, movetoworkspace, ${id}"
          ])
          workspaces
        );

      binde = [
        "$mod CONTROL, h, layoutmsg, mfact -0.01"
        "$mod CONTROL, l, layoutmsg, mfact +0.01"
      ];

      bindl = [
        ", XF86AudioPlay, execr, playerctl play-pause"
        ", XF86AudioPause, execr, playerctl pause --all-players"
        ", XF86AudioPrev, execr, playerctl previous"
        ", XF86AudioNext, execr, playerctl next"
        ", XF86AudioStop, execr, playerctl stop --all-players"
        ", XF86AudioMute, execr, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, execr, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, execr, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, execr, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        # TODO: what was the thing other than brightnessctl?
        ", XF86MonBrightnessUp, execr, brightnessctl -e set 2%+"
        ", XF86MonBrightnessDown, execr, brightnessctl -e set 2%-"
        "SHIFT, XF86MonBrightnessUp, execr, brightnessctl -e set 10%+"
        "SHIFT, XF86MonBrightnessDown, execr, brightnessctl -e set 10%-"
      ];

      bindr = [
        "$mod, mouse:272, tagwindow, -dragging"
        "$mod SHIFT, mouse:272, tagwindow, -dragging"
        "$mod CONTROL, mouse:272, tagwindow, -dragging"
        "$mod, mouse:273, tagwindow, -dragging"
        "$mod SHIFT, mouse:273, tagwindow, -dragging"
        "$mod CONTROL, mouse:273, tagwindow, -dragging"
      ];

      bindm = [
        "$mod, mouse:272, movewindow" # ungroup
        "$mod SHIFT, mouse:272, movewindow" # float, ungroup
        "$mod CONTROL, mouse:272, movewindow" # normal
        "$mod, mouse:273, resizewindow" # normal
        "$mod SHIFT, mouse:273, resizewindow 2" # force resize
        "$mod CONTROL, mouse:273, resizewindow 1" # keep aspect ratio
      ];
    };
    importantPrefixes = [
      "$"
      "bezier"
      "name"
      "output"
    ];
  };

  home.packages = with pkgs; [
    grimblast
    playerctl
    brightnessctl
  ];

  xdg.portal = {
    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  home.file.".login" = {
    enable = true;
    executable = true;
    text =
      /*
      sh
      */
      ''
        #!/usr/bin/env sh
        [ -z "$WAYLAND_DISPLAY" -a -z "$DISPLAY" -a "$XDG_VTNR" -eq 1 ] \
          && exec Hyprland >>/tmp/hyprland.log 2>&1
        :
      '';
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

  services.hypridle = let
    lock-time = 600;
    alert-time = 30;
    off-time = 60;
  in {
    enable = true;
    settings = {
      general = {
        lock_cmd = "if ! pidof -q hyprlock; then hyprlock; fi";
        unlock_cmd = "killall -USR1 hyprlock";
        on_lock_cmd = "dunstctl set-paused true";
        on_unlock_cmd = "hyprctl dispatch forceidle 0; dunstctl set-paused false";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch forceidle 0";

        ignore_dbus_inhibit = true;
        ignore_systemd_inhibit = true;
        ignore_wayland_inhibit = true;
      };
      listener = [
        {
          timeout = lock-time - alert-time;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = lock-time;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = lock-time + off-time;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on; brightnessctl -r";
        }
      ];
    };
  };

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

  services.hyprpolkitagent = {
    enable = true;
  };

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

  programs.waybar = let
    icon-size = 16;
  in {
    enable = true;
    systemd.enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        mode = "dock";
        height = 24;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/windowcount"
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "custom/status"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          sort-by = "id";
        };

        "hyprland/windowcount" = {
          format = "({})";
          format-fullscreen = "[{}]";
          format-empty = " ";
        };

        "hyprland/window" = {
          inherit icon-size;
          separate-outputs = true;
          icon = true;
          format = "{title} ({class})";
          rewrite = {
            " \\(\\)" = "";
          };
        };

        "custom/status" = {
          exec = lib.getExe (
            pkgs.writeCBin "hyprland-waybar-status" (builtins.readFile ./status.c)
          );
        };

        "tray" = {
          inherit icon-size;
          reverse-direction = true;
        };
      }
    ];

    style =
      /*
      css
      */
      ''
        window#waybar {
          font-size: 13;
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
        #workspaces button.hosting-monitor {
          color: ${colors.hash.fg};
          background: ${colors.hash.bg};
        }
        #workspaces button.visible {
          color: ${colors.hash.colored};
        }
        #workspaces button.active.hosting-monitor {
          color: ${colors.hash.accent};
          background: ${colors.hash.shadow};
        }
        #workspaces button.urgent {
          color: ${colors.hash.advanced};
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
          padding: 1px;
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
