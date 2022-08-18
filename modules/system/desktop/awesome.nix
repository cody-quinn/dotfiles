{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.sys.desktop.awesome;
in 
{
  options.sys.desktop.awesome = {
    enable = mkEnableOption "Enable AwesomeWM desktop support for this machine";
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.libinput.touchpad.tapping = false;

    services.xserver.displayManager = {
      sddm.enable = true;
      defaultSession = "none+awesome";
    };

    services.xserver.windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
      ];
    };
  };
}
