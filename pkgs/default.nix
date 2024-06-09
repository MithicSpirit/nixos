{ nixpkgs }: {
  iosevka-mithic = nixpkgs.callPackage ./iosevka-mithic { };
  mithic-nvim = import ./mithic-nvim { pkgs = nixpkgs; };
}
