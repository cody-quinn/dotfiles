{ config, pkgs, lib, ... }:

{
  imports = [
    ./software.nix
    ./vscode.nix
  ];
}