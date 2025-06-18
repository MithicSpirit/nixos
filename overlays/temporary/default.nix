final: prev: {

  vimPlugins = prev.vimPlugins.extend (
    finalScope: prevScope: {

      vimtex = prevScope.vimtex.overrideAttrs (prevAttrs: {
        version = "2025-06-12";
        src = final.fetchFromGitHub {
          owner = "lervag";
          repo = "vimtex";
          rev = "4b4f18b1b181cdea35fdc418e5eb511f20e1f0fb";
          hash = "sha256-O4lkgNRx+YPG4BWTaA7UwzTUjGewEM/vHXj6O3MBl7c=";
        };
      });

    }
  );

}
