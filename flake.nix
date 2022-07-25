{
  description = "Cody's System Flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware }: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      homeConfigurations = {
        cody = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./users/cody/home.nix
          ];
        };
      };
      nixosConfigurations = {
        thonkpad = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [ 
            nixos-hardware.nixosModules.lenovo-thinkpad-p50
            ./modules/runtimes.nix
            ./system/thonkpad/configuration.nix
          ];
        };
      };
    };
}
