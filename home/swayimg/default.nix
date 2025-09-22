{ config, root, ... }:
let
  colors = (import (root + /common/colorscheme.nix)).hash;
in
{

  programs.swayimg = {
    enable = true;
    settings = {

      general = {
        size = "image";
        overlay = "yes";
        decoration = "no";
        app_id = "swayimg";
      };

      viewer = rec {
        window = "#00000000";
        transparency = window;
        history = 2;
        preload = 3;
      };

      gallery = {
        preload = "yes";
        pstore = "no";
      };

      list = {
        all = "no";
        fsmon = "yes";
      };

      font = {
        name = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
        size = 12;
        color = colors.fg + "dd";
      };

    };
  };

  xdg.mimeApps.defaultApplicationPackages = [ config.programs.swayimg.package ];

}
