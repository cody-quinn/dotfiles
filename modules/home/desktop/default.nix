{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./configs.nix
    ./software.nix
    ./theme.nix
  ];
}
