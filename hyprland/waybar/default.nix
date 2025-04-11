{ pkgs, username, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (prev: {
      buildInputs = prev.buildInputs ++ [ pkgs.wireplumber ];
    });
  };

  home-manager.users.${username} = {
    home.file.".config/waybar/style.css".source = ./style.css;
    home.file.".config/waybar/config".text = (
      import ./config.nix {
        modulesLeft = [
          "custom/padding"
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modulesRight = [
          "battery"
          "pulseaudio"
          "clock"
          "custom/padding"
        ];
      }
    );
  };
}
