final: prev: {

  gamemode = prev.gamemode.overrideAttrs {
    version = "1.8.2-platformprofile";
    src = final.fetchFromGitHub {
      owner = "MithicSpirit";
      repo = "gamemode";
      rev = "badb27b646f0680abc14b35a013b0eff7b52e27d";
      hash = "sha256-CDm4FWLe/NWrZuHHTLQp87fxm7hheiSgnM1pbAkU+i4=";
    };
  };

}
