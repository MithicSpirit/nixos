{ ... }:
{

  programs.zathura = {
    enable = true;

    options = {
      selection-clipboard = "clipboard";
      database = "sqlite";
      sandbox = "none";
      continuous-hist-save = true;
      window-title-home-tilde = true;
      window-title-basename = true;
      statusbar-home-tilde = true;
      guioptions = "hv";

      recolor-keephue = true;
      recolor-reverse-video = false;

      scroll-step = 60;
      scroll-full-overlap = "0.15";
      scroll-page-aware = true;

      synctex = true;
      synctex-editor-command = "emacsclient +%{line} %{input}";

      dbus-service = true;
      dbus-raise-window = true;

      font = "Iosevka Mithic 9";
      page-padding = 2;
      page-cache-size = 64;
      statusbar-h-padding = 3;
      statusbar-v-padding = 1;

      completion-bg = "#3B4252";
      completion-fg = "#ECEFF4";
      completion-group-bg = "#0000FF";
      completion-group-fg = "#FF0000";
      completion-highlight-bg = "#434C5E";
      completion-highlight-fg = "#88C0D0";
      default-fg = "#E5E9F0";
      default-bg = "#2E3440";
      inputbar-bg = "#434C5E";
      inputbar-fg = "#ECEFF4";
      notification-bg = "#3B4252";
      notification-fg = "#88C0D0";
      notification-error-bg = "#3B4252";
      notification-error-fg = "#BF616A";
      notification-warning-bg = "#3B4252";
      notification-warning-fg = "#EBCB8B";
      statusbar-bg = "#3B4252";
      statusbar-fg = "#E5E9F0";
      highlight-color = "rgba(76,86,106,0.6)"; # "#4C566A"
      highlight-fg = "#ECEFF4";
      highlight-active-color = "rgba(136,192,208,0.5)"; # "#88C0D0"
      index-bg = "#3B4252";
      index-fg = "#ECEFF4";
      index-active-bg = "#434C5E";
      index-active-fg = "#88C0D0";
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
}
