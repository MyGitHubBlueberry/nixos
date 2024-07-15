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
                    kb_layout = "us, ua, de";
# kb_variant =
# kb_model =
                    kb_options = "grp:win_space_toggle, MOD5:alt";
# kb_rules = 

                    follow_mouse = 0;

                    touchpad = {
                        natural_scroll = "no";
                    };

                    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
                };

                general = {
                    gaps_in = 5;
                    gaps_out = 5;
                    border_size = 3;
# "col.active_border" = "$color11 $background $background $color14 45deg";
                    "col.active_border" = "$color15";#"rgba(ffffffee)";
                    "col.inactive_border" = "$color11";

                    layout = "dwindle";

# Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
                    allow_tearing = false;
                };

                decoration = {
# See https://wiki.hyprland.org/Configuring/Variables/ for more

                    rounding = 10;
                    inactive_opacity = 0.9;
                    active_opacity = 0.95;
                    fullscreen_opacity = 1;

                    blur = {
                        enabled = true;
                        size = 3;
                        passes = 1;
                    };

                    drop_shadow = "yes";
                    shadow_range = 4;
                    shadow_render_power = 3;
                    "col.shadow" = "rgba(1a1a1aee)";
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

                master = {
# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
                    new_is_master = true;
                };

                gestures = {
# See https://wiki.hyprland.org/Configuring/Variables/ for more
                    workspace_swipe = "off";
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
                        "mode=tiling SUPER, h, resizeactive, -10 0"
                        "mode=tiling SUPER, j, resizeactive, 0 10"
                        "mode=tiling SUPER, k, resizeactive, 0 -10"
                        "mode=tiling SUPER, l, resizeactive, 10 0"

                        "mode=floating SUPER, h, moveactive, -30 0"
                        "mode=floating SUPER, j, moveactive, 0 30"
                        "mode=floating SUPER, k, moveactive, 0 -30"
                        "mode=floating SUPER, l, moveactive, 30 0"

                        "MOD5, Escape, exec, ~/nixos/scripts/rofi/powermenu.sh" 
                        "MOD5, Space, exec, ~/nixos/scripts/rofi/launcher.sh" 
                        "MOD5, T, exec, kitty"
                        "MOD5, Q, killactive"
                        "MOD5 SHIFT, Q, exit"
                        "MOD5, E, exec, dolphin"
                        "MOD5, F, togglefloating"
                        "MOD5, R, exec, wofi --show drun"
                        "MOD5, P, pseudo"
                        "MOD5, Tab, togglesplit"
                        "MOD5, Return, fullscreen"
                        "MOD5, h, movefocus, l"
                        "MOD5, l, movefocus, r"
                        "MOD5, k, movefocus, u"
                        "MOD5, j, movefocus, d"
                        "MOD5 SHIFT, h, swapwindow, l"
                        "MOD5 SHIFT, l, swapwindow, r"
                        "MOD5 SHIFT, k, swapwindow, u"
                        "MOD5 SHIFT, j, swapwindow, d"
                        "MOD5, S, togglespecialworkspace, magic"
                        "MOD5 SHIFT, S, movetoworkspace, special:magic"
                        "MOD5, bracketleft, workspace, e-1"
                        "MOD5, bracketright, workspace, e+1"
                        "MOD5, w, exec, bash ~/nixos/scripts/update_wallpaper.sh"
                        "MOD5, b, exec, bash ~/nixos/scripts/restart_waybar.sh"
                        "MOD5, c, exec, bash ~/nixos/scripts/rofi/screenshot.sh"
                        "MOD5, equal, exec, wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%+"
                        "MOD5, minus, exec, wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%-"
                        "MOD5, v, exec, pypr toggle volume"
                        "MOD5, u, exec, pypr show update"

                        "$mod, Escape, exec, ~/nixos/scripts/rofi/powermenu.sh" 
                        "$mod, Space, exec, ~/nixos/scripts/rofi/launcher.sh" 
                        "$mod, T, exec, kitty"
                        "$mod, Q, killactive"
                        "$mod SHIFT, Q, exit"
                        "$mod, E, exec, dolphin"
                        "$mod, F, togglefloating"
                        "$mod, R, exec, wofi --show drun"
                        "$mod, P, pseudo"
                        "$mod, Tab, togglesplit"
                        "$mod, Return, fullscreen"
                        "$mod, h, movefocus, l"
                        "$mod, l, movefocus, r"
                        "$mod, k, movefocus, u"
                        "$mod, j, movefocus, d"
                        "$mod SHIFT, h, swapwindow, l"
                        "$mod SHIFT, l, swapwindow, r"
                        "$mod SHIFT, k, swapwindow, u"
                        "$mod SHIFT, j, swapwindow, d"
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
                        "$mod, u, exec, pypr show update"
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
                    "[workspace 1 silent] librewolf"
                    "[workspace 2 silent] telegram-desktop"
                    "[workspace 2 silent] thunderbird"
                ];
                
                "$scratchpad" = "class:^(scratchpad)$";

                windowrule = [
                    "float,$scratchpad"
                ];

                windowrulev2 = [
                    "workspace special silent,$scratchpad"
                ];
            };
        };
    };
}
