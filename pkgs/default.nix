{ nixpkgs }:
{
  exiled-exchange-2 = nixpkgs.callPackage ./exiled-exchange-2 { };
  firefox-ui-fix = nixpkgs.callPackage ./firefox-ui-fix { };
  fw-fanctrl = nixpkgs.callPackage ./fw-fanctrl { };
  mithic-nvim = nixpkgs.callPackage ./mithic-nvim { };
  qalcmenu = nixpkgs.callPackage ./qalcmenu { };
  wait-for-internet = nixpkgs.callPackage ./wait-for-internet { };

  iosevka-mithic-unpatched = nixpkgs.callPackage ./iosevka-mithic-unpatched { };
  iosevka-mithic-patched = nixpkgs.callPackage ./iosevka-mithic-patched { };
  iosevka-mithic = nixpkgs.iosevka-mithic-patched;

  thunderbird-external-editor-revived =
    nixpkgs.callPackage ./thunderbird-external-editor-revived
      { };

}
