{ lib, config, pkgs, ... }:

{
    options.programming.enable = lib.mkEnableOption "add packages for programming";

    config = lib.mkIf config.programming.enable {
        environment.systemPackages = with pkgs; [
            btop
            tree

            nixd

            git
            unzip
            wget

            #yazi in homemanager

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

            dotnet-sdk_9
            csharp-ls

            sqls

            lemminx #xml
        ];

        environment.sessionVariables = {
            DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
        };
    };
}
