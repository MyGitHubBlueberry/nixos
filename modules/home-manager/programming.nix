{ lib, config, pkgs, ... }:

{
    options.programming.enable = lib.mkEnableOption "dev tools and language servers";

    config = lib.mkIf config.programming.enable {
        home.packages = with pkgs; [
            rtk

            btop
            tree

            nixd

            unzip
            wget

            man-pages
            ripgrep
            pkg-config

            gdb
            valgrind
            gnumake

            clang
            clang-tools
            libcxx
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

        home.sessionVariables = {
            DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
        };
    };
}
