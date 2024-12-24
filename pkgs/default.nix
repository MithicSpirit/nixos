{ nixpkgs }:
{
  exiled-exchange-2 = nixpkgs.callPackage ./exiled-exchange-2 { };
  firefox-ui-fix = nixpkgs.callPackage ./firefox-ui-fix { };
  fw-fanctrl = nixpkgs.callPackage ./fw-fanctrl { };
  iosevka-mithic = nixpkgs.callPackage ./iosevka-mithic { };
  qalcmenu = nixpkgs.callPackage ./qalcmenu { };

  mithic-nvim-unwrapped = nixpkgs.callPackage ./mithic-nvim { };
  mithic-nvim = nixpkgs.callPackage ./mithic-nvim/wrapper.nix { pkgs = nixpkgs; };
}
