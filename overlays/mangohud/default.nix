final: prev: {
  mangohud = prev.mangohud.overrideAttrs (_prevAttrs: {
    version = "0.8.1_r98_g246700e";
    src = final.fetchFromGitHub {
      owner = "flightlessmango";
      repo = "MangoHud";
      rev = "246700e722a05c5c77b03b8b3a200345a135645b";
      fetchSubmodules = true;
      hash = "sha256-nTVVrQpwmSKJk2CeLiCeyPFde9Xrn8lFh6PhU666WtU=";
    };
  });
}
