{
  config,
  root,
  ...
}: let
  colors = (import (root + /common/colorscheme.nix)).hash;
in {
  programs.swayimg = {
    enable = true;
    initLua =
      # lua
      ''
        -- TODO: see if necessary
        -- local initial_image = swayimg.viewer.current_image()
        -- swayimg.set_window_size(image["width"], image["height"])
        swayimg.enable_overlay(true)
        swayimg.enable_decoration(false)

        local background = 0
        swayimg.viewer.set_window_background(background)
        swayimg.viewer.set_image_background(background)

        local hist = 3
        swayimg.viewer.limit_history(hist)
        swayimg.viewer.limit_preload(hist)

        swayimg.gallery.enable_preload(true)
        swayimg.gallery.enable_pstore(false)

        swayimg.text.set_font("${builtins.head config.fonts.fontconfig.defaultFonts.monospace}")
        swayimg.text.set_size(12)
        swayimg.text.set_foreground()
        font = {
          name = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
          size = 12;
          color = ${colors.fg} + 0xdd000000; -- TODO: use bitwise when available in luajit
        };
      '';
  };

  xdg.mimeApps.defaultApplicationPackages = [config.programs.swayimg.package];
}
