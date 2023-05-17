{
  description = "Cody's System Flakes";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    nixinate.url = "github:matthewcroughan/nixinate";

    prism-launcher.url = "github:PrismLauncher/PrismLauncher";
    iamb.url = "github:ulyssa/iamb";
  };

  outputs = { self, flake-utils, nixpkgs, home-manager, nixos-hardware, prism-launcher, iamb, nixinate, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      overlays = [
        (_: p: { iamb = iamb.packages.${p.system}.default; })

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
