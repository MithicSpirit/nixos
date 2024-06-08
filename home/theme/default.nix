{ pkgs, ... }:
let kdep = pkgs.kdePackages;
in {
  # TODO: check whether names are correct

  home.pointerCursor = {
    package = pkgs.libsForQt5.breeze-qt5;
    name = "breeze_cursors";
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      package = pkgs.iosevka-mithic;
      name = "Overpass";
      size = 12;
    };
    iconTheme = {
      package = kdep.breeze-icons;
      name = "breeze-dark";
    };
    theme = {
      package = kdep.breeze-gtk;
      name = "Breeze Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "breeze";
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Overpass" "Iosevka Mithic" "Noto Sans" "Noto Sans CJK" ];
      serif = [ "Latin Modern Roman" "Iosevka Mithic" "Noto Serif" ];
      monospace = [ "Iosevka Mithic" "Overpass Mono" ];
      emoji = [ "Twemoji" "Iosevka Mithic" ];
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
  ];

}
