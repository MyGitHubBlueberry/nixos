{ pkgs, lib, config, ... }:

{
    options = {
        hyprconfig.enable 
            = lib.mkEnableOption "enable hyprland config";
    };


    config = lib.mkIf config.hyprconfig.enable {
        mako.enable = !config.caelestia.enable;
        services.hypridle = {
            enable = true;
            settings = {
                general = {
                    after_sleep_cmd = "hyprctl dispatch dpms on";
                    ignore_dbus_inhibit = false;
                    lock_cmd = "caelestia shell lock lock";  #todo: when merged iwth system make it an if statement between that and hyprlock
                };

                listener = [
                    {
                        timeout = 90;
                        on-timeout = "hyprctl dispatch dpms off";
                        on-resume = "hyprctl dispatch dpms on";
                    }
                    {
                        timeout = 120;
                        on-timeout = "loginctl lock-session";
                    }
                    {
                        timeout = 180;
                        on-timeout = "systemctl suspend";
                    }
                ];
            };
      };
      wayland.windowManager.hyprland = {
          enable = true;
          configType = "hyprlang";
          systemd.variables = ["--all"];
          xwayland.enable = true;

          settings = {
              source = "/home/maksi/nixos/modules/home-manager/colors-hyprland.conf";

              monitor = [
                  ",1920x1080@120,auto,1"
                  "Unknown-1, disable"
              ];

              input = {
                  kb_layout = "us, ua";
                  kb_options = "grp:win_space_toggle, MOD5:alt";

                  follow_mouse = 0;

                  touchpad = {
                      natural_scroll = true;
                  };

                  sensitivity = 0;
              };

              general = {
                  gaps_in = 5;
                  gaps_out = 5;
                  border_size = 2;
                  "col.active_border" = "$color14 $color12 $color11 $color12 $color14 45deg";
                  "col.inactive_border" = "$color8";

                  layout = "dwindle";

                  allow_tearing = false;
              };

              decoration = {
                  dim_inactive = true;
                  dim_strength = 0.1;
                  rounding = 15;
                  blur = {
                      enabled = true;
                      size = 3;
                      passes = 1;
                  };
                  shadow = {
                      enabled = true;
                      range = 6;
                  };
              };

              animations = {
                  enabled = "yes";
                  bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
                  animation = [
                      "windows, 1, 7, myBezier"
                      "windowsOut, 1, 7, default, popin 80%"
                      "border, 1, 10, default"
                      "borderangle, 1, 8, default"
                      "fade, 1, 7, default"
                      "workspaces, 1, 6, default"
                  ];
              };

              misc = {
                  force_default_wallpaper = 0;
                  disable_splash_rendering = true;
                  disable_hyprland_logo = true;

              };

              "$mod" = "Alt";

              bind = [
                  "$mod, h, exec, ~/nixos/scripts/hypr_groups.sh focus l"
                  "$mod, l, exec, ~/nixos/scripts/hypr_groups.sh focus r"
                  "$mod, k, exec, ~/nixos/scripts/hypr_groups.sh focus u"
                  "$mod, j, exec, ~/nixos/scripts/hypr_groups.sh focus d"

                  "$mod SHIFT, h, exec, ~/nixos/scripts/hypr_groups.sh move l"
                  "$mod SHIFT, l, exec, ~/nixos/scripts/hypr_groups.sh move r"
                  "$mod SHIFT, k, exec, ~/nixos/scripts/hypr_groups.sh move u"
                  "$mod SHIFT, j, exec, ~/nixos/scripts/hypr_groups.sh move d"

                  "$mod, Tab, workspace, previous"
                  "$mod, s, layoutmsg, togglesplit" # Updated this line
                  "$mod, g, togglegroup"
                  "$mod, n, lockactivegroup, toggle"

                  "$mod, T, exec, kitty"
                  "$mod, Q, killactive"
                  "$mod SHIFT, Q, exit"
                  "$mod, E, exec, thunar"
                  "$mod, F, togglefloating"
                  "$mod, Return, fullscreen"
                  "$mod SHIFT, Return, fullscreenstate, 0 2"
                  "$mod, backslash, togglespecialworkspace, magic"
                  "$mod SHIFT, backslash, movetoworkspace, special:magic"
                  "$mod, bracketleft, workspace, e-1"
                  "$mod, bracketright, workspace, e+1"
                  "$mod, equal, exec, wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%+"
                  "$mod, minus, exec, wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%-"
                  "$mod, v, exec, pypr toggle volume"
                  "$mod, u, exec, exec eww update open_update_menu=true"
                  ",XF86MonBrightnessUp, exec, brightnessctl s +5%"
                  ",XF86MonBrightnessDown, exec, brightnessctl s 5%-"
                  "SUPER, l, exec, loginctl lock-session"
              ] ++ (if config.caelestia.enable then [
                  "$mod, Space, exec, caelestia shell drawers toggle launcher" 
                  "$mod, Escape, exec, caelestia shell drawers toggle session" 
                  "$mod, C, exec, caelestia shell picker openFreezeClip"
                  "$mod, N, exec, caelestia shell drawers toggle notifications"
                  "$mod, Page_Down, exec, caelestia hypr cycleSpecialWorkspace next"
                  "$mod, Page_Up, exec, caelestia hypr cycleSpecialWorkspace prev"
                  "$mod, w, exec, ~/nixos/scripts/random_wallpaper_caelestia.sh"
              ] else [
                  "$mod, Space, exec, ~/nixos/dotfiles/rofi/launcher/launcher.sh" 
                  "$mod, Escape, exec, ~/nixos/dotfiles/rofi/powermenu/powermenu.sh" 
                  "$mod, c, exec, bash ~/nixos/dotfiles/rofi/applets/screenshot.sh"
                  "$mod, N, exec, makoctl dismiss"
                  "$mod, w, exec, bash ~/nixos/scripts/update_wallpaper.sh"
              ]) ++ (
                  builtins.concatLists(builtins.genList(
                      x: let ws = 
                              let 
                                  c = (x + 1) / 10;
                              in
                              builtins.toString (x + 1 - (c * 10));
                          in 
                          [
                              "$mod, ${ws}, workspace, ${toString (x + 1)}"
                              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                              "MOD5, ${ws}, workspace, ${toString (x + 1)}"
                              "MOD5 SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                          ]) 10));
              bindm = [
                  "$mod, mouse:272, movewindow"
                  "$mod, mouse:273, resizewindow"
              ];

              exec-once = [
                  "pypr"
                  "[workspace 1 silent] brave --use-gl=desktop"
                  "[workspace 2 silent] Telegram"
                  "[workspace 2 silent] discord"
                  "[workspace 7 silent] thunderbird"
              ] ++ lib.optionals (!config.caelestia.enable) [
                  "bash ~/nixos/scripts/hyprland.sh"
              ];

              "$scratchpad" = "match:class ^(scratchpad)$";

              windowrule = [
                  "float 1, $scratchpad"
                      "workspace special:magic silent, $scratchpad"
              ];
          };

          extraConfig = ''
              bind = $mod, U, submap, update
              bind = $mod, U, exec, eww update open_update_menu=true

              submap = update

              bind = , H, exec, /home/maksi/nixos/scripts/update_home.sh; eww update open_update_menu=false
              bind = , H, submap, reset
              bind = , F, exec, /home/maksi/nixos/scripts/update_flake.sh; eww update open_update_menu=false
              bind = , F, submap, reset
              bind = , S, exec, /home/maksi/nixos/scripts/update_nixos.sh; eww update open_update_menu=false
              bind = , S, submap, reset
              bind = , Return, exec, eww update open_update_menu=false
              bind = , Return, submap, reset
              bind = , Escape, exec, eww update open_update_menu=false
              bind = , Escape, submap, reset
              bind = $mod, U, exec, eww update open_update_menu=false
              bind = $mod, U, submap, reset

              submap = reset
              '';
      };
    };
}
