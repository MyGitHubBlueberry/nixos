{ pkgs, lib, config, ... }:

{
    options = {
        hyprconfig.enable 
            = lib.mkEnableOption "enable hyprland config";
    };


    config = lib.mkIf config.hyprconfig.enable {
        wayland.windowManager.hyprland = {
            enable = true;
            xwayland.enable = true;

            settings = {
                source = "/home/maksi/nixos/modules/home-manager/colors-hyprland.conf";
                
                monitor = [
                    ",prefered,auto,1"
                    "Unknown-1, disable"
                ];

                input = {
                    kb_layout = "us, ua";
# kb_variant =
# kb_model =
                    kb_options = "grp:win_space_toggle, MOD5:alt";
# kb_rules = 

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
                    # "col.active_border" = "$color15";#"rgba(ffffffee)";
                    "col.inactive_border" = "$color8";

                    layout = "dwindle";

# Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
                    allow_tearing = false;
                };

                # See https://wiki.hyprland.org/Configuring/Variables/ for more
                decoration = {
                    dim_inactive = true;
                    dim_strength = 0.1;
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

# Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

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

                dwindle = {
# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
                    pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
                        preserve_split = "yes"; # you probably want this
                };

# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
                gestures = {
# See https://wiki.hyprland.org/Configuring/Variables/ for more
                    workspace_swipe = true;
                    workspace_swipe_forever = true;
                    workspace_swipe_distance = 200;
                    workspace_swipe_cancel_ratio = 0.3;
                };

                misc = {
# See https://wiki.hyprland.org/Configuring/Variables/ for more
                    force_default_wallpaper = 0; #-1; # Set to 0 to disable the anime mascot wallpapers
                    
                    disable_splash_rendering = true;
                    disable_hyprland_logo = true;

                };

                "$mod" = "Alt";

                bind =
                    [
                        "$mod, h, movefocus, l"
                        "$mod, l, movefocus, r"
                        "$mod, k, movefocus, u"
                        "$mod, j, movefocus, d"

                        "$mod SHIFT, h, swapwindow, l"
                        "$mod SHIFT, l, swapwindow, r"
                        "$mod SHIFT, k, swapwindow, u"
                        "$mod SHIFT, j, swapwindow, d"

                        "$mod, Tab, focuscurrentorlast"
                        "$mod, m, togglesplit"

                        "$mod, Escape, exec, ~/nixos/scripts/rofi/powermenu.sh" 
                        "$mod, Space, exec, ~/nixos/scripts/rofi/launcher.sh" 
                        "$mod, T, exec, kitty"
                        "$mod, Q, killactive"
                        "$mod SHIFT, Q, exit"
                        "$mod, E, exec, dolphin"
                        "$mod, F, togglefloating"
                        "$mod, R, exec, wofi --show drun"
                        # "$mod, P, pseudo"
                        "$mod, Return, fullscreen"
                        "$mod, S, togglespecialworkspace, magic"
                        "$mod SHIFT, S, movetoworkspace, special:magic"
                        "$mod, bracketleft, workspace, e-1"
                        "$mod, bracketright, workspace, e+1"
                        "$mod, w, exec, bash ~/nixos/scripts/update_wallpaper.sh"
                        "$mod, b, exec, bash ~/nixos/scripts/restart_waybar.sh"
                        "$mod, c, exec, bash ~/nixos/scripts/rofi/screenshot.sh"
                        "$mod, equal, exec, wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%+"
                        "$mod, minus, exec, wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%-"
                        "$mod, v, exec, pypr toggle volume"
                        # "$mod, u, exec, pypr show update"

                        "$mod, u, exec, exec eww update open_update_menu=true"
                        # "$mod, u, submap, update"
                        # ", h, exec, /home/maksi/nixos/scripts/update_home.sh; eww update open_update_menu=false"
                        # ", f, exec, /home/maksi/nixos/scripts/update_flake.sh; eww update open_update_menu=false"
                        # ", f, submap, reset"
                        # ", s, exec, /home/maksi/nixos/scripts/update_nixos.sh; eww update open_update_menu=false"
                        # ", s, submap, reset"
                        # ", escape, submap, reset"
                        ]
                        ++ (
# workspaces
# binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
                                builtins.concatLists (builtins.genList (
                                        x: let
                                        ws = 
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
                                        ]
                                        ) 10)
                           );
                bindm = [
                    "$mod, mouse:272, movewindow"
                        "$mod, mouse:273, resizewindow"
                ];

                exec-once = [
                    "bash ~/nixos/scripts/hyprland.sh"
                        "pypr"
                        "[workspace 1 silent] brave --use-gl=desktop"
                        "[workspace 2 silent] telegram-desktop"
                        "[workspace 2 silent] discord"
                        "[workspace 7 silent] thunderbird"
                ];

                "$scratchpad" = "class:^(scratchpad)$";

                windowrule = [
                    "float,$scratchpad"
                ];

                windowrulev2 = [
                    "workspace special silent,$scratchpad"
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

                bind = $mod, g, submap, group

                submap = group

                bind = , g, togglegroup
                bind = , j, changegroupactive, b
                bind = , k, changegroupactive, f
                bind = SHIFT, j, movegroupwindow, b
                bind = SHIFT, k, movegroupwindow, f

                bind = $mod, h, movewindoworgroup, l
                bind = $mod, k, movewindoworgroup, u
                bind = $mod, j, movewindoworgroup, d
                bind = $mod, l, movewindoworgroup, r

                bind = , Return, submap, reset
                bind = , Escape, submap, reset
                bind = $mod, g, submap, reset

                submap = reset
                '';
        };
    };
}
