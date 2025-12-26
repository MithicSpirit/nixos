{
  lib,
  config,
  root,
  ...
}:
{
  home.sessionVariables."TERMINAL" = "ghostty";
  xdg.terminal-exec.settings.default = [ "com.mitchellh.ghostty.desktop" ];

  programs.ghostty = {

    enable = true;
    systemd.enable = false; # manual
    clearDefaultKeybinds = true;

    settings =
      let
        colors = (import (root + /common/colorscheme.nix)).hash;
      in
      {
        # font
        font-family = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
        font-size = 12;
        font-style = "SemiBold";
        freetype-load-flags = "no-hinting,no-monochrome";

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
        resize-overlay = "after-first";
        resize-overlay-position = "center";
        initial-window = true;
        gtk-single-instance = false; # only for systemd service
        quit-after-last-window-closed = true;
        quit-after-last-window-closed-delay = "";
        gtk-titlebar = false;

        # clipboard
        clipboard-read = "allow";
        clipboard-write = "allow";
        clipboard-trim-trailing-spaces = true;
        clipboard-paste-protection = true;
        clipboard-paste-bracketed-safe = true;
        copy-on-select = true;

        # shell integration
        shell-integration = "detect";
        shell-integration-features = "no-cursor,sudo,title";
        notify-on-command-finish = "unfocused";
        notify-on-command-finish-action = "notify,no-bell";
        notify-on-command-finish-after = 0;

        # misc
        scrollback-limit = 16 * 1024 * 1024; # 16 MB
        mouse-scroll-multiplier = "discrete:3.125,precision:1"; # HACK: for some reason one notch is 1.6, so use 3.125 to get 5 lines of scrolling per notch.
        linux-cgroup = "single-instance";
        working-directory = "inherit";
        window-inherit-working-directory = false;
        desktop-notifications = true;
        auto-update = "off";
        bell-features = "system,audio,attention,no-title,border";

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
          # vim keybinds
          "vim/"
          "alt+escape=activate_key_table:vim"
          "vim/q=deactivate_key_table"
          "vim/shift+q=deactivate_key_table"
          "vim/i=deactivate_key_table"
          "vim/enter=deactivate_key_table"
          "vim/catch_all=ignore"
          "vim/e=scroll_page_lines:1"
          "vim/ctrl+e=scroll_page_lines:1"
          "vim/j=scroll_page_lines:1"
          "vim/y=scroll_page_lines:-1"
          "vim/ctrl+y=scroll_page_lines:-1"
          "vim/k=scroll_page_lines:-1"
          "vim/f=scroll_page_down"
          "vim/ctrl+f=scroll_page_down"
          "vim/b=scroll_page_up"
          "vim/ctrl+b=scroll_page_up"
          "vim/d=scroll_page_fractional:0.5"
          "vim/ctrl+d=scroll_page_fractional:0.5"
          "vim/u=scroll_page_fractional:-0.5"
          "vim/ctrl+u=scroll_page_fractional:-0.5"
          "vim/g=scroll_to_top"
          "vim/shift+g=scroll_to_bottom"
          "vim/slash=start_search"
          "vim/n=navigate_search:next"
          "vim/shift+n=navigate_search:previous"
          "vim/escape=end_search"
          "vim/y=copy_to_clipboard"
          "vim/ctrl+y=copy_to_clipboard:vt"
          "vim/shift+y=copy_to_clipboard:plain"
        ];
      };

  };

  systemd.user.services."ghostty" = {
    Unit = {
      Description = "Ghostty Terminal Emulator";
      After = [
        "graphical-session.target"
        "dbus.socket"
      ];
      Requires = "dbus.socket";
      # TODO: add themes
      X-Reload-Triggers = [ "${config.xdg.configFile."ghostty/config".source}" ];
      X-SwitchMethod = "reload"; # don't restart to prevent closing terminal
    };
    Service = {
      Type = "notify-reload";
      ReloadSignal = "SIGUSR2";
      BusName = "com.mitchellh.ghostty";
      ExecStart = "${lib.getExe config.programs.ghostty.package} --gtk-single-instance=true --initial-window=false --quit-after-last-window-closed=false";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

}
