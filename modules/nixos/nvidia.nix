{ lib, config, pkgs, ... }:

{
    options = {
        nvidia.enable 
            = lib.mkEnableOption "enable nvidia support";

    };

    config = lib.mkIf config.nvidia.enable {
        boot.kernelModules = [ "nvidia" "nvidia_uvm" "nvidia_modeset" "nvidia_drm" ];
        boot.kernelParams = [ "nvidia-drm.modeset=1" ];
        boot.extraModprobeConfig = ''
            options nvidia_modeset vblank_sem_control=0 nvidia 
            '';
        # NVreg_TemporaryFilePath=/var/tmp
        # NVreg_PreserveVideoMemoryAllocations=1 caused issues
        services.xserver.videoDrivers = [ "nvidia" ]; 

        hardware.graphics = {
            enable = true;
            enable32Bit = true;
        };

        hardware.nvidia = {
            modesetting.enable = true;
            # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
            # Enable this if you have graphical corruption issues or application crashes after waking
            # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
            # of just the bare essentials.
            powerManagement.enable = true;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.beta;
        };
    };
}
