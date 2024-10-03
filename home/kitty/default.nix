{ pkgs, root, ... }:
{

  home.sessionVariables."TERMINAL" = "kitty";

  programs.kitty = {
    enable = true;

    settings =
      let
        colors = (import (root + /common/colorscheme.nix)).hash;
      in
      {
        update_check_interval = 0;

        disable_ligatures = "cursor";
        cursor_blink_interval = 0;
        mouse_hide_wait = 0;
        shell_integration = "no-cursor";
        paste_actions = "confirm,confirm-if-large";
        focus_follows_mouse = true;
        window_alert_on_bell = false;
        # TODO: bell_path or linux_bell_theme? if default is not good
        close_on_child_death = true;
        allow_remote_control = "socket";
        listen_on = "unix:@kitty";
        notify_on_cmd_finish = "invisible 0 notify";
        clear_all_shortcuts = true;

        scrollback_lines = 32768;
        scrollback_pager_history_size = 131072;
        touch_scroll_multiplier = "5.0";

        cursor = colors.middle;
        cursor_text_color = "background";
        foreground = colors.base07;
        background = colors.base00;
        background_opacity = "0.93";
        selection_foreground = "none";
        selection_background = colors.fake;
        color0 = colors.base00';
        color1 = colors.base01;
        color2 = colors.base02;
        color3 = colors.base03;
        color4 = colors.base04;
        color5 = colors.base05;
        color6 = colors.base06;
        color7 = colors.base07';
        color8 = colors.base08;
        color9 = colors.base09;
        color10 = colors.base10;
        color11 = colors.base11;
        color12 = colors.base12;
        color13 = colors.base13;
        color14 = colors.base14;
        color15 = colors.base15;
      };

    theme = null; # TODO
    font = {
      package = pkgs.iosevka-mithic;
      name = "Iosevka Mithic";
      size = 12;
    };

    keybindings = {
      # clipboard
      "kitty_mod+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
      "kitty_mod+f" = "paste_from_selection";
      # navigation
      "kitty_mod+h" = "scroll_line_up";
      "kitty_mod+l" = "scroll_line_down";
      "kitty_mod+alt+h" = "scroll_page_up";
      "kitty_mod+alt+l" = "scroll_line_down";
      "kitty_mod+k" = "scroll_to_prompt -1";
      "kitty_mod+j" = "scroll_to_prompt 1";
      "kitty_mod+alt+k" = "scroll_home";
      "kitty_mod+alt+j" = "scroll_end";
      # scrollback
      "kitty_mod+esc" = "show_last_command_output";
      "kitty_mod+alt+esc" = "show_scrollback";
      "kitty_mod+backspace" = "clear_terminal to_cursor active";
      "kitty_mod+alt+backspace" = "clear_terminal reset active";
      # font size
      "kitty_mod+equal" = "change_font_size all +2.0";
      "kitty_mod+plus" = "change_font_size all +2.0";
      "kitty_mod+minus" = "change_font_size all -2.0";
      "kitty_mod+underscore" = "change_font_size all -2.0";
      "kitty_mod+0" = "change_font_size all 0";
      # misc
      "kitty_mod+e" = "open_url_with_hints";
      "kitty_mod+u" = "kitten unicode_input";
    };

    extraConfig = ''
      mouse_map left click ungrabbed mouse_handle_click selection prompt
      mouse_map shift+left click grabbed,ungrabbed mouse_handle_click selection prompt
    '';
  };

}
