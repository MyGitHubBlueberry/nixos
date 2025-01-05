{ lib, config, pkgs, ... }:

{
    options = {
        virtualization.enable 
            = lib.mkEnableOption "enable virtualization";

    };

    config = lib.mkIf config.virtualization.enable {
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
