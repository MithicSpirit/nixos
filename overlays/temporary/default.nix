final: prev: {

  mpv-unwrapped = prev.mpv-unwrapped.overrideAttrs (
    _: prevAttrs: {
      patches = (prevAttrs.patches or [ ]) ++ [
        (final.fetchpatch2 {
          name = "wayland-clipboard-lag-fix.patch";
          url = "https://github.com/mpv-player/mpv/commit/d20ded876d27497d3fe6a9494add8106b507a45c.patch?full_index=1";
          hash = "sha256-IKXTUF0+pmwO4Lt5cr+i6KOCCU1Sv9vDp1+IHOwM8UY=";
        })
      ];
    }
  );

}
