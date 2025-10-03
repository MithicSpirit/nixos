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

  wireplumber = prev.wireplumber.overrideAttrs (
    _: prevAttrs: {
      patches = (prevAttrs.patches or [ ]) ++ [
        (final.fetchpatch2 {
          name = "ensure-device-valid.patch";
          url = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/commit/ebd9d2a7d55da59e8c16eee6c90b121d64b66ce6.patch";
          hash = "sha256-vac4llMk0VE4o8hEwAA60LzQi8EjSVlB5WDaeGc35gA=";
        })
        (final.fetchpatch2 {
          name = "fix-log-critical.patch";
          url = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/commit/1bde4f2cdf429b2797b12d01074c0890a006877f.patch";
          hash = "sha256-1Vzshfb1yruNHJ/HEIXd9G4Yr1rHwPIjJN5YPbXcRx8=";
        })
      ];
    }
  );

}
