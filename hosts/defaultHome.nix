{ config, pkgs, ... }:
let 
    myAliases = {
        ".." = "cd ..";
        la = "ls -a";
    };

    gtkColors = ''
        @import './gtk-colors.css';
    '';

    notifyWhenFinished = ''
        precmd() {
            echo -ne "\a"
        }
    '';
in

{
    imports = [
        ../modules/home-manager/hyprconfig.nix
        ../modules/home-manager/notifications/mako.nix
        ../modules/home-manager/autorandr.nix
    ];

    home.file = {
        ".config/wal/templates/colors-nix.yaml".source = ../dotfiles/pywal/colors-nix.yaml;
        ".config/wal/templates/colors-hyprland.conf".source = ../dotfiles/pywal/colors-hyprland.conf;
        ".config/wallust".source = ../dotfiles/wallust;
# ".config/wallust/wallust.toml".source = ../dotfiles/wallust/wallust.toml;
# ".config/wallust/templates".source = ../dotfiles/wallust/templates;
        ".config/swappy/config".source = ../dotfiles/swappy;
        ".config/hypr/pyprland.toml".source = ../dotfiles/pyprland.toml;
    };

    home.sessionVariables = {
        TERM = "kitty";
        TERMINAL = "kitty";
    };

    home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
    };

    xresources.extraConfig = ''
#include "/home/maksi/.cache/wallust/colors.Xresources"
        '';    

    gtk = {
        enable = true;

        theme.package = pkgs.whitesur-gtk-theme;
        theme.name = "WhiteSur-Dark"; 

        cursorTheme.package = pkgs.bibata-cursors;
        cursorTheme.name = "Bibata-Modern-Classic";
        cursorTheme.size = 16;

        iconTheme.package = pkgs.tela-circle-icon-theme;
        iconTheme.name = "Tela-circle";

        font.package = pkgs.cascadia-code;
        font.name = "CascadiaCodeNF-Regular";
        font.size = 10;
    };

    programs = {
        yazi = {
            enable = true;
            shellWrapperName = "y";
            enableZshIntegration = true;
            enableBashIntegration = true;
        };
        bash = {
            enable = true;
            shellAliases = myAliases;
            initExtra = notifyWhenFinished;
        };

        zsh = {
            enable = true;
            shellAliases = myAliases;
            autosuggestion.enable = true;
            enableCompletion = true;
            initContent = notifyWhenFinished;
        };

        starship.enable = true;

        git = {
            enable = true;
            userName  = "MyGitHubBlueberry";
            userEmail = "MyGitHubBlueberry@gmail.com";
        };
    };

    nixpkgs.config.allowUnfree = true;
    programs.home-manager.enable = true;
}
