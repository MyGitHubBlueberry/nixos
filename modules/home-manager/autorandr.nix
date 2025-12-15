{ lib, config, ... }:
let
  laptopScreenEdid = "00ffffffffffff000daec91400000000081a0104951f11780228659759548e271e505400000001010101010101010101010101010101b43b804a71383440503c680035ad10000018000000fe004e3134304843412d4541420a20000000fe00434d4e0a202020202020202020000000fe004e3134304843412d4541420a20003e";
  externalMonitorEdid = "00ffffffffffff0005e30324952100002e22010380351e782a9f05aa534fa3250d5054bfef00d1c0b3009500818081c0010101010101023a801871382d40582c45000f282100001e000000fd0030781e8c1c000a202020202020000000fc003234423331480a202020202020000000ff0041555952363941303038353937019a020321b14b101f05140413031202110167030c001000003c681a000001013078e6605980a070381440302035000f282100001e314480a070382740302035000f282100001a011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018406b80a070381440302035000f282100001e0000000084";
in 
{
  options = {
    autorandr.laptopDocStation.enable = lib.mkEnableOption {
      description = "Enable autorandr with laptop config";
      default = false;
    };
  };

  config = lib.mkIf config.autorandr.laptopDocStation.enable {
    services.autorandr = {
      enable = true;
      matchEdid = true;
      ignoreLid = true;
    };

    programs.autorandr = {
      enable = true;

      profiles = {
        mobile = {
          fingerprint = {
            eDP-1 = laptopScreenEdid;
          };

          config = {
            eDP-1 = {
              enable = true;
              primary = true;
              mode = "1920x1080";
              rate = "60.00";
            };
          };
        };

        docked = {
          fingerprint = {
            HDMI-2 = externalMonitorEdid;
          };

          config = {
            eDP-1.enable = false;

            HDMI-2 = {
              enable = true;
              primary = true;
              mode = "1920x1080";
              rate = "120.00";
            };
          };
        };

        dualScreen = {
          fingerprint = {
              eDP-1 = laptopScreenEdid;
              HDMI-2 = externalMonitorEdid;
          };

          config = {
            eDP-1 = {
              enable = true;
              mode = "1920x1080";
              rate = "60.00";
              position = "0x0";
            };

            HDMI-2 = {
              enable = true;
              primary = true;
              mode = "1920x1080";
              rate = "120.00";
              position = "1920x0";
            };
          };
        };
      };
    };

    # services.logind = lib.mkForce {
    #   lidSwitch = "ignore";
    #   lidSwitchDocked = "ignore";
    #   lidSwitchExternalPower = "ignore";
    # };
  };
}
