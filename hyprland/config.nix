''
  # See https://wiki.hyprland.org/Configuring/Monitors/
  monitor=DP-3,7680x2160@120.00Hz,0x0,1.5
  monitor=,preferred,auto,1

  # See https://wiki.hyprland.org/Configuring/Keywords/ for more
  exec-once = hyprpaper

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
    gaps_in = 0
    gaps_out = 0
    border_size = 0
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = master
  }

  xwayland {
    force_zero_scaling = true
  }

  env = GDK_SCALE,1.5
  env = XCURSOR_SIZE,24

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
  bind = SUPER_SHIFT, E     , exec, flatpak run app.zen_browser.zen
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
''
