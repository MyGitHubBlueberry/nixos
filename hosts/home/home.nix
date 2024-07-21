{ config, pkgs, ... }:
let 
    myAliases = {
        ".." = "cd ..";
        la = "ls -a";
    };

    gtkColors = ''
        @import './gtk-colors.css';
    '';
in

{
    imports = [
        ../../modules/home-manager/hyprconfig.nix
        ../../modules/home-manager/notifications/mako.nix
        # ../../modules/home-manager/notifications/dunst.nix
    ];

    hyprconfig.enable = true;
    mako.enable = false;

    home.username = "maksi";
    home.homeDirectory = "/home/maksi";


# targets.genericLinux.enable = true; #for non NixOS distros

# This value determines the Home Manager release that your configuration is
# compatible with. This helps avoid breakage when a new Home Manager release
# introduces backwards incompatible changes.
#
# You should not change this value, even if you update Home Manager. If you do
# want to update the value, then make sure to first check the Home Manager
# release notes.
    home.stateVersion = "24.05"; # Please read the comment before changing.

    home.packages = with pkgs; [
#for i3
    xclip
    feh
    picom
    polybar
    dunst
    xorg.xmodmap
#for i3

    thunderbird

    #tubes :)
    spotube

    onlyoffice-bin

    todo

    waybar
    libnotify #dependency
    swww #wallpaper
    rofi-wayland #app access

    #file manager
    dolphin
    libsForQt5.kio-extras
    mako

    pavucontrol #audio settings

    wallust
    # libsForQt5.qtstyleplugin-kvantum #qt app themes
    # gradience #handles gtk themes
    # wpgtk

    zoom-us
# # It is sometimes useful to fine-tune packages, for example, by applying
# # overrides. You can do that directly here, just don't forget the
# # parentheses. Maybe you want to install Nerd Fonts with a limited number of
# # fonts?
    (nerdfonts.override { fonts = [ "CascadiaCode" "CascadiaMono" "FantasqueSansMono"  "Tinos"]; })

# # You can also create simple shell scripts directly inside your
# # configuration. For example, this adds a command 'my-hello' to your
# # environment:
# (pkgs.writeShellScriptBin "my-hello" ''
#   echo "Hello, ${config.home.username}!"
# '')
   ];

# Home Manager is pretty good at managing dotfiles. The primary way to manage
# plain files is through 'home.file'.
    home.file = {
        ".config/wal/templates/colors-nix.yaml".source = ../../dotfiles/pywal/colors-nix.yaml;
        ".config/wal/templates/colors-hyprland.conf".source = ../../dotfiles/pywal/colors-hyprland.conf;

        ".config/wallust".source = ../../dotfiles/wallust;
        # ".config/wallust/wallust.toml".source = ../../dotfiles/wallust/wallust.toml;
        # ".config/wallust/wallust/templates".source = ../../dotfiles/wallust/templates;
        ".config/swappy/config".source = ../../dotfiles/swappy;
        ".config/hypr/pyprland.toml".source = ../../dotfiles/pyprland.toml;
# # Building this configuration will create a copy of 'dotfiles/screenrc' in
# # the Nix store. Activating the configuration will then make '~/.screenrc' a
# # symlink to the Nix store copy.
# ".screenrc".source = dotfiles/screenrc;

# # You can also set the file content immediately.
# ".gradle/gradle.properties".text = ''
#   org.gradle.console=verbose
#   org.gradle.daemon.idletimeout=3600000
# '';
    };

# Home Manager can also manage your environment variables through
# 'home.sessionVariables'. If you don't want to manage your shell through Home
# Manager then you have to manually source 'hm-session-vars.sh' located at
# either
#
#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  /etc/profiles/per-user/maksi/etc/profile.d/hm-session-vars.sh
#
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
    
    # enables kvantum override for qt
    # qt = {
    #     enable = true;
    #     platformTheme.name = "qtct";
    #     style.name = "kvantum";
    # };

    gtk = {
        enable = true;

        theme.package = pkgs.whitesur-gtk-theme;
        theme.name = "WhiteSur-Dark"; #"FlatColor"; #breaks waybar? "WhiteSur-Dark"; 

        cursorTheme.package = pkgs.bibata-cursors;
        cursorTheme.name = "Bibata-Modern-Classic";
        cursorTheme.size = 16;
        
        iconTheme.package = pkgs.tela-circle-icon-theme;
        iconTheme.name = "Tela-circle"; #"flattrcolor";

        font.package = pkgs.cascadia-code;
        font.name = "CascadiaCodeNF-Regular";
        font.size = 10;
    };

    # xdg.configFile."gtk-4.0/gtk.css" = {
    #     text = gtkColors;
    # };
    #
    # xdg.configFile."gtk-3.0/gtk.css" = {
    #     text = gtkColors;
    # };

    # xdg.configFile."xsettingsd/xsettingsd.conf" = {
    #     text = ''Net/ThemeName "FlatColor"'';
    # };

    programs = {
        bash = {
            enable = true;
            shellAliases = myAliases;
        };

        zsh = {
            enable = true;
            shellAliases = myAliases;
            autosuggestion.enable = true;
            enableCompletion = true;
        };

        starship = {
            enable = true;
            settings = {
#toml file here ;)
# add_newline = false;

# character = {
#   success_symbol = "[➜](bold green)";
#   error_symbol = "[➜](bold red)";
# };

# package.disabled = true;
            };

        };

        git = {
            enable = true;
            userName  = "MyGitHubBlueberry";
            userEmail = "MyGitHubBlueberry@gmail.com";
        };
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
