{ config, pkgs, lib, ... }:

{
  imports = [
    ./apple.nix
    ./nixos.nix
    ./software.nix
  ];
}
