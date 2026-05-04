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

  grimblast = prev.grimblast.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "0.1-unstable-2026-02-19"); {
        patches = (prevAttrs.patches or []) ++ [./grimblast-fix-lock.diff];
      }
  );

  alejandra = prev.alejandra.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "4.0.0"); {
        patches = (prevAttrs.patches or []) ++ [./alejandra-adblock.diff];
        doCheck = false;
      }
  );

  niri = prev.niri.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "26.04"); {
        patches =
          (prevAttrs.patches or [])
          ++ [
            ./${"niri-force-render+pr=2609.diff"}
            ./niri-prevent-idle-inhibit.diff
            ./niri-layer-priority.diff
          ];
      }
  );

  waybar = prev.waybar.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "0.15.0"); {
        patches =
          (prevAttrs.patches or [])
          ++ [
            ./waybar-niri-workspaces-hides.diff
            ./waybar-niri-workspaces-format-named.diff
          ];
      }
  );

  texlab = prev.texlab.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "5.25.1"); {
        patches =
          (prevAttrs.patches or [])
          ++ [
            (final.fetchpatch2 {
              name = "bibitem-fix.patch";
              url = "https://github.com/latex-lsp/texlab/commit/74461ae08fbaef54f0254ddfa40505ff6e2ee0a8.patch?full_index=1";
              hash = "sha256-7f4RtwcokwO769mqzBuigmXUXJZCIkSdiJY3LOYyXss=";
            })
          ];
        doCheck = false;
      }
  );

  xwayland-satellite = prev.xwayland-satellite.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "0.8.1"); {
        patches =
          (prevAttrs.patches or [])
          ++ [
            (final.fetchpatch2 {
              name = "popup-fix+pr=424.patch";
              url = "https://github.com/Supreeeme/xwayland-satellite/compare/a879e5e0896a326adc79c474bf457b8b99011027..cae1b1157931a978315f0b1815005def8132d6d1.patch?full_index=1";
              hash = "sha256-meBh85SWI1RvhI1K96rtIaL3XxOoiAFAmjOfapQ+Gqc=";
            })
          ];
      }
  );
}
