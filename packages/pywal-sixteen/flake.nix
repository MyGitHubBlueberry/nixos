{
  description = "A huge collection of Rofi based custom Applets, Launchers & Powermenus.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
      packages.${system} = {
          pywal16 = pkgs.callPackage ./. {}; #extra inputs
          default = self.packages.${system}.pywal16;
      };
  };
}
