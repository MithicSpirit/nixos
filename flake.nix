{
  description = "MithicSpirit's Nix Configurations";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware.url = "github:NixOS/nixos-hardware";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = ""; # used for dev only
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      systems,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let

      forAllSystems = nixpkgs.lib.genAttrs (import systems);

      root = ./.;
      overlays = (import ./overlays) inputs;
      mergedOverlays = nixpkgs.lib.composeManyExtensions overlays;

      packages = forAllSystems (
        system: nixpkgs.legacyPackages.${system}.extend mergedOverlays
      );

      args = {
        inherit inputs root overlays;
      };

    in
    {

      overlays.default = mergedOverlays;

      legacyPackages = packages;

      formatter = forAllSystems (system: packages.${system}.nixfmt-rfc-style);

      nixosConfigurations = {

        hipparchus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = args;
          modules = [ ./systems/hipparchus ];
        };

      };

      homeConfigurations = {

        hipparchus."mithic" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs;
          extraSpecialArgs = args;
          modules = [ ./systems/hipparchus/home/mithic.nix ];
        };

      };

    };
}
