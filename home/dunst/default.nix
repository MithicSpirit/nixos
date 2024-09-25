{
  config,
  pkgs,
  root,
  lib,
  ...
}:
{

  services.dunst = {
    enable = true;
    iconTheme = config.gtk.iconTheme;
    settings =
      let
        colors = (import (root + /common/colorscheme.nix)).hash;
      in
      {

        # TODO: maybe customize more
        global = {
          follow = "keyboard";
          sort = "urgency_descending";
          notification_limit = 3;
          indicate_hidden = true;
          idle_threshold = 60;
          format = "%p<b>%s</b> (<i>%a</i>)\\n%b";
          title = "Dunst";
          class = "dunst";

          dmenu = "${lib.getExe pkgs.bemenu} -p Dunst -cl 7 -W 0.5";
          browser = "${../scripts/bin/menu-browser}";
          mouse_left_click = "context, close_current"; # TODO: should be list?
          mouse_middle_click = "close_all";
          mouse_right_click = "close_current";

          font = "Iosevka Mithic 11";
          corner_radius = 4;
          frame_color = colors.accent;
          frame_width = 2;
          separator_height = 2;
        };

        urgency_low = {
          background = colors.floor;
          foreground = colors.middle;
          timeout = 7;
        };
        urgency_normal = {
          background = colors.bg;
          foreground = colors.fg;
          timeout = 15;
        };
        urgency_critical = {
          background = colors.bg;
          foreground = colors.highlight;
          timeout = 0;
          override_pause_level = 60;
        };

        notify-send = {
          appname = "notify-send";
          urgency = "normal";
          format = "%p<b>%s</b>\\n%b";
        };
        signal = {
          appname = "Signal*";
          urgency = "critical";
        };
        gamemode = {
          summary = "GameMode *";
          appname = "notify-send";
          urgency = "low";
          format = "%s";
        };
      };
  };

  home.packages = [ pkgs.bemenu ];

}
