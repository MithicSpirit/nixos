final: prev: {
  niri = prev.niri.overrideAttrs (
    finalAttrs: prevAttrs:
      assert prevAttrs.version == "26.04"; {
        version = "26.04-mithic-g${builtins.substring 0 7 finalAttrs.src.rev}";
        dontVersionCheck = true;
        src = final.fetchFromGitHub {
          owner = "MithicSpirit";
          repo = "niri";
          rev = "41c371bca62d683a9caa5024da56f787c0549428";
          hash = "sha256-5EgyffKL+eftKIzwKVGJ/rWRTkaiKkUKILVKyg3k0/c=";
        };
        doCheck = false;
        patches = [./niri-scripts.diff];
        cargoDeps = final.rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) pname version src patches;
          hash = "sha256-CKDrLgPo5efuiv2eGiAPhcbEMeOJiDyfGfGtq4wEuPE=";
        };
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

  xwayland-satellite = prev.xwayland-satellite.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert prevAttrs.version == "0.8.2"; {
        patches =
          (prevAttrs.patches or [])
          ++ [
            (final.fetchpatch2 {
              # https://github.com/Supreeeme/xwayland-satellite/pull/494
              name = "xwayland-satellite-override-redirect-fix.diff";
              url = "https://github.com/Supreeeme/xwayland-satellite/commit/add2795134593faafce60e404a0a75df68e9ee0c.diff?full_index=1";
              hash = "sha256-6QOZsE4/OoYjzNlzkzMmx6d9rcuh66AHjTBUqHnAWxU=";
            })
          ];
      }
  );
}
