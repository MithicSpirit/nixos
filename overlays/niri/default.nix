final: prev: {
  niri = prev.niri.overrideAttrs (
    finalAttrs: prevAttrs:
      assert prevAttrs.version == "26.04"; let
        git = "cba857622fb76ee3e4e2d78c76d6848eb0595d35";
      in {
        version = "26.04-r30-mithic-g${builtins.substring 0 7 git}";
        dontVersionCheck = true;
        src = final.fetchFromGitHub {
          owner = "MithicSpirit";
          repo = "niri";
          rev = git;
          hash = "sha256-Yw4VqHRUyLYKncSAvXnFEEbDBXlhoRcuLQoxGQtlT3w=";
        };
        cargoDeps = final.rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) pname version src patches;
          hash = "sha256-Bf05zLPdtPTyXJW9AgcnCgGSmyIfuL7tfzMmmSJJqW8=";
        };
      }
  );

  xwayland-satellite = prev.xwayland-satellite.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert prevAttrs.version == "0.8.1"; {
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

  waybar = prev.waybar.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert prevAttrs.version == "0.15.0"; {
        patches =
          (prevAttrs.patches or [])
          ++ [
            ./waybar-workspaces-hides.diff
            ./waybar-workspaces-format-named.diff
            ./waybar-graceful-disconnect.diff
          ];
      }
  );
}
