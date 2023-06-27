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

    # Misc
    krita
    obs-studio
    libresprite
    openrgb

    # Gaming
    prismlauncher
    osu-lazer-bin

    # Virtualization
    virt-manager
    minikube
    kubectl

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

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /home/cody/Pictures/wallpaper.jpg
    wallpaper = ,/home/cody/Pictures/wallpaper.jpg
  '';

  wayland.windowManager.hyprland = 
    let 
      split-monitor-workspaces = pkgs.stdenv.mkDerivation {
        pname = "split-monitor-workspaces";
        version = "0.1";

        src = pkgs.fetchFromGitHub {
          owner = "Duckonaut";
          repo = "split-monitor-workspaces";
          rev = "44785ce";
          sha256 = "XxcUPMqytWItOmre7MV1XAhx/i2uyBbjHMKr5+B0IPE=";
        };

        nativeBuildInputs = [ pkgs.pkg-config ];
        buildInputs = [ pkgs.hyprland ] ++ pkgs.hyprland.buildInputs;

        buildPhase = ''
          export HYPRLAND_HEADERS=${pkgs.hyprland.src}
          make all
        '';

        installPhase = ''
          mkdir -p $out/lib
          cp split-monitor-workspaces.so $out/lib/libsplit-monitor-workspaces.so
        '';
      };
    in 
    {
      enable = true;
      package = pkgs.hyprland;
      plugins = [
        split-monitor-workspaces
      ];

      extraConfig = ''
        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor=DP-1,2560x1080@60,0x0,1
        monitor=HDMI-A-1,2560x1080@75,0x1080,1
        monitor=,preferred,auto,1

        # See https://wiki.hyprland.org/Configuring/Keywords/ for more
        exec-once = waybar & hyprpaper

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
            blur = no
            blur_size = 3
            blur_passes = 1
            blur_new_optimizations = on

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

        # Example per-device config
        # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
        device:epic-mouse-v1 {
            sensitivity = -0.5
        }

        # Example windowrule v1
        # windowrule = float, ^(kitty)$
        # Example windowrule v2
        # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

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

        # Scroll through existing workspaces with mainMod + scroll
        bind = SUPER, mouse_down, split-workspace, e+1
        bind = SUPER, mouse_up, split-workspace, e-1

        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = SUPER, mouse:272, movewindow
        bindm = SUPER, mouse:273, resizewindow

        exec-once=hyprctl plugin load ${split-monitor-workspaces}/lib/libsplit-monitor-workspaces.so
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
