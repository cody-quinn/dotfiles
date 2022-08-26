{
  description = "Cody's System Flakes";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, flake-utils, nixpkgs, home-manager, nixos-hardware }:
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
      nixosConfigurations = {
        thonkpad = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-p50
            home-manager.nixosModules.home-manager
            ./system/thonkpad/configuration.nix
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
