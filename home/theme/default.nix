{
  pkgs,
  config,
  lib,
  ...
}:
{
  # TODO: check whether names are correct

  home.pointerCursor = {
    package = pkgs.libsForQt5.breeze-qt5;
    name = "breeze_cursors";
    size = 32;
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

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = 1
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = config.gtk.gtk3.extraConfig;

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };

  # use dark theme for gtk4
  xdg.configFile."gtk-4.0/gtk.css".text =
    let
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
    style.name = "breeze";
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [
        "Overpass"
        "Iosevka Mithic"
        "Noto Sans"
        "Noto Sans CJK"
      ];
      serif = [
        "Latin Modern Roman"
        "Iosevka Mithic"
        "Noto Serif"
      ];
      monospace = [
        "Iosevka Mithic"
        "Overpass Mono"
      ];
      emoji = [
        "Twemoji"
        "Iosevka Mithic"
      ];
    };
  };

  home.packages = with pkgs; [
    iosevka-mithic
    overpass
    lmodern
    lmmath
    noto-fonts
    noto-fonts-cjk-sans
    twemoji-color-font
    dejavu_fonts
    julia-mono
  ];

}
