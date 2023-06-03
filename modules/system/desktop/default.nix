{ config, pkgs, lib, ... }:

{
  imports = [
    ./awesome.nix
    ./i18n.nix
  ];

  config = {
    services.xserver.dpi = 96;
    services.xserver.layout = "us";

    services.gvfs.enable = true;

    environment.variables = {
      GTK_THEME = "Adwaita-dark";
    };
  };
}
