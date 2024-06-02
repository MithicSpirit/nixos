{ ... }: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Overpass" "Iosevka Mithic" "Noto Sans" "Noto Sans CJK" ];
      serif = [ "Latin Modern Roman" "Iosevka Mithic" "Noto Serif" ];
      monospace = [ "Iosevka Mithic" "Overpass Mono" ];
      emoji = [ "Twemoji" "Iosevka Mithic" ];
    };
  };
}
