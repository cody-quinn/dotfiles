{
  config,
  pkgs,
  username,
  ...
}:

let
  cfg = config.desktop.hyprland;
in
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
        modulesLeft = cfg.modulesLeft;
        modulesRight = cfg.modulesRight;
      }
    );
  };
}
