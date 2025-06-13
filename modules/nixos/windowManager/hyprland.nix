{ lib, config, pkgs, ... }:

let
  cfg = config.windowManager;
in
{
  options.windowManager.hyprland.enable = lib.mkEnableOption "enable hyprland";

  config = lib.mkIf (cfg.enable && cfg.hyprland.enable) (lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.hyprland.enable && cfg.i3.enable);
          message = "Hyprland and i3 cannot be enabled at the same time.";
        }
      ];
    }

    (lib.mkIf config.nvidia.enable {
      programs.hyprland = {
        xwayland.enable = true;
      };

      environment = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          LIBVA_DRIVER_NAME = "nvidia";
          XDG_SESSION_TYPE = "wayland";
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          WLR_NO_HARDWARE_CURSORS = "1";
        };

        systemPackages = with pkgs; [
          egl-wayland
        ];
      };
    })

    {
      programs = {
          hyprland.enable = true;
          hyprlock.enable = true;
      };

      environment = {
          sessionVariables = {
              HYPRCURSOR_SIZE = "16";
          };

          systemPackages = with pkgs; [
              pyprland
              swww #wallpaper
              socat #for eww
              mako #notifications
              libnotify #mako dependency
#screenshots
              grim
              slurp
              jq
          ];
      };
    }
    ]);
}
