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

  wireplumber = prev.wireplumber.overrideAttrs (
    _: prevAttrs: {
      patches = (prevAttrs.patches or [ ]) ++ [
        (final.fetchpatch2 {
          name = "ensure-device-valid.patch";
          url = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/commit/ebd9d2a7d55da59e8c16eee6c90b121d64b66ce6.patch";
          hash = "sha256-vac4llMk0VE4o8hEwAA60LzQi8EjSVlB5WDaeGc35gA=";
        })
        (final.fetchpatch2 {
          name = "fix-log-critical.patch";
          url = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/commit/1bde4f2cdf429b2797b12d01074c0890a006877f.patch";
          hash = "sha256-1Vzshfb1yruNHJ/HEIXd9G4Yr1rHwPIjJN5YPbXcRx8=";
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

}
