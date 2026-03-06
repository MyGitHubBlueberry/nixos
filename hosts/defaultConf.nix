{ config, pkgs, inputs, ... }:

{
     imports =
        [
          ../modules/nixos/nvidia.nix
          ../modules/nixos/windowManager/wm.nix
          ../modules/nixos/gaming.nix
          ../modules/nixos/virtualization.nix
          ../modules/nixos/displayManager.nix
          ../modules/nixos/programming.nix
          ../modules/nixos/autorandr.nix
          ../modules/nixos/laptopLid.nix
          inputs.minegrub-world-sel-theme.nixosModules.default
        ];

      boot.loader = {
          grub = {
              enable = true;
              device = "nodev";
              efiSupport = true;
              useOSProber = true;
              configurationLimit = 10;
              minegrub-world-sel = {
                  enable = true;
                  customIcons = [{
                      name = "nixos";
                      lineTop = "NixOS (23/11/2077, 23:03)";
                      lineBottom = "Survival Mode, No Cheats, Version: 25.05";
                      imgName = "nixos";
                  }];
              };
          };
          efi.canTouchEfiVariables = true;
      };

      boot.initrd.availableKernelModules = [ "usb_storage" "nvme" "ahci" "sd_mod" "sr_mod" "xhci_pci" ];
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      services.gvfs.enable = true;
      services.udisks2.enable = true;

      networking.networkmanager.enable = true;

      time.timeZone = "Europe/Tirane"; #"Europe/Kyiv";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = { LC_ADDRESS = "uk_UA.UTF-8"; LC_IDENTIFICATION = 
          "uk_UA.UTF-8"; LC_MEASUREMENT = "uk_UA.UTF-8"; LC_MONETARY = "uk_UA.UTF-8"; LC_NAME = 
              "uk_UA.UTF-8"; LC_NUMERIC = "uk_UA.UTF-8"; LC_PAPER = "uk_UA.UTF-8"; LC_TELEPHONE = 
              "uk_UA.UTF-8"; LC_TIME = "uk_UA.UTF-8";
      };
      services = {
          xserver = {
              autorun = true;
              enable = true;
              xkb = {
                  layout = "us,ua";
                  options = "grp:win_space_toggle";
              };
              excludePackages = with pkgs; [ xterm ];
          };
          libinput.enable = true;
          libinput.touchpad = {
              naturalScrolling = true;
              scrollMethod = "twofinger";
          };
          printing.enable = true;
          pipewire = {
              enable = true;
              alsa.enable = true;
              alsa.support32Bit = true;
              pulse.enable = true;
              jack.enable = true;
          };
      };

      security.rtkit.enable = true; 

      users.users.maksi = { 
          isNormalUser = true; 
          description = "maksi"; 
          extraGroups = [ "networkmanager" "wheel" "input" ];
          packages = with pkgs; [
          ];
      };

      programs.dconf.enable = true;

      programs.coolercontrol.enable = true;
      programs.kdeconnect.enable = true;

      programs.neovim.enable = true;
      programs.neovim.defaultEditor = true;
      environment.variables.EDITOR = "nvim";
      environment.variables.VISUAL = "nvim";
      environment.variables.XCURSOR_SIZE = "16";

      programs.zsh.enable = true;
      environment.shells = with pkgs; [ zsh ];
      users.defaultUserShell = pkgs.zsh;

      environment.systemPackages = with pkgs; [
          kitty
          telegram-desktop
          brave
          librewolf 
          vivaldi

          xclip
          wl-clipboard
      ];

      fonts.packages = with pkgs; [
          comic-relief
          texlivePackages.cascadia-code
          nerd-fonts.caskaydia-cove
          nerd-fonts.caskaydia-mono
          nerd-fonts.fantasque-sans-mono
          nerd-fonts.tinos
      ];
}
