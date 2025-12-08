{ nixpkgs }:
{
  firefox-ui-fix = nixpkgs.callPackage ./firefox-ui-fix { };
  fw-fanctrl = nixpkgs.callPackage ./fw-fanctrl { };
  mithic-nvim = nixpkgs.callPackage ./mithic-nvim { };
  qalcmenu = nixpkgs.callPackage ./qalcmenu { };
  wait-for-internet = nixpkgs.callPackage ./wait-for-internet { };

  awakened-poe-trade = nixpkgs.callPackage ./awakened-poe-trade { };
  exiled-exchange-2 = nixpkgs.callPackage ./exiled-exchange-2 { };

  iosevka-mithic-unpatched = nixpkgs.callPackage ./iosevka-mithic-unpatched { };
  iosevka-mithic-patched = nixpkgs.callPackage ./iosevka-mithic-patched { };
  iosevka-mithic = nixpkgs.iosevka-mithic-patched;
}
