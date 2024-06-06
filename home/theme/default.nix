{ pkgs, ... }:
let kdep = pkgs.kdePackages;
in {
  # TODO: check whether names are correct

  home.pointerCursor = {
    package = kdep.breeze-icons;
    name = "breeze_cursors";
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      package = pkgs.iosevka-mithic;
      name = "Iosevka Mithic";
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

}
