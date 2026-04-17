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

  niri = prev.niri.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "25.11"); {
        patches =
          (prevAttrs.patches or [])
          ++ [
            (final.fetchpatch2 {
              name = "force-render+pr=2609.patch";
              url = "https://github.com/niri-wm/niri/compare/2a9d0e495a011a124b37532dfcfb3c780fd2eb89..e32bf5ebc81137b9f5e8fffda21c0e027a0e9ab6.patch?full_index=1";
              hash = "sha256-2xzosED7ZXnEJi3O/AQStrnVnra/OVvy9bMPSQCSbqc=";
            })
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
              name = "popup-false-positive-fix.patch";
              url = "https://github.com/Supreeeme/xwayland-satellite/commit/8da6c538a5161ad9146d16a325589f8d65774dbd.patch?full_index=1";
              hash = "sha256-l4KwncGQtGnzW0nMgJUY03EEU75kT3ZH6Z/eM7WlT5E=";
            })
          ];
      }
  );
}
