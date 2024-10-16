final: prev: {

  cliphist = prev.cliphist.overrideAttrs (_old: rec {
    version = "0.6.1";
    src = final.fetchFromGitHub {
      owner = "sentriz";
      repo = "cliphist";
      rev = "refs/tags/v${version}";
      sha256 = "sha256-tImRbWjYCdIY8wVMibc5g5/qYZGwgT9pl4pWvY7BDlI=";
    };
    vendorHash = "sha256-gG8v3JFncadfCEUa7iR6Sw8nifFNTciDaeBszOlGntU=";
    passthru.updateScript = final.nix-update-script { };
  });

  bitwarden-desktop = prev.bitwarden-desktop.overrideAttrs (_old: {
    doCheck = false;
  });

}
