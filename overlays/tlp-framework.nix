final: prev: {

  tlp = prev.tlp.overrideAttrs (
    new: _old: {
      version = "1.8.0-beta.1";
      src = final.fetchFromGitHub {
        owner = "linrunner";
        repo = "TLP";
        rev = new.version;
        hash = "sha256-Rnf99NgzCfJa22ZOP+Nhd5cuTY9Jf6Rrc19y0lVwEUE=";
      };
    }
  );

}
