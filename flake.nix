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
      # url = "github:nix-community/home-manager";
      url = "github:MithicSpirit/home-manager/5684-merge2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let

      forAllSystems = nixpkgs.lib.genAttrs (
        builtins.attrNames nixpkgs.legacyPackages
      );

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
