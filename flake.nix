{
    description = "NixOS config flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
        mkSystem = config:
            nixpkgs.lib.nixosSystem {
              inherit pkgs;
              specialArgs = { inherit inputs; };
              modules = [
                  config
                  ./hosts/default.nix
              ];
            };
    in {
        nixosConfigurations = {
            pc = mkSystem ./hosts/pc/configuration.nix;
        }; 
        homeConfigurations.maksi = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ 
                ./hosts/pc/home.nix
            ];
        };
    };
}
