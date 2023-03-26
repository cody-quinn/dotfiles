{ config, pkgs, lib, ... }:

{
  imports = [
    ./git.nix
    ./shell.nix
  ];
}
