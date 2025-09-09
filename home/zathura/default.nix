{
  config,
  pkgs,
  root,
  ...
}:
{

  programs.zathura = {
    enable = true;
    package = pkgs.zathura.override { useMupdf = false; };

    options =
      let
        colors = (import (root + /common/colorscheme.nix)).hash;
      in
      {
        selection-clipboard = "clipboard";
        database = "sqlite";
        continuous-hist-save = true;
        window-title-home-tilde = true;
        window-title-basename = true;
        statusbar-home-tilde = true;
        guioptions = "hv";

        recolor = true;
        recolor-keephue = true;
        recolor-reverse-video = false;
        recolor-adjust-lightness = true;

        render-loading = true;
        render-loading-bg = "#2E3440";
        render-loading-fg = "#E5E9F0";

        scroll-step = 60;
        scroll-full-overlap = "0.15";
        scroll-page-aware = true;

        synctex = true;
        dbus-service = true;
        dbus-raise-window = true;

        font = "${builtins.head config.fonts.fontconfig.defaultFonts.monospace} 10";
        page-padding = 4;
        page-cache-size = 63;
        statusbar-h-padding = 4;
        statusbar-v-padding = 2;

        completion-bg = colors.bg;
        completion-fg = colors.fg;
        completion-group-bg = "#00f";
        completion-group-fg = "#f00";
        completion-highlight-bg = colors.shadow;
        completion-highlight-fg = colors.accent;
        default-bg = colors.floor;
        default-fg = colors.middle;
        recolor-lightcolor = "#000";
        recolor-darkcolor = "#ddd";
        inputbar-bg = colors.shadow;
        inputbar-fg = colors.fg;
        notification-bg = colors.bg;
        notification-fg = colors.accent;
        notification-error-bg = colors.bg;
        notification-error-fg = colors.bad;
        notification-warning-bg = colors.bg;
        notification-warning-fg = colors.warning;
        statusbar-bg = colors.bg;
        statusbar-fg = colors.middle;
        highlight-color = "rgba(76,86,106,0.6)"; # fake = #4C566A
        highlight-fg = colors.fg;
        highlight-active-color = "rgba(136,192,208,0.5)"; # accent = #88C0D0
        index-bg = colors.bg;
        index-fg = colors.fg;
        index-active-bg = colors.shadow;
        index-active-fg = colors.accent;
      };

    mappings = {
      "u" = "scroll half-up";
      "d" = "scroll half-down";
      "<BackSpace>" = "scroll full-up";
      "p" = "snap_to_page";
      "P" = "toggle_page_mode";
      "Q" = "quit";
    };
    extraConfig = ''
      unmap q
    '';
  };

  xdg.mimeApps.defaultApplications."application/pdf" = "org.pwmt.zathura.desktop";
}
