inputs: _final: prev: let
  inherit (prev.stdenv.hostPlatform) system;
in {
  inherit (inputs.disko.packages."${system}") disko-install;
  inherit (inputs.ghostty.packages."${system}") ghostty;
}
