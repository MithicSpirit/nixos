final: prev: {

  gamemode = prev.gamemode.overrideAttrs (prevAttrs: {
    version = "${prevAttrs.version}-mithic";
    patches = (prevAttrs.patches or [ ]) ++ [
      (final.fetchpatch {
        name = "platform-profile";
        url = "https://github.com/FeralInteractive/gamemode/compare/1d9c1e6a72355dc2fc2947961489ad4d95375fb4..fb7776764be3ad071e6a1ed4bfa55ec9fc22a23d.diff";
        hash = "sha256-nQ7XPY/8uztBP30xfAXhLYsh1U7vH6nThYb4+rfxGHM=";
      })
      (final.fetchpatch {
        name = "platform-profile-fix";
        url = "https://github.com/FeralInteractive/gamemode/commit/01c1e80c96d41a16306223fed55a2ee1af30fc99.diff";
        hash = "sha256-oSno9uo5hHYH9Bff8HP74YBcnSBiSu6DMbX+Bji9aII=";
      })
      (final.fetchpatch {
        name = "restart";
        url = "https://github.com/FeralInteractive/gamemode/commit/056af542dd7538c94df01f915123bd3d19e89bab.diff";
        hash = "sha256-hMBjgrhexakRpWhEE9y3svWSt28S70+/Pl74rB8WJAs=";
      })
    ];
  });

}
