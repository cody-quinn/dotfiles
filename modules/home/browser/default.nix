{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    qutebrowser
  ];

  # Additional files that dont fit the "xdg" format, such as 
  # qutebrowser config.py and greasemonkey scripts.
  home.file."./.config/qutebrowser/config.py".source = ./config/qutebrowser/config.py;
  home.file."./.config/qutebrowser/greasemonkey/return-youtube-dislike.user.js".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Anarios/return-youtube-dislike/6d441a293286c7708e692bb4a76730387a93c578/Extensions/UserScript/Return%20Youtube%20Dislike.user.js";
    hash = "sha256-7gCakbOMZyJUlcg6D2cpouqVjRKIRVPlmD30BeOgNLU=";
  };
}
