{ nixpkgs }: {
  firefox-ui-fix = nixpkgs.callPackage ./firefox-ui-fix { };
  iosevka-mithic = nixpkgs.callPackage ./iosevka-mithic { };
  qalcmenu = nixpkgs.callPackage ./qalcmenu { };
  mithic-nvim = import ./mithic-nvim { pkgs = nixpkgs; };
}
