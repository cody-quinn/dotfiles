{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default

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
    element-desktop
    slack

    # Misc
    krita
    obs-studio
    libresprite
    filebot

    # Gaming
    prismlauncher
    osu-lazer-bin

    # Development
    gnumake
    cmake
    clang

    eclipses.eclipse-java
    jetbrains.idea-community-bin
    jetbrains.idea-ultimate
    jetbrains.rider

    jd-gui

    # Calculator
    python310
  ];

  programs.git = {
    userName = "Cody";
    userEmail = "cody@codyq.dev";
    signing.key = "1DE927325E9932E7";
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  home.file.".config/waybar/config".source = ./waybar/config;
  home.file.".config/waybar/style.css".source = ./waybar/style.css;

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/cody/Pictures/wallpaper.jpg
    wallpaper = ,/home/cody/Pictures/wallpaper.jpg
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    extraConfig = ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=HDMI-A-1,2560x1080@75,0x0,1
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

        drop_shadow = no
        shadow_range = 4
        shadow_render_power = 3
        col.shadow = rgba(1a1a1aee)
      }

      animations {
        enabled = yes

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
        new_is_master = false
        no_gaps_when_only = true
      }

      gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = off
      }

      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      # -- Fix odd behaviors in IntelliJ IDEs --
      #! Fix focus issues when dialogs are opened or closed
      windowrulev2 = windowdance,class:^(jetbrains-.*)$,floating:1
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
      bind = SUPER_SHIFT, S     , exec, flameshot gui
      bind = SUPER_SHIFT, D     , exec, discord
      # TODO: Lock
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
      bind = SUPER_SHIFT  , S, exec, grim -g "$(slurp)" - | wl-copy
      bind = SUPER_CONTROL, S, exec, grim -g "$(slurp -o)" - | wl-copy

      # Switch workspaces with mainMod + [0-9]
      bind = SUPER, 1, split-workspace, 1
      bind = SUPER, 2, split-workspace, 2
      bind = SUPER, 3, split-workspace, 3
      bind = SUPER, 4, split-workspace, 4
      bind = SUPER, 5, split-workspace, 5
      bind = SUPER, 6, split-workspace, 6
      bind = SUPER, 7, split-workspace, 7
      bind = SUPER, 8, split-workspace, 8
      bind = SUPER, 9, split-workspace, 9
      bind = SUPER, 0, split-workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = SUPER_SHIFT, 1, split-movetoworkspacesilent, 1
      bind = SUPER_SHIFT, 2, split-movetoworkspacesilent, 2
      bind = SUPER_SHIFT, 3, split-movetoworkspacesilent, 3
      bind = SUPER_SHIFT, 4, split-movetoworkspacesilent, 4
      bind = SUPER_SHIFT, 5, split-movetoworkspacesilent, 5
      bind = SUPER_SHIFT, 6, split-movetoworkspacesilent, 6
      bind = SUPER_SHIFT, 7, split-movetoworkspacesilent, 7
      bind = SUPER_SHIFT, 8, split-movetoworkspacesilent, 8
      bind = SUPER_SHIFT, 9, split-movetoworkspacesilent, 9
      bind = SUPER_SHIFT, 0, split-movetoworkspacesilent, 10

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
