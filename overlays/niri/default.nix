final: prev: {
  niri = prev.niri.overrideAttrs (
    finalAttrs: prevAttrs:
      assert prevAttrs.version == "26.04"; {
        version = "26.04-mithic-g${builtins.substring 0 7 finalAttrs.src.rev}";
        dontVersionCheck = true;
        src = final.fetchFromGitHub {
          owner = "MithicSpirit";
          repo = "niri";
          rev = "28d6a25783800ab9b6df6452711b04337d98f0db";
          hash = "sha256-xUTQ+epNww/Lm6mX6O4Y5dciKT5ND2QzpgqmJK4YZFY=";
        };
        patches = [./niri-force-render-v2.diff];
        doCheck = false;
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
              hash = "sha256-exZXFLLlSx44ZOlLqdFY4Qp63U2E01Gm664XcvBh1Yo=";
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
