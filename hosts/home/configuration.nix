# Edit this configuration file to define what should be installed on your system.  Help is 
# available in the configuration.nix(5) man page and in the NixOS manual (accessible by 
# running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
 imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix 
      ../../modules/nixos/nvidia.nix
      ../../modules/nixos/hyprland.nix
      ../../modules/nixos/gaming.nix
      ../../modules/nixos/virtualization.nix
    ];

  nvidia.enable = true;
  gaming.enable = true;

  virtualization.enable = true;

  # Enable Desktop Environment.
  hyprland.enable = false;

  # Bootloader.
  boot.loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = ["nvidia_uvm" "nvidia_modeset" "nvidia_drm" "nvidia"];
  boot.initrd.availableKernelModules = [ "usb_storage" "nvme" "ahci" "sd_mod" "sr_mod" "xhci_pci" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # adding flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary networking.proxy.default = 
  # "http://user:password@proxy:port/"; networking.proxy.noProxy = 
  # "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = { LC_ADDRESS = "uk_UA.UTF-8"; LC_IDENTIFICATION = 
    "uk_UA.UTF-8"; LC_MEASUREMENT = "uk_UA.UTF-8"; LC_MONETARY = "uk_UA.UTF-8"; LC_NAME = 
    "uk_UA.UTF-8"; LC_NUMERIC = "uk_UA.UTF-8"; LC_PAPER = "uk_UA.UTF-8"; LC_TELEPHONE = 
    "uk_UA.UTF-8"; LC_TIME = "uk_UA.UTF-8";
  };

  #for usb to automount
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  # Enable the X11 windowing system.
  services = {
      xserver = {
          autorun = true;
          enable = true;
          xkb = {
              layout = "us,ua";
              options = "grp:win_space_toggle";
          };

          windowManager.i3.enable = true;
          desktopManager.gnome.enable = false;
          displayManager.gdm = {
              enable = true;
              wayland = true;
              banner = "NixOS, btw...";

              autoSuspend = true;
          };
      };

      displayManager.sddm = {
          enable = false; #disable gdm before turning on
          wayland.enable = true; 
          theme = "${import ../../packages/sddm-sugar-dark/default.nix { inherit pkgs; }}";
      };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true; #removed in unstable
  security.rtkit.enable = true; 
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # If you want to use JACK applications, uncomment this jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by 
    # default, no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager). 
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maksi = { 
    isNormalUser = true; 
    description = "maksi"; 
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs.coolercontrol = {
    enable = false; #on unstable branch
    nvidiaSupport = true;
  };


  programs.dconf.enable = true;
  # make nvim defalut
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # make zsh default
  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
  # Do not forget to add an editor to edit configuration.nix! The Nano editor is also 
  #  installed by default. wget
    gparted

    eww
    kitty

    wl-clipboard

    git
    unzip
    wget
    ripgrep

    cargo
    brave

    clang
    python3
    nodePackages.pyright
    python312Packages.python-lsp-server
    lua-language-server
    rust-analyzer
    nodejs_22

    librewolf 
    telegram-desktop

    #screenshots
    grim
    slurp
    swappy
    jq #for geometry for window screenshots

    #sddm theme dependencies
    libsForQt5.qt5.qtquickcontrols2   
    libsForQt5.qt5.qtgraphicaleffects
  ];

  # Some programs need SUID wrappers, can be configured further or are started in user 
  # sessions. programs.mtr.enable = true; programs.gnupg.agent = {
  #   enable = true; enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon. services.openssh.enable = true;

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ]; 
  # networking.firewall.allowedUDPPorts = [ ... ]; Or disable the firewall altogether. 
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default settings for stateful 
  # data, like file locations and database versions on your system were taken. It‘s 
  # perfectly fine and recommended to leave this value at the release version of the first 
  # install of this system. Before changing this value read the documentation for this 
  # option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
