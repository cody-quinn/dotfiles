{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./awesome.nix
    ./i18n.nix
  ];

  config = {
    services.xserver.enable = true;
    services.xserver.dpi = 96;
    services.xserver.xkb.layout = "us";
    services.xserver.xkb.options = "caps:swapescape, compose:ralt";

    services.libinput = {
      enable = true;
      touchpad.tapping = false;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = "1.4";
    };

    services.gvfs.enable = true;

    xdg.mime.defaultApplications = {
      "inode/directory" = "nemo.desktop";

      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "image/svg" = "org.qutebrowser.qutebrowser.desktop";
      "image/svg+xml" = "org.qutebrowser.qutebrowser.desktop";
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

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        liberation_ttf
        dejavu_fonts
        noto-fonts
        noto-fonts-lgc-plus
        jetbrains-mono

        twitter-color-emoji
        font-awesome

        nerd-fonts.jetbrains-mono
      ];

      fontconfig = {
        defaultFonts = {
          serif = [
            "DejaVu Math TeX Gyre"
            "DejaVu Serif"
            "Noto Serif"
          ];
          sansSerif = [
            "DejaVu Sans"
            "Noto Sans"
          ];
          monospace = [
            "JetBrainsMono Nerd Font"
            "DejaVu Sans Mono"
          ];
          emoji = [
            "Twitter Color Emoji"
            "Noto Color Emoji"
            "Noto Emoji"
          ];
        };
      };
    };

    # environment.variables = {
    #   GTK_THEME = "Adwaita-dark";
    # };
  };
}
