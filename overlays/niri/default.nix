_final: prev: {
  niri = prev.niri.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert (prevAttrs.version == "26.04"); {
        patches =
          (prevAttrs.patches or [])
          ++ [
            ./${"force-render+pr=2609.diff"}
            ./prevent-idle-inhibit.diff
            ./layer-priority.diff
            ./click-inhibit.diff
            ./default-column-maximize.diff
            ./directional-column-operations.diff
          ];
      }
  );
}
