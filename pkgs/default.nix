{ nixpkgs }: {
  iosevka-mithic = nixpkgs.callPackage ./iosevka-mithic { };
  firefox-ui-fix = nixpkgs.callPackage ./firefox-ui-fix { };
  mithic-nvim = import ./mithic-nvim { pkgs = nixpkgs; };
}
