{ lib, config, pkgs, ... }:

{
    options.programming.enable = lib.mkEnableOption "system services for programming (mysql, nix-ld)";

    config = lib.mkIf config.programming.enable {
        services.mysql = {
            enable = true;
            package = pkgs.mariadb;
        };

        programs.nix-ld.enable = true;
        programs.nix-ld.libraries = with pkgs; [
            stdenv.cc.cc
            zlib
        ];
    };
}
