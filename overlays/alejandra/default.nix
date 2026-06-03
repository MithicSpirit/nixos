_final: prev: {
  alejandra = prev.alejandra.overrideAttrs (
    _finalAttrs: prevAttrs:
      assert prevAttrs.version == "4.0.0"; {
        patches = (prevAttrs.patches or []) ++ [./alejandra-adblock.diff];
        doCheck = false;
      }
  );
}
