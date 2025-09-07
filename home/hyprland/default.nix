{
  config,
  lib,
  root,
  pkgs,
  ...
}:
let
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
in
{

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
        "col.active_border" = colors.rgb.accent;
        "col.nogroup_border" = colors.rgb.bad;
        "col.nogroup_border_active" = colors.rgb.strange;
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
        drag_into_group = 1;
        group_on_movetoworkspace = true;
        "col.border_inactive" = colors.rgb.bg;
        "col.border_active" = colors.rgb.accent;
        "col.border_locked_inactive" = colors.rgb.warning;
        "col.border_locked_active" = colors.rgb.good;

        groupbar = {
          enabled = true;
          rounding = 0;
          gaps_out = 3;
          gaps_in = 3;
          indicator_height = 5;
          keep_upper_gap = false;

          render_titles = false;
          font_size = 10;
          font_weight_active = "ultrabold";
          font_weight_inactive = "bold";
          text_color = colors.rgb.fg;
          text_color_inactive = colors.rgb.lower;

          "col.inactive" = colors.rgb.bg;
          "col.active" = colors.rgb.accent;
          "col.locked_inactive" = colors.rgb.warning;
          "col.locked_active" = colors.rgb.good;
          # TODO
        };
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        font_family = "Sans";
        force_default_wallpaper = 0;
        vrr = 1;
        disable_autoreload = true;
        new_window_takes_over_fullscreen = 1;
        exit_window_retains_fullscreen = true;
        render_unfocused_fps = 3;
      };

      binds = {
        workspace_back_and_forth = true;

        # movefocus_cycles_fullscreen
      };

      xwayland = {
        enabled = true;
        force_zero_scaling = true;
      };

      render = {
        direct_scanout = 1;
        new_render_scheduling = true;
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

      windowrule = [
        "group, group:0" # automatically group all windows
        "prop xray 1, fullscreen:1" # hide bar in transparent fullscreen windows
        # pin
        "pin, class:dragon-drop, title:dragon"
        "pin, class:librewolf, title:Picture-in-Picture"
        # float
        "float, class:qalculate-gtk"
        "float, class:xdg-desktop-portal"
        # games
        "renderunfocused, content:game" # don't lag in bg
        "renderunfocused, xdgtag:proton-game"
        "immediate, content:game" # allow tearing
        "immediate, xdgtag:proton-game"
        "content game, xdgtag:proton-game" # TODO: probably doesn't work
        "content game, initialClass:steam_app_.*"
        "content game, initialClass:warframe.x64.exe"
        "content game, initialClass:pathofexilesteam.exe"
        "content game, initialClass:exefile.exe" # eve
      ];

      exec-once = [
        "[workspace 1 silent; fullscreen] ${config.home.sessionVariables.TERMINAL} --class btop --title btop -e btop"
        "[workspace 2 silent; group] thunderbird"
        "[workspace 3 silent; group] org.signal.Signal"
        "[workspace 4 silent; group] dev.vencord.Vesktop"
        "[workspace 5 silent; group] im.riot.Riot"
      ];

      workspace = lib.mapAttrsToList (
        name: id: "${id}, defaultName:${name}"
      ) workspaces;

      master = {
        mfact = 0.5;
        new_on_active = "after";
      };

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"

        "GDK_BACKEND,wayland,x11,*"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"

        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ];

      "$mod" = "SUPER";

      bind =
        let
          grimblast = "grimblast --notify --openfile --scale 1";
          scrot = "\"$XDG_PICTURES_DIR/screenshots/$(date +%Y-%m-%d_%H-%M-%S.%N).png\"";
        in
        [
          "$mod, Return, exec, bemenu-run -p Run >/tmp/exec.log 2>&1"
          "$mod SHIFT, Return, exec, ${config.home.sessionVariables.TERMINAL} >/tmp/exec.log 2>&1"
          "$mod CONTROL, Return, exec, ${config.home.sessionVariables.BROWSER} >/tmp/exec.log 2>&1"
          "$mod CONTROL SHIFT, Return, exec, bemenu -p hyprctl </dev/null | xargs hyprctl"

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

          "$mod, o, moveoutofgroup, active"
          "$mod SHIFT, o, lockactivegroup, toggle"
          "$mod CONTROL, o, togglegroup"
          "$mod SHIFT CONTROL, o, lockgroups, lock"

          "$mod, z, fullscreen, 0"
          "$mod SHIFT, z, togglefloating"
          "$mod CONTROL, z, fullscreen, 1"
          "$mod SHIFT, mouse:272, setfloating"

          "$mod SHIFT, x, killactive"
          "$mod CONTROL, x, exec, loginctl lock-session"
          "$mod CONTROL SHIFT, x, exec, ${./power-menu.sh}"
          # "$mod CONTROL SHIFT, x, exit"

          "$mod, v, exec, bemenu-cliphist"
          "$mod SHIFT, v, exec, cliphist list | bemenu -p Delete -cl -W 0.5 | cliphist delete"
          "$mod CONTROL SHIFT, v, exec, wl-copy -c; cliphist wipe"

          "$mod, u, exec, ="
          "$mod SHIFT, u, exec, pcmanfm"
          "$mod CONTROL, u, exec, clipbrowse"

          "$mod, p, exec, ${grimblast} --cursor copysave screen ${scrot}"
          "$mod SHIFT, p, exec, ${grimblast} copysave area ${scrot}"
          "$mod CONTROL, p, exec, ${grimblast} --cursor copysave output ${scrot}"

          # TODO: disable touchpad
        ]
        ++ builtins.concatLists (
          lib.mapAttrsToList (name: id: [
            "$mod, ${name}, workspace, ${id}"
            "$mod SHIFT, ${name}, movetoworkspace, ${id}"
            "$mod CONTROL, ${name}, movetoworkspacesilent, ${id}"
          ]) workspaces
        );

      binde = [
        "$mod CONTROL, h, layoutmsg, mfact -0.01"
        "$mod CONTROL, l, layoutmsg, mfact +0.01"
      ];

      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl pause --all-players"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioStop, exec, playerctl stop --all-players"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        # what was the thing other than brightnessctl?
        ", XF86MonBrightnessUp, exec, brightnessctl -e set 2%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e set 2%-"
        "SHIFT, XF86MonBrightnessUp, exec, brightnessctl -e set 10%+"
        "SHIFT, XF86MonBrightnessDown, exec, brightnessctl -e set 10%-"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod SHIFT, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod SHIFT, mouse:273, resizewindow 2"
        "$mod CONTROL, mouse:273, resizewindow 1"
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
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  home.file.".login" = {
    enable = true;
    executable = true;
    text = # sh
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
      preload = "${wallpaper}";
      wallpaper = ", ${wallpaper}";
    };
  };

  services.hypridle =
    let
      lock-time = 600;
      alert-time = 30;
      off-time = 60;
    in
    {
      enable = true;
      settings = {
        general = {
          lock_cmd = "if ! pidof -q hyprlock; then hyprlock; hyprctl dispatch dpms on; brightnessctl -r; fi";
          unlock_cmd = "killall -USR1 hyprlock";
          on_lock_cmd = "dunsctl set-paused true";
          on_unlock_cmd = "dunsctl set-paused false";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";

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
        blur_size = 8;
        blur_passes = 2;
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
    temperature.night = 3600;
    settings.general = {
      brightness-day = 1.0;
      brightness-night = 1.0;

      fade = true;
      transition = true;
    };
  };

  programs.waybar =
    let
      icon-size = 16;
    in
    {
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

      style = # css
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
