{ lib, config, pkgs, ... }:

{
    options.programming.enable = lib.mkEnableOption "add packages for programming";

    config = lib.mkIf config.programming.enable {
        services.mysql = {
          enable = true;
          package = pkgs.mariadb;
        };
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
            angular-language-server
            tailwindcss
            tailwindcss-language-server

            cargo
            rust-analyzer
            rustfmt
            rustc
            rustlings

            dotnet-ef
            dotnet-sdk_9
            csharp-ls

            vscode-langservers-extracted
            emmet-ls

            typescript-language-server
            typescript

            sqls

            lemminx #xml
        ];

        programs.nix-ld.enable = true;
        programs.nix-ld.libraries = with pkgs; [
          stdenv.cc.cc
          zlib
        ];

        environment.sessionVariables = {
            DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
        };
    };
}
