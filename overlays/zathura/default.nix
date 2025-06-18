final: prev: {
  zathuraPkgs = prev.zathuraPkgs.overrideScope (
    _finalScope: prevScope: {

      zathura_core = prevScope.zathura_core.overrideAttrs (_prevAttrs: {
        version = "0.5.11-r3120.g7eeb6cb";
        src = final.fetchFromGitHub {
          owner = "pwmt";
          repo = "zathura";
          rev = "7eeb6cb03f99f92ca8dd53df582603935c2c77dc";
          hash = "sha256-gU6yuDInnwYYeTk3XUCHSgjciPnC3w4WlVmjySuroF8=";
        };
      });

    }
  );
}
