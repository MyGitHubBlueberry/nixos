{
    description = "NixOS config flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05"; #nixos-unstable"; 
        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
            inherit system;

            config = {
                allowUnfree = true;
            };
        };
    in {
        nixosConfigurations.nixos = lib.nixosSystem {
            inherit system;
            modules = [ 
                ./hosts/home/configuration.nix 
            ];
        };

        homeConfigurations.maksi = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ 
                ./hosts/home/home.nix
            ];
        };
    };
}
