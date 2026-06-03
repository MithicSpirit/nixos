inputs: [
  ((import ./inputs.nix) inputs)
  (import ./pkgs.nix)

  (import ./miscellaneous)

  (import ./alejandra)
  (import ./bluez)
  (import ./niri)
  (import ./sway)
  (import ./zathura)
]
