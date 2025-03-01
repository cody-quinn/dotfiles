{
  description = "Cody's System Flakes";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland = {
    #   url = "github:hyprwm/Hyprland/v0.47.2?submodules=1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # split-monitor-workspaces = {
    #   url = "github:Duckonaut/split-monitor-workspaces/1d4742b30aa9f3d01ea227a9c726985ffa832368";
    # };

    discordfetch = {
      url = "github:cody-quinn/discordfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      nixos-hardware,
      discordfetch,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      overlays = [
        (f: p: {
          stable-rider =
            (import nixpkgs-stable {
              system = system;
              config.allowUnfree = true;
            }).jetbrains.rider;
        })
      ];
    in
    rec {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
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
