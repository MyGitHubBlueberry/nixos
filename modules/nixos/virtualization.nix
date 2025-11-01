{ lib, config, pkgs, ... }:

{
    options = {
        virtualization.enable 
            = lib.mkEnableOption "enable virtualization";

    };

    config = lib.mkIf config.virtualization.enable {
        boot.kernelParams = [ "kvm.enable_virt_at_load=0" ]; #temp workaround
          virtualisation.virtualbox = {
              host = {
                  enable = true; 
                  enableExtensionPack = true;
              };
              guest = {
                  enable = false; #was true and caused long loading time when rebuild switch
                  dragAndDrop = true;
              };
          };

          users.extraGroups.vboxusers.members = [ "maksi" ];
    };
}
