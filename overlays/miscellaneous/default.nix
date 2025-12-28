final: prev: {

  vimPlugins = prev.vimPlugins // {
    nvim-lspconfig = final.vimUtils.buildVimPlugin {
      inherit (prev.vimPlugins.nvim-lspconfig) pname meta;
      version = "2025-09-14";
      src = final.fetchFromGitHub {
        owner = "neovim";
        repo = "nvim-lspconfig";
        rev = "78174f395e705de97d1329c18394831737d9a4b4";
        hash = "sha256-GpA7tCY/Fqd50sGa7SP7+LVCSHg4NmJVsSoKrdkFVeY=";
      };
    };
  };

  btop = prev.btop.overrideAttrs (
    _finalAttrs: prevAttrs:
    assert prevAttrs.version == "1.4.5";
    {
      patches = (prevAttrs.patches or [ ]) ++ [
        (final.fetchpatch2 {
          name = "revert-io-btrfs-regression.patch";
          url = "https://github.com/aristocratos/btop/commit/845d2cb0663de0b0c0cfac1af43bea934203e3dc.patch?full_index=1";
          hash = "sha256-gLDiXYE98u1Y5OrJumCkdNsdAlvUVfnl62nRr8dTZkU=";
        })
      ];
    }
  );

  tzupdate =
    assert prev.tzupdate.version == "3.1.0";
    final.rustPlatform.buildRustPackage {
      inherit (prev.tzupdate) pname meta;
      version = "3.1.0-24-g91d65d8";
      src = final.fetchFromGitHub {
        owner = "cdown";
        repo = "tzupdate";
        rev = "91d65d861c4e10d2353357edfd33158197e8dc09";
        hash = "sha256-XWl0erykdn8mHFczr8jPkjk7jgNOXndmMNrV6QKb0jY=";
      };
      cargoHash = "sha256-96lD0Sc2hdhNKeIS4zkiG4J0dxEFt6/Np7HHMSoF8j4=";
    };

  gamemode = prev.gamemode.overrideAttrs (
    _finalAttrs: prevAttrs:
    assert prevAttrs.version == "1.8.2";
    {
      version = "1.8.2-18-g4ce5f21";
      src = final.fetchFromGitHub {
        owner = "FeralInteractive";
        repo = "gamemode";
        rev = "4ce5f2193a12766046ba9261da02429e8af72cf3";
        hash = "sha256-qf3Co5ASR65jEcQqCY/mt3bzQ7z6vKXXh7hrBhJ5EvA=";
      };
    }
  );

  rustup = prev.rustup.overrideAttrs (
    _finalAttrs: prevAttrs:
    assert (prevAttrs.version == "1.28.2");
    {
      doCheck = false;
    }
  );

  ghostty = prev.ghostty.overrideAttrs (
    _finalAttrs: prevAttrs:
    assert (prevAttrs.version == "1.3.0-dev");
    {
      patches = (prevAttrs.patches or [ ]) ++ [
        # HACK: https://github.com/ghostty-org/ghostty/pull/10004
        ./ghostty-dedupe-wheel-events.diff
        # (final.fetchpatch2 {
        #   name = "disinflate-wheel-events+pr=10004.patch";
        #   url = "https://github.com/ghostty-org/ghostty/pull/10004/commits/0883553ac0a9877d19183d2659b455eb82a3c390.patch?full_index=1";
        #   hash = "sha256-ks8xBjQmagB+w7CYMWLgJ+TTS1tH1uQ11SqvN9OQrok=";
        # })
        ./ghostty-fix-braille.diff
      ];
    }
  );

}
