final: prev: {

  gamemode = prev.gamemode.overrideAttrs {
    version = "1.8.2_r18_g4ce5f21";
    src = final.fetchFromGitHub {
      owner = "FeralInteractive";
      repo = "gamemode";
      rev = "4ce5f2193a12766046ba9261da02429e8af72cf3";
      hash = "sha256-qf3Co5ASR65jEcQqCY/mt3bzQ7z6vKXXh7hrBhJ5EvA=";
    };
  };

}
