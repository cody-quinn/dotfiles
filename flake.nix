{
  description = "Cody's System Flakes";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    nixinate.url = "github:matthewcroughan/nixinate";
    prism-launcher.url = "github:PrismLauncher/PrismLauncher";
  };

  outputs = { self, flake-utils, nixpkgs, home-manager, nixos-hardware, prism-launcher, nixinate }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    rec
    {
      apps = nixinate.nixinate.x86_64-linux self;
      nixosConfigurations = {
        thonkpad = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ prism-launcher.overlay ]; })
            nixos-hardware.nixosModules.lenovo-thinkpad-p50
            home-manager.nixosModules.home-manager
            (import ./system/thonkpad/configuration.nix)
          ];
        };
        buzzbox = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            home-manager.nixosModules.home-manager
            (import ./system/buzzbox/configuration.nix)
            {
              _module.args.nixinate = {
                host = "5.78.41.254";
                sshUser = "cody";
                buildOn = "remote";
                hermetic = false;
              };
            }
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
