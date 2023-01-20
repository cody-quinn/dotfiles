{ config, pkgs, ... }:

{
  imports = [
    ../../../../modules/home/base
    ../../../../modules/home/desktop
    ../../../../modules/home/develop
  ];

  home.username = "cody";
  home.homeDirectory = "/home/cody";

  home.packages = with pkgs; [
    # Desktop software
    (discord.override { nss = nss_latest; })
    element-desktop
    qutebrowser
    krita
    bitwarden
    obs-studio
    aseprite-unfree
    obsidian
    arandr

    # Gamer time
    prismlauncher

    # Development tools
    jetbrains.idea-ultimate
    android-studio
    insomnia

    virt-manager
    minikube
    kubectl

    # Gnome software
    baobab

    # CLI tools
    zathura
    yt-dlp
    mpv

    # Calculator
    python310
  ];

  programs.git = {
    userName = "Cody";
    userEmail = "cody@codyq.dev";
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  # Additional files that dont fit the "xdg" format, such as 
  # qutebrowser config.py and greasemonkey scripts.
  home.file."./.config/qutebrowser/config.py".source = ./config/qutebrowser/config.py;
  home.file."./.config/qutebrowser/greasemonkey/return-youtube-dislike.user.js".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Anarios/return-youtube-dislike/de1831f2c74032f8ccfe42a8eb174088363e011f/Extensions/UserScript/Return%20Youtube%20Dislike.user.js";
    hash = "sha256-aJwGbsZ3XoO/Xf7wGqjWR21XCqbELMBP2SUKE7kwtyw=";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
