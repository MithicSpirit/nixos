final: prev: {

  mpv-unwrapped = prev.mpv-unwrapped.overrideAttrs (
    _: prevAttrs: {
      patches = (prevAttrs.patches or [ ]) ++ [
        (final.fetchpatch2 {
          name = "wayland-clipboard-lag-fix.patch";
          url = "https://github.com/mpv-player/mpv/commit/d20ded876d27497d3fe6a9494add8106b507a45c.patch?full_index=1";
          hash = "sha256-IKXTUF0+pmwO4Lt5cr+i6KOCCU1Sv9vDp1+IHOwM8UY=";
        })
      ];
    }
  );

  vimPlugins = prev.vimPlugins // {
    nvim-lspconfig = final.vimUtils.buildVimPlugin {
      pname = "nvim-lspconfig";
      version = "2025-09-14";
      src = final.fetchFromGitHub {
        owner = "neovim";
        repo = "nvim-lspconfig";
        rev = "78174f395e705de97d1329c18394831737d9a4b4";
        hash = "sha256-GpA7tCY/Fqd50sGa7SP7+LVCSHg4NmJVsSoKrdkFVeY=";
      };
      meta.homepage = "https://github.com/neovim/nvim-lspconfig/";
      meta.hydraPlatforms = [ ];
    };
  };

  btop = prev.btop.overrideAttrs (
    _: prevAttrs: {
      patches = (prevAttrs.patches or [ ]) ++ [
        (final.fetchpatch2 {
          name = "revert-io-btrfs-regression.patch";
          url = "https://github.com/aristocratos/btop/commit/845d2cb0663de0b0c0cfac1af43bea934203e3dc.patch?full_index=1";
          hash = "sha256-gLDiXYE98u1Y5OrJumCkdNsdAlvUVfnl62nRr8dTZkU=";
        })
      ];
    }
  );

  hyprland = prev.hyprland.overrideAttrs (
    _: prevAttrs: {
      patches = (prevAttrs.patches or [ ]) ++ [
        (final.fetchpatch2 {
          name = "forceidle-dispatcher.patch";
          url = "https://github.com/hyprwm/Hyprland/commit/59ff7b2f891d06f4097128faf7027a3863542167.patch?full_index=1";
          hash = "sha256-w+tJ5rour7/FP2jMi6/YU8mEOPLybGyy3P9lN2lcVfI=";
        })
        ./hyprland-activewindow-contenttype.diff
      ];
    }
  );

}
