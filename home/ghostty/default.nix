{
  pkgs,
  config,
  root,
  ...
}:
{

  programs.ghostty = {
    # XXX: #3555, #3708

    enable = true;
    clearDefaultKeybinds = true;

    settings =
      let
        colors = (import (root + /common/colorscheme.nix)).hash;
      in
      {
        # font
        font-family = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
        font-size = 12.5;
        font-style = "SemiBold";
        adjust-cell-height = "-5%";

        # mouse
        cursor-click-to-move = false;
        mouse-hide-while-typing = false;
        mouse-shift-capture = "never";

        # window
        window-padding-balance = true;
        window-padding-color = "extend";
        window-decoration = "server";
        window-theme = "ghostty";
        window-show-tab-bar = "never";
        resize-overlay = "never"; # TODO: after-delay (#6640)
        resize-overlay-position = "center";
        initial-window = true;
        quit-after-last-window-closed = false;
        gtk-single-instance = true;
        gtk-titlebar = false;
        gtk-custom-css =
          let
            no-rounded-corners = pkgs.writeTextFile {
              name = "ghostty-no-rounded-corners.css";
              text = # CSS
                "window { border-radius: 0 0; }";
            };
          in
          [ "${no-rounded-corners}" ];

        # clipboard
        clipboard-read = "allow";
        clipboard-write = "allow";
        clipboard-trim-trailing-spaces = true;
        clipboard-paste-protection = true;
        clipboard-paste-bracketed-safe = true;
        copy-on-select = true;

        # misc
        scrollback-limit = 16 * 1024 * 1024; # 16 MB
        linux-cgroup = "single-instance";
        working-directory = "inherit";
        shell-integration = "detect";
        shell-integration-features = "no-cursor,sudo,title";
        desktop-notifications = true;
        auto-update = "off";

        # theme
        background = colors.base00;
        foreground = colors.base07;
        selection-background = colors.fake;
        selection-foreground = "cell-foreground";
        # minimum-contrast = 3; HACK: breaks fastfetch icon
        palette = [
          "0=${colors.base00'}"
          "1=${colors.base01}"
          "2=${colors.base02}"
          "3=${colors.base03}"
          "4=${colors.base04}"
          "5=${colors.base05}"
          "6=${colors.base06}"
          "7=${colors.base07'}"
          "8=${colors.base08}"
          "9=${colors.base09}"
          "10=${colors.base10}"
          "11=${colors.base11}"
          "12=${colors.base12}"
          "13=${colors.base13}"
          "14=${colors.base14}"
          "15=${colors.base15}"
        ];
        cursor-color = colors.middle;
        cursor-text = colors.base00; # background
        cursor-opacity = 0.9;
        cursor-style = "block";
        cursor-style-blink = false;
        background-opacity = "0.93";
        bold-is-bright = false;
        adjust-cursor-thickness = "+200%";

        # keybinds
        keybind = [
          # clipboard
          "ctrl+shift+c=copy_to_clipboard"
          "ctrl+shift+v=paste_from_clipboard"
          "ctrl+shift+f=paste_from_selection"
          "ctrl+shift+d=copy_url_to_clipboard"
          # font size
          "ctrl+shift+plus=increase_font_size:1"
          "ctrl+shift+minus=decrease_font_size:1"
          "ctrl+shift+zero=reset_font_size"
          # scrollback
          "ctrl+shift+backspace=clear_screen"
          "ctrl+shift+alt+backspace=reset"
          # navigation
          "ctrl+shift+j=scroll_page_fractional:+0.5"
          "ctrl+shift+k=scroll_page_fractional:-0.5"
          "ctrl+shift+alt+j=jump_to_prompt:+1"
          "ctrl+shift+alt+k=jump_to_prompt:-1"
        ];
      };

  };

}
