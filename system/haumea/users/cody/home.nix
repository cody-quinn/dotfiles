{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../../../../modules/home/base
    ../../../../modules/home/browser
    ../../../../modules/home/desktop
    ../../../../modules/home/develop
  ];

  home.username = "cody";
  home.homeDirectory = "/home/cody";

  home.packages = with pkgs; [
    # Communication
    (discord.override { nss = nss_latest; })
    (discord-canary.override { nss = nss_latest; })
    element-desktop
    slack
    obsidian

    # Misc
    krita
    obs-studio
    libresprite
    aseprite
    filebot

    inputs.discordfetch.packages.${pkgs.system}.default

    # Gaming
    prismlauncher
    osu-lazer-bin

    # Development
    gnumake
    cmake
    clang

    jetbrains.idea-ultimate
    jetbrains.rider
    # stable-rider
    jetbrains.clion
    zed-editor

    godot_4
    tiled
    renderdoc
    bytecode-viewer

    # Calculator
    python310
  ];

  programs.git = {
    userName = "Cody";
    userEmail = "cody@codyq.dev";
    signing.key = "1DE927325E9932E7";
  };

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;

  home.file.".config/waybar/style.css".source = ./waybar/style.css;
  home.file.".config/waybar/config".text = ''
    {
      "layer": "top",
      "position": "top",

      "modules-left": [
        "hyprland/workspaces",
        "hyprland/window"
      ],

      "modules-center": [
      ],

      "modules-right": [
        "battery",
        "pulseaudio",
        "clock"
      ],

      "hyprland/workspaces": {
        "on-click": "activate",
        "on-scroll-up": "hyprctl dispatch workspace e+1",
        "on-scroll-down": "hyprctl dispatch workspace e-1",
        "format": "{icon}",
        "format-icons": {
          "11": "1",
          "12": "2",
          "13": "3",
          "14": "4",
          "15": "5",
          "16": "6",
          "17": "7",
          "18": "8",
          "19": "9",
          "20": "10",
        }
      },
      "hyprland/window": {
        "separate-outputs": true,
      },

      "pulseaudio": {
        "format": "{icon} {volume:2}%",
        "format-bluetooth": "{icon} {volume}%",
        "format-muted": "MUTE",
        "format-icons": {
          "headphones": "",
          "default": [
            "",
            ""
          ]
        },
        "scroll-step": 5,
        "on-click": "pamixer -t",
        "on-click-right": "pavucontrol"
      },
      "memory": {
        "interval": 5,
        "format": "Mem {}%"
      },
      "cpu": {
        "interval": 5,
        "format": "CPU {usage}%"
      },
      "battery": {
        "states": {
          "good": 95,
          "warning": 30,
          "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-icons": [
          "",
          "",
          "",
          "",
          ""
        ]
      },
      "disk": {
        "interval": 5,
        "tooltip-format": "Disk {percentage_used}%",
        "format": "{specific_used} out of {specific_total} used ({percentage_used}%)",
        "unit": "GB",
        "path": "/"
      },
      "clock": {
        "interval": 1,
        "format": "{:%I:%M:%S %p}",
        "tooltip": true
      }
    }
  '';

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/cody/Pictures/wallpaper.jpg
    wallpaper = ,/home/cody/Pictures/wallpaper.jpg
  '';

  home.file.".config/hypr/hyprlock.conf".text = ''
    general {
      hide_cursor = yes
      no_fade_in = yes
      no_fade_out = yes
    }

    background {
      color = rgba(0, 0, 0, 1.0)
    }

    input-field {
      position = 0, 0
    }
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # plugins = [
    #   inputs.monitor-workspaces.packages.${pkgs.system}.monitor-workspaces
    # ];

    package = null;
    portalPackage = null;

    extraConfig = ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      #monitor=DP-2,2560x1080@60,0x0,1
      #monitor=HDMI-A-2,2560x1080@75,0x1080,1
      monitor=,preferred,auto,1

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      exec-once = hyprpaper

      # Some default env vars.
      env = XCURSOR_SIZE,24

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
        kb_layout = us
        kb_options = caps:swapescape, compose:ralt

        follow_mouse = 1
        touchpad {
          natural_scroll = no
        }

        sensitivity = 0
      }

      general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 0
        gaps_out = 0
        border_size = 0
        col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
        col.inactive_border = rgba(595959aa)

        layout = master
      }

      decoration {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 0

        blur {
          enabled = no
          size = 3
          passes = 1
          new_optimizations = on
        }

        shadow {
          enabled = no
          range = 4
          render_power = 3
          color = rgba(1a1a1aee)
        }
      }

      animations {
        enabled = no

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
      }

      dwindle {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = yes # you probably want this
      }

      master {
        allow_small_split = true
        new_status = slave
        new_on_top = no
        orientation = center
        slave_count_for_center_master = 0
        mfact = 0.65
      }

      # bind = SUPER, [, removemaster
      # bind = SUPER, ], addmaster

      gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = off
      }

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # -- Fix odd behaviors in IntelliJ IDEs --
      #! Fix focus issues when dialogs are opened or closed
      #windowrulev2 = windowdance,class:^(jetbrains-.*)$,floating:1
      #! Fix splash screen showing in weird places and prevent annoying focus takeovers
      windowrulev2 = center,class:^(jetbrains-.*)$,title:^(splash)$,floating:1
      windowrulev2 = nofocus,class:^(jetbrains-.*)$,title:^(splash)$,floating:1
      windowrulev2 = noborder,class:^(jetbrains-.*)$,title:^(splash)$,floating:1

      #! Center popups/find windows
      windowrulev2 = center,class:^(jetbrains-.*)$,title:^( )$,floating:1
      windowrulev2 = stayfocused,class:^(jetbrains-.*)$,title:^( )$,floating:1
      windowrulev2 = noborder,class:^(jetbrains-.*)$,title:^( )$,floating:1
      #! Disable window flicker when autocomplete or tooltips appear
      windowrulev2 = nofocus,class:^(jetbrains-.*)$,title:^(win.*)$,floating:1

      # Media controls for keyboards without dedicated keys
      binde = , XF86MonBrightnessUp  , exec, brightnessctl set +5%
      binde = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

      binde = , XF86AudioMute       , exec, pamixer -t
      binde = , XF86AudioRaiseVolume, exec, pamixer -i 5
      binde = , XF86AudioLowerVolume, exec, pamixer -d 5
      binde = , XF86AudioMicMute    , exec, pamixer --default-source -t

      bind = , XF86AudioPrev , exec, playerctl previous
      bind = , XF86AudioNext , exec, playerctl next
      bind = , XF86AudioPlay , exec, playerctl play-pause
      bind = , XF86AudioPause, exec, playerctl play-pause

      bind = SUPER, Left , exec, playerctl previous
      bind = SUPER, Right, exec, playerctl next
      bind = SUPER, Down , exec, playerctl play-pause

      # Program related keybindings
      bind = SUPER      , P     , exec, wofi --show drun
      bind = SUPER      , O     , exec, wofi --show run

      bind = SUPER_SHIFT, Return, exec, alacritty
      bind = SUPER_SHIFT, H     , exec, alacritty -e htop
      bind = SUPER_SHIFT, P     , exec, alacritty -e python
      bind = SUPER_SHIFT, E     , exec, qutebrowser
      bind = SUPER_SHIFT, D     , exec, discord
      bind = SUPER_SHIFT, L     , exec, hyprlock
      bind = SUPER_SHIFT, M     , exec, prismlauncher
      bind = SUPER_SHIFT, F     , exec, nemo

      # Basic window management binds
      bind = SUPER_CONTROL_SHIFT, Q     , exit
      bind = SUPER_SHIFT        , C     , killactive,
      bind = SUPER              , Space , togglefloating,
      bind = SUPER_CONTROL      , F     , fullscreen,

      bind = SUPER      , H     , resizeactive, -50 0
      bind = SUPER      , L     , resizeactive, 50 0
      bind = SUPER      , J     , layoutmsg, cyclenext
      bind = SUPER      , K     , layoutmsg, cycleprev
      bind = SUPER      , M     , layoutmsg, swapwithmaster
      bind = SUPER      , F     , layoutmsg, focusmaster

      # Utility binds
      bind = SUPER        , S, exec, grim - | wl-copy
      bind = SUPER_SHIFT  , S, exec, grim -g "$(slurp)" - | wl-copy
      bind = SUPER_CONTROL, S, exec, grim -g "$(slurp -o)" - | wl-copy

      # Switch workspaces with mainMod + [0-9]
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = SUPER_SHIFT, 1, movetoworkspacesilent, 1
      bind = SUPER_SHIFT, 2, movetoworkspacesilent, 2
      bind = SUPER_SHIFT, 3, movetoworkspacesilent, 3
      bind = SUPER_SHIFT, 4, movetoworkspacesilent, 4
      bind = SUPER_SHIFT, 5, movetoworkspacesilent, 5
      bind = SUPER_SHIFT, 6, movetoworkspacesilent, 6
      bind = SUPER_SHIFT, 7, movetoworkspacesilent, 7
      bind = SUPER_SHIFT, 8, movetoworkspacesilent, 8
      bind = SUPER_SHIFT, 9, movetoworkspacesilent, 9
      bind = SUPER_SHIFT, 0, movetoworkspacesilent, 10

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    '';
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
