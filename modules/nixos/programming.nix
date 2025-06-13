{ lib, config, pkgs, ... }:

{
    options.programming.enable = lib.mkEnableOption "add packages for programming";

    config = lib.mkIf config.programming.enable {
        environment.systemPackages = with pkgs; [
            git
            unzip
            wget

            yazi

            man-pages
            ripgrep
            pkg-config

            gdb
            valgrind
            gnumake

            clang
            clang-tools
            libcxx
            gcc
            libgcc
            glibc

            python3
            pyright
            python312Packages.python-lsp-server
            lua-language-server
            bash-language-server
            nodejs_22

            cargo
            rust-analyzer
            rustfmt
            rustc
            rustlings
        ];
    };
}
