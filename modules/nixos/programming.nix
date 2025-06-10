{ lib, config, pkgs, ... }:

{
    options.programming.enable = lib.mkEnableOption "add packages for programming";

    config = lib.mkIf config.programming.enable {
        environment.systemPackages = with pkgs; [
            git
            unzip
            wget
            ripgrep
            man-pages
            cargo
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
            rust-analyzer
            rustfmt
            rustc
            rustlings
            nodejs_22
        ];
    };
}
