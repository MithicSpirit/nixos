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
  };

  outputs = inputs:
    inputs.nixpkgs.lib.fix (self: let
      inherit (inputs.nixpkgs) lib;

      eachSystem = lib.genAttrs (import inputs.systems);

      root = ./.;
      overlays = (import ./overlays) inputs;
      args = {inherit inputs root overlays;};

      mergedOverlays = self.overlays.default;
      packages = self.legacyPackages;
    in {
      overlays.default = lib.composeManyExtensions overlays;
      legacyPackages = eachSystem (
        sys: inputs.nixpkgs.legacyPackages.${sys}.extend mergedOverlays
      );

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
      devShells = eachSystem (sys: let
        pkgs = packages.${sys};
      in {
        default = pkgs.mkShell {
          packages = [
            self.formatter.${sys}
            pkgs.deadnix
            pkgs.just
            pkgs.nix-output-monitor
            pkgs.nvd
            pkgs.libnotify
            pkgs.fastfetch
            pkgs.git
          ];
        };
      });

      checks = eachSystem (sys: {
        deadnix =
          packages.${sys}.runCommandLocal "deadnix-check" {
            nativeBuildInputs = [packages.${sys}.deadnix];
          }
          # bash
          ''deadnix --fail '${./.}' | tee -a "$out"'';
        formatter = self.formatter.${sys};
        devShell = self.devShells.${sys}.default;
      });
    });
}
