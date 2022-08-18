{ config, pkgs, lib, ... }:

{
  imports = [
    ./awesome.nix
  ];

  config = {
    services.xserver.dpi = 96;
    services.xserver.layout = "us";
  };
}
