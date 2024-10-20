final: prev: {

  tlp = prev.tlp.overrideAttrs (_old: {
    src = final.fetchFromGitHub {
      owner = "linrunner";
      repo = "TLP";
      rev = "feature/bat.d/framework";
      hash = "sha256-UCQ4Tgj5+5dsVAePrVIoOHvPZGmFDTS1ynQ8LCMjR8A=";
    };
  });

}
