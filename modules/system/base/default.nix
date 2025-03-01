{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./keyboard.nix
    ./nixos.nix
    ./software.nix
  ];
}
