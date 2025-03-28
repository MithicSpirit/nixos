{ nixpkgs }:
{
  exiled-exchange-2 = nixpkgs.callPackage ./exiled-exchange-2 { };
  firefox-ui-fix = nixpkgs.callPackage ./firefox-ui-fix { };
  fw-fanctrl = nixpkgs.callPackage ./fw-fanctrl { };
  iosevka-mithic = nixpkgs.callPackage ./iosevka-mithic { };
  mithic-nvim = nixpkgs.callPackage ./mithic-nvim { };
  qalcmenu = nixpkgs.callPackage ./qalcmenu { };
  thunderbird-external-editor-revived =
    nixpkgs.callPackage ./thunderbird-external-editor-revived
      { };
}
