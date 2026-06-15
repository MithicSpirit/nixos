{
  config,
  pkgs,
  root,
  lib,
  ...
}: {
  services.dunst = {
    enable = true;
    iconTheme = config.gtk.iconTheme;
    settings = let
      colors = (import (root + /common/colorscheme.nix)).hash;
    in {
      # TODO: maybe customize more
      global = {
        follow = lib.mkDefault "keyboard";
        sort = "urgency_descending";
        notification_limit = 3;
        indicate_hidden = true;
        idle_threshold = 4;
        title = "Dunst";
        class = "dunst";

        font = "${builtins.head config.fonts.fontconfig.defaultFonts.monospace} 10";
        format = "%p<b>%s</b> (%a)\\n%b";

        dmenu = "${lib.getExe pkgs.bemenu} -p Dunst -cl 7 -W 0.5";
        browser = "${../scripts/bin/menu-browser}";
        mouse_left_click = "context, close_current"; # TODO: should be list?
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";

        origin = "top-right";
        width = 300;
        offset = "(9, 28)";
        corner_radius = 4;
        frame_color = colors.accent;
        frame_width = 2;
        separator_height = 2;
      };

      urgency_low = {
        background = colors.floor;
        foreground = colors.middle;
        timeout = 20;
      };
      urgency_normal = {
        background = colors.bg;
        foreground = colors.fg;
        timeout = 0;
      };
      urgency_critical = {
        background = colors.bg;
        foreground = colors.highlight;
        timeout = 0;
        override_pause_level = 100;
      };

      signal = {
        appname = "Signal*";
        urgency = "critical";
      };
      notify-send = {
        appname = "notify-send";
        urgency = "normal";
        format = "%p<b>%s</b>\\n%b";
      };
      gamemode = {
        appname = "GameMode";
        urgency = "low";
        format = "%s (%a)";
      };
      blueman = {
        appname = "blueman";
        urgency = "low";
      };
      niri-screenshot = {
        appname = "niri";
        summary = "Screenshot captured";
        urgency = "low";
      };
    };
  };

  home.packages = [pkgs.bemenu];
}
