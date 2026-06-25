{ lib, config, pkgs, ... }:
let
default = "docked";
laptopScreenEdid = "00ffffffffffff000daec91400000000081a0104951f11780228659759548e271e505400000001010101010101010101010101010101b43b804a71383440503c680035ad10000018000000fe004e3134304843412d4541420a20000000fe00434d4e0a202020202020202020000000fe004e3134304843412d4541420a20003e";
externalMonitorEdid = "00ffffffffffff0005e30324952100002e22010380351e782a9f05aa534fa3250d5054bfef00d1c0b3009500818081c0010101010101023a801871382d40582c45000f282100001e000000fd0030781e8c1c000a202020202020000000fc003234423331480a202020202020000000ff0041555952363941303038353937019a020321b14b101f05140413031202110167030c001000003c681a000001013078e6605980a070381440302035000f282100001e314480a070382740302035000f282100001a011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018406b80a070381440302035000f282100001e0000000084";
in 
{
    options = {
        laptopLid.enable = lib.mkEnableOption {
            description = "Enable handling of laptop lid closure with second monitor";
            default = false;
        };
    };
    config = lib.mkIf config.laptopLid.enable {
        assertions = [
        {
            assertion = config.autorandr.laptopDocStation.enable;
            message = "autorandr laptop doc stations is requiered module";
        }
        ];
        services.acpid = {
            enable = true;
            lidEventCommands = ''
                if echo "$1" | grep -iq "open"; then
                    echo "LID opened at $(date)" >> /tmp/lid.log
                    ${pkgs.autorandr}/bin/autorandr -l dualScreen >> /tmp/lid.log 2>&1
                    # eww open bar --screen=1 >> /tmp/lid.log 2>&1
                elif echo "$1" | grep -iq "close"; then
                    echo "LID closed at $(date)" >> /tmp/lid.log
                    ${pkgs.autorandr}/bin/autorandr -l docked >> /tmp/lid.log 2>&1
                    # eww close bar >> /tmp/lid.log 2>&1
                fi
            '';
        };
        services.logind.settings.Login = lib.mkForce {
            HandleLidSwitch = "ignore";
            HandleLidSwitchDocked = "ignore";
            HandleLidSwitchExternalPower = "ignore";
        };


        systemd.user.services.lid-monitor = {
            description = "Handle lid open/close (xrandr)";
            wantedBy = [ "graphical-session.target" ];
            enable = true;

            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.bash}/bin/bash -c '
                    export DISPLAY=:0
                    export XAUTHORITY=$HOME/.Xauthority

                    journalctl -f -u systemd-logind --output=cat | while read -r line; do
                        if echo \"$line\" | grep -qi \"Lid closed\"; then
                            echo \"closed\" >> /tmp/lid.log
                            xrandr --output eDP-1 --off >> /tmp/lid.log 2>&1
                        elif echo \"$line\" | grep -qi \"Lid opened\"; then
                            echo \"opened\" >> /tmp/lid.log
                            xrandr --output eDP-1 --auto >> /tmp/lid.log 2>&1
                        fi
                    done
                '";
            };
        };
    };
}
