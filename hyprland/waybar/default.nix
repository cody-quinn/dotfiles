{ pkgs, username, ... }:

let
  wireplumber_0_4 = pkgs.wireplumber.overrideAttrs (attrs: rec {
    version = "0.4.17";
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "wireplumber";
      rev = version;
      hash = "sha256-vhpQT67+849WV1SFthQdUeFnYe/okudTQJoL3y+wXwI=";
    };
  });
in
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (prev: {
      buildInputs = prev.buildInputs ++ [ wireplumber_0_4 ];
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
