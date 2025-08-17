{
  config,
  pkgs,
  lib,
  username,
  ...
}:

let
  cfg = config.desktop.hyprland;
in
{
  imports = [
    ./waybar
  ];

  options.desktop.hyprland = with lib; {
    extraConfig = mkOption {
      type = types.str;
      default = "";
    };

    nvidia = mkOption {
      type = types.bool;
      default = false;
    };

    modulesLeft = mkOption {
      type = types.listOf types.str;
      default = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
    };

    modulesRight = mkOption {
      type = types.listOf types.str;
      default = [
        "battery"
        "pulseaudio"
        "clock"
      ];
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      hyprpaper
      hyprlock
      wl-clipboard
      grim
      slurp
    ];

    programs.hyprland.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
    };

    home-manager.users.${username} = {
      wayland.windowManager.hyprland = {
        enable = true;

        package = null;
        portalPackage = null;

        extraConfig =
          cfg.extraConfig
          + (import ./config.nix {
            nvidia = cfg.nvidia;
          });
      };

      home.file.".config/hypr/hyprpaper.conf".text = ''
        preload = /home/${username}/Pictures/wallpaper.jpg
        wallpaper = ,/home/${username}/Pictures/wallpaper.jpg
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
    };
  };
}
