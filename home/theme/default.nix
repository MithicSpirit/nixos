{
  pkgs,
  config,
  lib,
  ...
}: {
  # TODO: check whether names are correct

  home.pointerCursor = {
    package = pkgs.kdePackages.breeze;
    name = "breeze_cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  xresources.path = "${config.xdg.configHome}/Xresources";

  gtk = {
    enable = true;
    font = {
      package = pkgs.overpass;
      name = "Overpass";
      size = 12;
    };
    iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze-dark";
    };
    theme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze";
    };
    colorScheme = "dark";

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = 1
    '';

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };

  # use dark theme for gtk4
  xdg.configFile."gtk-4.0/gtk.css".text = let
    cfg = config.gtk;
  in
    lib.mkForce ''
      @import url("file://${cfg.theme.package}/share/themes/${cfg.theme.name}-Dark/gtk-4.0/gtk.css");
      ${cfg.gtk4.extraCss}'';

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "Fusion";
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = let
      standard = "Iosevka Mithic";
    in {
      sansSerif = [
        "Overpass"
        "Libtertinus Sans"
        standard
        "Noto Sans"
        "Noto Sans CJK"
      ];
      serif = [
        "Libertinus Serif"
        "Latin Modern Roman"
        standard
        "Noto Serif"
      ];
      monospace = [
        standard
        "Overpass Mono"
      ];
      emoji = [
        "Twemoji"
        standard
      ];
    };
  };

  home.packages = with pkgs; [
    iosevka-mithic
    overpass
    lmodern
    lmmath
    liberation_ttf
    libertinus
    noto-fonts
    noto-fonts-cjk-sans
    twemoji-color-font
    dejavu_fonts
    julia-mono
    winePackages.fonts
  ];
}
