final: prev: {
  zathuraPkgs = prev.zathuraPkgs.overrideScope (
    _finalScope: prevScope: {

      zathura_core = prevScope.zathura_core.overrideAttrs (_prevAttrs: {
        version = "0.5.11-r3120.g11f1b8d";
        src = final.fetchFromGitHub {
          owner = "pwmt";
          repo = "zathura";
          rev = "11f1b8daa31f66875dfe0c0d9838fd60abda9a5a";
          hash = "sha256-iANTSXZgFP5HsAqnBcM0dNWOP+NiR3LZ8JhWMevo7iY=";
        };
      });

    }
  );
}
