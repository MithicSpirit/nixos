final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      nvim-lspconfig = final.vimUtils.buildVimPlugin {
        inherit (prev.vimPlugins.nvim-lspconfig) pname meta;
        version = "2025-09-14";
        src = final.fetchFromGitHub {
          owner = "neovim";
          repo = "nvim-lspconfig";
          rev = "78174f395e705de97d1329c18394831737d9a4b4";
          hash = "sha256-GpA7tCY/Fqd50sGa7SP7+LVCSHg4NmJVsSoKrdkFVeY=";
        };
      };
    };

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

  ghostty = prev.ghostty.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "1.3.0"); {
        patches =
          (prevAttrs.patches or [])
          ++ [
            # HACK: https://github.com/ghostty-org/ghostty/pull/10004
            ./ghostty-dedupe-wheel-events.diff
            # (final.fetchpatch2 {
            #   name = "disinflate-wheel-events+pr=10004.patch";
            #   url = "https://github.com/ghostty-org/ghostty/pull/10004/commits/0883553ac0a9877d19183d2659b455eb82a3c390.patch?full_index=1";
            #   hash = "sha256-ks8xBjQmagB+w7CYMWLgJ+TTS1tH1uQ11SqvN9OQrok=";
            # })
            ./ghostty-fix-braille.diff
          ];
        doCheck = false;
      }
  );

  grimblast = prev.grimblast.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "0.1-unstable-2026-02-19"); {
        patches =
          (prevAttrs.patches or [])
          ++ [
            ./grimblast-fix-lock.diff
          ];
      }
  );

  alejandra = prev.alejandra.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "4.0.0"); {
        patches = (prevAttrs.patches or []) ++ [./alejandra-adblock.diff];
        doCheck = false;
      }
  );

  hyprland = prev.hyprland.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "0.54.2"); {
        patches =
          (prevAttrs.patches or [])
          ++ [
            ./hyprland-group-set-always.diff
          ];
      }
  );

  niri = prev.niri.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "25.11"); {
        patches =
          (prevAttrs.patches or [])
          ++ [
            (final.fetchpatch2 {
              name = "force-render+pr=2609.patch";
              url = "https://github.com/niri-wm/niri/compare/2a9d0e495a011a124b37532dfcfb3c780fd2eb89..36c4cc0aab659116104f59749cde3c04818afcb8.patch?full_index=1";
              hash = "sha256-DcgnCbyRanJ7CjP/WoEHszcaRBEjqVmoeEW0lOfGqXI=";
            })
            ./niri-pr2609-fix.diff
            ./niri-strut-proportional.diff
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
          ];
      }
  );
}
