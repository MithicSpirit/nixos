{ nixpkgs }:
{
  firefox-ui-fix = nixpkgs.callPackage ./firefox-ui-fix { };
  iosevka-mithic = nixpkgs.callPackage ./iosevka-mithic { };
  qalcmenu = nixpkgs.callPackage ./qalcmenu { };
  mithic-nvim-unwrapped = nixpkgs.callPackage ./mithic-nvim { };
  mithic-nvim = nixpkgs.callPackage ./mithic-nvim/wrapper.nix { pkgs = nixpkgs; };
  fw-fanctrl = nixpkgs.callPackage ./fw-fanctrl { };
}
