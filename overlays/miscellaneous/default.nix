final: prev: {
  tzupdate = assert prev.tzupdate.version == "3.1.0";
    final.rustPlatform.buildRustPackage {
      inherit (prev.tzupdate) pname meta;
      version = "3.1.0-24-g91d65d8";
      src = final.fetchFromGitHub {
        owner = "cdown";
        repo = "tzupdate";
        rev = "91d65d861c4e10d2353357edfd33158197e8dc09";
        hash = "sha256-XWl0erykdn8mHFczr8jPkjk7jgNOXndmMNrV6QKb0jY=";
      };
      cargoHash = "sha256-96lD0Sc2hdhNKeIS4zkiG4J0dxEFt6/Np7HHMSoF8j4=";
    };

  gamemode = prev.gamemode.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert prevAttrs.version == "1.8.2"; {
        version = "1.8.2-18-g4ce5f21";
        src = final.fetchFromGitHub {
          owner = "FeralInteractive";
          repo = "gamemode";
          rev = "4ce5f2193a12766046ba9261da02429e8af72cf3";
          hash = "sha256-qf3Co5ASR65jEcQqCY/mt3bzQ7z6vKXXh7hrBhJ5EvA=";
        };
      }
  );

  vimPlugins = prev.vimPlugins.extend (_self: super: {
    vim-fugitive = super.vim-fugitive.overrideAttrs (_finalAttrs: prevAttrs:
      assert prevAttrs.version == "3.7-unstable-2026-03-07"; {
        patches =
          (prevAttrs.patches or [])
          ++ [./fugitive-use-pager-config.diff];
      });
  });

  # https://github.com/NixOS/nixpkgs/pull/508732
  nerd-font-patcher = prev.nerd-font-patcher.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert !(prevAttrs ? postPatch); {
        postPatch = ''
          substituteInPlace font-patcher \
            --replace-fail "'glyphnames.json'" "'../share/glyphnames.json'"
        '';
        installPhase =
          prevAttrs.installPhase
          + # bash
          ''
            install -Dm644 glyphnames.json $out/share/glyphnames.json
          '';
      }
  );
}
