{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Configuring programs installed in ./software.nix :)
  xdg.configFile.alacritty = {
    source = ./config/alacritty;
    recursive = true;
  };

  xdg.configFile.awesome = {
    source = ./config/awesome;
    recursive = true;
  };

  xdg.configFile.flameshot = {
    source = ./config/flameshot;
    recursive = true;
  };

  xdg.configFile.rofi = {
    source = ./config/rofi;
    recursive = true;
  };
}
