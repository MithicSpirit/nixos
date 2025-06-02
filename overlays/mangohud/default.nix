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
    patches = prevAttrs.patches ++ [ ./wayland_keybinds.diff ];
  });
}
