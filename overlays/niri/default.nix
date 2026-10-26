final: prev: {
  niri = prev.niri.overrideAttrs (
    finalAttrs: prevAttrs:
      assert prevAttrs.version == "26.04"; {
        version = "26.04-mithic-g${builtins.substring 0 7 finalAttrs.src.rev}";
        dontVersionCheck = true;
        src = final.fetchFromGitHub {
          owner = "MithicSpirit";
          repo = "niri";
          rev = "f7d350fd0cb537277cdf3b1157e6e5803be07595";
          hash = "sha256-GnWy0yz2xRnVmatypbjWUunv1GlqKENLN5z1ZLkiTYw=";
        };
        doCheck = false;
        patches = [./niri-scripts.diff];
        buildFeatures =
          (prevAttrs.buildFeatures or [])
          ++ ["profile-with-tracy-allocations" "profile-with-tracy-ondemand"];
        cargoDeps = final.rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) pname version src patches;
          hash = "sha256-NXnkxL8/Ttb++ZjYM6+/X3m0IrZwk7Tnv6NtaznhsN4=";
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
