{ lib, config, pkgs, ... }:

{
    options = {
        hyprland.enable 
            = lib.mkEnableOption "enable hyprland";
    };

    config = lib.mkIf config.hyprland.enable (lib.mkMerge [
        (lib.mkIf config.nvidia.enable {
            programs.hyprland = {
                xwayland.enable = true;
            };

            environment = {
                sessionVariables = {
                    NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
                    LIBVA_DRIVER_NAME = "nvidia";
                    XDG_SESSION_TYPE = "wayland";
                    GBM_BACKEND = "nvidia-drm";
                    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                    WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.
                    # ELECTRON_OZONE_PLATFORM_HINT = "auto";
                    # WLR_DRM_NO_ATOMIC,1                    
                };

                systemPackages = with pkgs; [
                    egl-wayland
                ];
            };
        })

        ({
            programs.hyprland.enable = true;

            environment = {
                sessionVariables = {

                };

                systemPackages = with pkgs; [
                    pyprland
                ];
            };
        })
    ]);
}
