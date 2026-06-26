{
  description = "MithicSpirit's Nix Configurations";

  inputs = {
    systems.url = "github:nix-systems/default-linux"; # don't support macos

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = ""; # used for dev only
      };
    };

    disko = {
      url = "github:nix-community/disko/v1.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        niri-unstable.follows = ""; # unused
        xwayland-satellite-unstable.follows = ""; # unused
      };
    };
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;

    eachSystem = lib.genAttrs (import inputs.systems);

    root = ./.;
    overlays = (import ./overlays) inputs;
    mergedOverlays = lib.composeManyExtensions overlays;

    packages = eachSystem (
      sys: inputs.nixpkgs.legacyPackages.${sys}.extend mergedOverlays
    );

    args = {inherit inputs root overlays;};
  in {
    overlays.default = mergedOverlays;
    legacyPackages = packages;

    nixosConfigurations = {
      hipparchus = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = args;
        modules = [./systems/hipparchus];
      };
    };

    homeConfigurations = {
      hipparchus."mithic" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs;
        extraSpecialArgs = args;
        modules = [./systems/hipparchus/home/mithic.nix];
      };
    };

    formatter = eachSystem (sys: packages.${sys}.alejandra);
    checks = eachSystem (sys: {
      deadnix =
        packages.${sys}.runCommandLocal "deadnix-check" {
          nativeBuildInputs = [packages.${sys}.deadnix];
        }
        # bash
        ''
          deadnix --fail '${./.}' | tee -a "$out"
        '';
    });
  };
}
