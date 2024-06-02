{ inputs, ... }: [
  (final: _prev: {
    original = inputs.nixpkgs.legacyPackages.${final.system};
    unstable = inputs.nixpkgs-unstable.legacyPackages.${final.system};
  })
  (import ./pkgs.nix)
  (import ./kitty)
  (import ./nvim.nix { inherit inputs; })
]
