inputs: [
  (import ./pkgs.nix)
  ((import ./inputs.nix) inputs)
  (import ./miscellaneous)

  (import ./bluez)
  (import ./sway)
  (import ./zathura)
]
