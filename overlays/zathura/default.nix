final: prev: {
  zathuraPkgs = prev.zathuraPkgs.overrideScope (
    _finalScope: prevScope: {

      zathura_core = prevScope.zathura_core.overrideAttrs (prevAttrs: {
        version = "0.5.11-r3116.g69c9e6c";
        src = final.fetchFromGitHub {
          owner = "pwmt";
          repo = "zathura";
          rev = "69c9e6c5e31e00756bd8358eee79c4eef5ebc3e5";
          hash = "sha256-/6VS2fNllDhh4kU68FdKt/tYWRvq4ebMVdb0GDGxO28=";
        };
        patches = (prevAttrs.patches or [ ]) ++ [
          (final.fetchpatch {
            name = "recolor-lightness";
            url = "https://github.com/pwmt/zathura/commit/a3c8dc86c94a85fcec3ba3d4f1f7dc393217b7d8.diff";
            hash = "sha256-wSZ0Z4QSfomT87i+Ya0Jh50ze7xht5Uj7nRM7TuZBSY=";
          })
        ];
      });

    }
  );
}
