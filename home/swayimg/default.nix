{
  config,
  root,
  ...
}: let
  colors = (import (root + /common/colorscheme.nix)).raw;
in {
  programs.swayimg = {
    enable = true;
    initLua =
      # lua
      ''
        swayimg.overlay = true
        swayimg.decoration = true

        local background = 0x00000000 -- black
        swayimg.viewer.set_window_background(background)
        swayimg.viewer.set_image_background(background)

        local hist = 3
        swayimg.viewer.history = hist
        swayimg.viewer.preload = hist

        swayimg.gallery.preload = true
        swayimg.gallery.pstore = true

        swayimg.text.font = "${builtins.head config.fonts.fontconfig.defaultFonts.monospace}"
        swayimg.text.size = 12
        swayimg.text.color = 0xdd${colors.fg}
      '';
  };

  xdg.mimeApps.defaultApplicationPackages = [config.programs.swayimg.package];
}
