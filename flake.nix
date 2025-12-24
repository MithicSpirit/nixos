{
  description = "MithicSpirit's Nix Configurations";

  inputs = {

    systems.url = "github:nix-systems/default";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware.url = "github:NixOS/nixos-hardware";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit.follows = ""; # used for dev only
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-utils.inputs.systems.follows = "systems";
        flake-compat.follows = ""; # compat not needed
      };
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs:
    let
      inherit (inputs) nixpkgs;

      eachSystem = nixpkgs.lib.genAttrs (import inputs.systems);

      root = ./.;
      overlays = (import ./overlays) inputs;
      mergedOverlays = nixpkgs.lib.composeManyExtensions overlays;

      packages = eachSystem (
        sys: nixpkgs.legacyPackages.${sys}.extend mergedOverlays
      );

      treefmt = eachSystem (
        sys:
        inputs.treefmt-nix.lib.evalModule packages.${sys} {
          projectRootFile = "flake.nix";
          settings = {
            on-unmatched = "info";
            verbose = 0;
          };
          programs.nixfmt.enable = true;
          settings.formatter.nixfmt.options = [
            "--width=80"
            "--verify"
          ];
        }
      );

      args = { inherit inputs root overlays; };
    in
    {

      overlays.default = mergedOverlays;
      legacyPackages = packages;

      nixosConfigurations = {

        hipparchus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = args;
          modules = [ ./systems/hipparchus ];
        };

      };

      homeConfigurations = {

        hipparchus."mithic" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs;
          extraSpecialArgs = args;
          modules = [ ./systems/hipparchus/home/mithic.nix ];
        };

      };

      formatter = eachSystem (sys: treefmt.${sys}.config.build.wrapper);

    };
}
