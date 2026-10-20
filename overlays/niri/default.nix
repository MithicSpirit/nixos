final: prev: {
  niri = prev.niri.overrideAttrs (
    finalAttrs: prevAttrs:
      assert prevAttrs.version == "26.04"; {
        version = "26.04-mithic-g${builtins.substring 0 7 finalAttrs.src.rev}";
        dontVersionCheck = true;
        src = final.fetchFromGitHub {
          owner = "MithicSpirit";
          repo = "niri";
          rev = "fbe1e9b4def318afd4d827937f7a8232ef6f75eb";
          hash = "sha256-K+nzVdwsXjpMih9fMtCJ9rOono5Ufek1W0CSa9ZaMYQ=";
        };
        doCheck = false;
        patches = [./niri-scripts.diff];
        cargoDeps = final.rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) pname version src patches;
          hash = "sha256-D6jMOI5Y4JeTiHeRQT71G5gCQJXu6rF2a4lZ4f3AfYI=";
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
}
