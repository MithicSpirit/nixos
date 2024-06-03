{ inputs, ... }:
final: _prev:
let unstable = inputs.nixpkgs-unstable.legacyPackages.${final.system};
in {
  neovim = unstable.neovim;
  neovim-unwrapped = unstable.neovim-unwrapped;
  vimPlugins = unstable.vimPlugins;
}
