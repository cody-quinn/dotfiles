{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    qutebrowser
  ];

  home.file.".config/qutebrowser/config.py".text = ''
    config.load_autoconfig(True)

    c.colors.statusbar.passthrough.bg = "darkblue"
    c.colors.tabs.even.bg = "black"
    c.colors.tabs.odd.bg = "black"
    c.colors.tabs.selected.even.bg = "#000000"
    c.colors.tabs.selected.even.fg = "lime"
    c.colors.tabs.selected.odd.bg = "#000000"
    c.colors.tabs.selected.odd.fg = "lime"
    c.colors.webpage.preferred_color_scheme = "dark"

    c.tabs.new_position.unrelated = "first"
    c.tabs.position = "bottom"
    c.statusbar.position = "bottom"
    c.window.title_format = "{perc}{current_title}"

    c.fonts.default_family = "DejaVu Sans Mono"
    c.fonts.default_size = "10pt"

    c.content.geolocation = False
    c.content.notifications.enabled = False
    c.content.javascript.can_access_clipboard = True
    c.content.pdfjs = True

    c.content.blocking.enabled = True
    c.content.blocking.method = "both"

    c.qt.chromium.low_end_device_mode = "never"
  '';

  home.file.".config/qutebrowser/greasemonkey/return-youtube-dislike.user.js".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Anarios/return-youtube-dislike/5c73825aadb81b6bf16cd5dff2b81a88562b6634/Extensions/UserScript/Return%20Youtube%20Dislike.user.js";
    hash = "sha256-5JC3vrPj+kJq68AFtEWwriyCc7sD8nIpqc6dLbjPGso=";
  };
}
