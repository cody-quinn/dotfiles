{
  description = "Cody's System Flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";

    discordfetch = {
      url = "github:cody-quinn/discordfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hummingbird = {
      url = "github:143mailliw/hummingbird";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nixos-hardware,
      home-manager,
      treefmt-nix,
      ...
    }@inputs:
    let
      username = "cody";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      formatter = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };

      overlays = [ ];
    in
    {
      formatter.${system} = formatter.config.build.wrapper;
      checks.${system} = {
        formatting = formatter.config.build.check self;
      };

      nixosConfigurations = {
        # My laptop
        thonkpad = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs username; };
          modules = [
            {
              nixpkgs.overlays = overlays;
            }

            nixos-hardware.nixosModules.lenovo-thinkpad-p50
            home-manager.nixosModules.home-manager
            (import ./system/thonkpad/configuration.nix)
            (import ./hyprland)

            {
              desktop.hyprland.extraConfig = ''
                input {
                  accel_profile = flat
                  sensitivity = 0.25

                  touchpad {
                    tap-to-click = false
                  }
                }
              '';

              desktop.hyprland.nvidia = true;
            }
          ];
        };

        # My desktop PC
        haumea = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs username; };
          modules = [
            {
              nixpkgs.overlays = overlays;
            }

            home-manager.nixosModules.home-manager
            (import ./system/haumea/configuration.nix)
            (import ./hyprland)

            {
              desktop.hyprland.extraConfig = ''
                monitor=DP-3,7680x2160@120.00Hz,0x0,1.5

                master {
                  orientation = center
                  slave_count_for_center_master = 0
                  mfact = 0.65
                }
              '';

              desktop.hyprland.modulesLeft = [
                "custom/padding"
                "hyprland/workspaces"
                "hyprland/window"
              ];

              desktop.hyprland.modulesRight = [
                "pulseaudio"
                "clock"
                "custom/padding"
              ];
            }
          ];
        };
      };
    };
}
