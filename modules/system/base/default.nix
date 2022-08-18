{ config, pkgs, lib, ... }:

{
  imports = [
    ./nixos.nix
    ./software.nix
  ];
}
