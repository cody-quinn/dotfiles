{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    qutebrowser
  ];

  # Additional files that dont fit the "xdg" format, such as 
  # qutebrowser config.py and greasemonkey scripts.
  home.file."./.config/qutebrowser/config.py".source = ./config/qutebrowser/config.py;
  home.file."./.config/qutebrowser/greasemonkey/return-youtube-dislike.user.js".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Anarios/return-youtube-dislike/de1831f2c74032f8ccfe42a8eb174088363e011f/Extensions/UserScript/Return%20Youtube%20Dislike.user.js";
    hash = "sha256-aJwGbsZ3XoO/Xf7wGqjWR21XCqbELMBP2SUKE7kwtyw=";
  };

}
