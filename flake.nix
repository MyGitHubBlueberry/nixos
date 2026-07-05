{
    description = "NixOS config flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
        caelestia-shell = {
            url = "github:caelestia-dots/shell";
            inputs.nixpkgs.follows = "nixpkgs"; 
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
        system = "x86_64-linux";
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.permittedInsecurePackages = [
                "electron-36.9.5"
            ];
        };

        mkSystem = config:
            nixpkgs.lib.nixosSystem {
              inherit pkgs;
              specialArgs = { inherit inputs; };
              modules = [
                  config
                  ./hosts/defaultConf.nix
              ];
            };
        mkHome = config:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = { inherit inputs; };
              modules = [ config ./hosts/defaultHome.nix];
            };
    in {
        nixosConfigurations = {
            pc = mkSystem ./hosts/pc/configuration.nix;
            laptop = mkSystem ./hosts/laptop/configuration.nix;
        }; 
        homeConfigurations = {
            "maksi@pc" = mkHome ./hosts/pc/home.nix;
            "maksi@laptop" = mkHome ./hosts/laptop/home.nix;
        };
    };
}
