final: prev: {
  mangohud = prev.mangohud.overrideAttrs (prevAttrs: {
    version = "0.8.1-r2272.gd1a7096";
    src = final.fetchFromGitHub {
      owner = "flightlessmango";
      repo = "MangoHud";
      rev = "d1a70966ef822b7fb5e60736488cc9540da35992";
      fetchSubmodules = true;
      hash = "sha256-RsQxvl4C2neKBnltNf2rBPpcyDwW+V7V1qXFF4cryRY=";
    };
    patches = (prevAttrs.patches or [ ]) ++ [
      (final.fetchpatch {
        name = "fix-wayland-keybinds";
        url = "https://github.com/flightlessmango/MangoHud/commit/ccf973659e5b7d5cfc1b67635bcc03c0abf0f9d2.diff";
        hash = "sha256-gk1Ix0hndhLr+2ZB0k9Oq07pE18LQJxLH2TQ9k2bmcA=";
      })
    ];
  });
}
