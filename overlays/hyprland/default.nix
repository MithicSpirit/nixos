_final: prev: {
  hyprland = prev.hyprland.overrideAttrs (prevAttrs: {
    patches = (prevAttrs.patches or [ ]) ++ [ ./forceidle.patch ];
  });
}
