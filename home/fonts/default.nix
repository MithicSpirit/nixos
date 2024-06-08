{ pkgs, ... }: {

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
