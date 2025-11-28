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
        ./hyprland-activewindow-contenttype.diff
      ];
    }
  );

  tzupdate = final.rustPlatform.buildRustPackage {
    inherit (prev.tzupdate) pname version meta;
    src = final.fetchFromGitHub {
      owner = "cdown";
      repo = "tzupdate";
      rev = "91d65d861c4e10d2353357edfd33158197e8dc09";
      hash = "sha256-XWl0erykdn8mHFczr8jPkjk7jgNOXndmMNrV6QKb0jY=";
    };
    cargoHash = "sha256-96lD0Sc2hdhNKeIS4zkiG4J0dxEFt6/Np7HHMSoF8j4=";
  };

}
