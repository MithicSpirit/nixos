{ nixpkgs }:
{
  firefox-ui-fix = nixpkgs.callPackage ./firefox-ui-fix { };
  iosevka-mithic = nixpkgs.callPackage ./iosevka-mithic { };
  qalcmenu = nixpkgs.callPackage ./qalcmenu { };
  fw-fanctrl = nixpkgs.callPackage ./fw-fanctrl { };
  autotrash = nixpkgs.callPackage ./autotrash { };

  mithic-nvim-unwrapped = nixpkgs.callPackage ./mithic-nvim { };
  mithic-nvim = nixpkgs.callPackage ./mithic-nvim/wrapper.nix { pkgs = nixpkgs; };
}
