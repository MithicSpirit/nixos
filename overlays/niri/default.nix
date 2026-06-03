final: prev: {
  niri = prev.niri.overrideAttrs (
    finalAttrs: prevAttrs:
      assert prevAttrs.version == "26.04"; {
        patches =
          (prevAttrs.patches or [])
          ++ [
            ./${"force-render+pr=2609.diff"}
            ./prevent-idle-inhibit.diff
            ./layer-priority.diff
            ./click-inhibit.diff
            ./default-column-maximize.diff
            ./directional-column-operations.diff
            ./xdg-toplevel-tag.diff
            ./ignore-client-size.diff
          ];
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
}
