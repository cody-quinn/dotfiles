{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    qutebrowser
  ];

  # Additional files that dont fit the "xdg" format, such as 
  # qutebrowser config.py and greasemonkey scripts.
  home.file."./.config/qutebrowser/config.py".source = ./config/qutebrowser/config.py;
  home.file."./.config/qutebrowser/greasemonkey/return-youtube-dislike.user.js".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Anarios/return-youtube-dislike/5c73825aadb81b6bf16cd5dff2b81a88562b6634/Extensions/UserScript/Return%20Youtube%20Dislike.user.js";
    hash = "sha256-5JC3vrPj+kJq68AFtEWwriyCc7sD8nIpqc6dLbjPGso=";
  };
}
