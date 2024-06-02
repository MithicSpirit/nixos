{ inputs, ... }:
final: _prev:
let unstable = inputs.nixpkgs-unstable.legacyPackages.${final.system};
in {
  neovim = unstable.neovim;
  vimPlugins = unstable.vimPlugins;
}
