final: prev: {

  gamemode = prev.gamemode.overrideAttrs (
    _finalAttrs: prevAttrs: {
      version = "${prevAttrs.version}-mithic";
      patches = (prevAttrs.patches or [ ]) ++ [
        (final.fetchpatch {
          name = "platform-profile";
          url = "https://patch-diff.githubusercontent.com/raw/FeralInteractive/gamemode/pull/517.patch";
          hash = "sha256-jxRj7wvMmDi+D+BeZo8ZEVseG6yCXhEmgil+QfukdHw=";
        })
        (final.fetchpatch {
          name = "restart";
          url = "https://patch-diff.githubusercontent.com/raw/FeralInteractive/gamemode/pull/521.patch";
          hash = "sha256-hMBjgrhexakRpWhEE9y3svWSt28S70+/Pl74rB8WJAs=";
        })
      ];
    }
  );

}
