{
  description = "Cody's System Flakes";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";

    nixinate.url = "github:matthewcroughan/nixinate";

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.36.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    prism-launcher.url = "github:PrismLauncher/PrismLauncher";
  };

  outputs = { self, flake-utils, nixpkgs, home-manager, nixos-hardware, hyprland, prism-launcher, nixinate, split-monitor-workspaces, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      overlays = [
        hyprland.overlays.default
        prism-launcher.overlays.default
      ];
    in
    rec
    {
      apps = nixinate.nixinate.x86_64-linux self;
      nixosConfigurations = {
        # My laptop
        thonkpad = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs; };
          modules = [
            {
              nixpkgs.overlays = overlays;
            }

            nixos-hardware.nixosModules.lenovo-thinkpad-p50
            home-manager.nixosModules.home-manager
            (import ./system/thonkpad/configuration.nix)
          ];
        };
        # My desktop PC
        haumea = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs; };
          modules = [
            {
              nixpkgs.overlays = overlays;
            }

            home-manager.nixosModules.home-manager
            (import ./system/haumea/configuration.nix)
          ];
        };
      };
      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = with pkgs; [
          rnix-lsp
        ];
      };
    };
}
