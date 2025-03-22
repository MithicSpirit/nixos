final: prev: {

  gamemode = prev.gamemode.overrideAttrs (prevAttrs: {
    version = "${prevAttrs.version}-mithic";
    patches = (prevAttrs.patches or [ ]) ++ [
      (final.fetchpatch {
        name = "platform-profile";
        url = "https://patch-diff.githubusercontent.com/raw/FeralInteractive/gamemode/pull/517.diff";
        hash = "sha256-nQ7XPY/8uztBP30xfAXhLYsh1U7vH6nThYb4+rfxGHM=";
      })
      (final.fetchpatch {
        name = "platform-profile-fix";
        url = "https://patch-diff.githubusercontent.com/raw/FeralInteractive/gamemode/pull/526.diff";
        hash = "sha256-oSno9uo5hHYH9Bff8HP74YBcnSBiSu6DMbX+Bji9aII=";
      })
      (final.fetchpatch {
        name = "restart";
        url = "https://patch-diff.githubusercontent.com/raw/FeralInteractive/gamemode/pull/521.diff";
        hash = "sha256-hMBjgrhexakRpWhEE9y3svWSt28S70+/Pl74rB8WJAs=";
      })
    ];
  });

}
