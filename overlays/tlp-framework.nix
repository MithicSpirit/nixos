final: prev: {

  tlp = prev.tlp.overrideAttrs (_old: {
    version = "1.7.0-framework";
    src = final.fetchFromGitHub {
      owner = "linrunner";
      repo = "TLP";
      rev = "860057646b5d7ef4b726f7ce03a14baeca8b90d1";
      hash = "sha256-NjYa964criPD0DVQtSDOlCS8bNb7S1TWDBqHJ7GhnuU=";
    };
  });

}
