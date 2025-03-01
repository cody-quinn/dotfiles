{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./software.nix
    ./neovim.nix
  ];
}
