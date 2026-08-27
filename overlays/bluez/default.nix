final: _prev: {
  bluez-mpris-proxy = final.bluez.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert prevAttrs.version == "5.87"; {
        patches =
          (prevAttrs.patches or [])
          ++ [
            ./mpris-proxy-disable-player.diff
          ];
      }
  );
}
