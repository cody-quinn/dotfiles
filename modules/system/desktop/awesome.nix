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

    # Setting default applications
    xdg.mime.defaultApplications = {
      "inode/directory" = "nemo.desktop";

      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";

      "image/png" = "feh.desktop";
      "image/jpeg" = "feh.desktop";
      "image/gif" = "feh.desktop";
      "image/webm" = "feh.desktop";
      "video/mp4" = "mpv.desktop";
    };
  };
}
