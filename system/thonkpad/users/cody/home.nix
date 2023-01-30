{ config, pkgs, ... }:

{
  imports = [
    ../../../../modules/home/base
    ../../../../modules/home/browser
    ../../../../modules/home/desktop
    ../../../../modules/home/develop
  ];

  home.username = "cody";
  home.homeDirectory = "/home/cody";

  home.packages = with pkgs; [
    # Desktop software
    (discord.override { nss = nss_latest; })
    element-desktop
    krita
    bitwarden
    obs-studio
    aseprite-unfree
    arandr
    baobab

    # Gamer time
    prismlauncher

    # Development tools
    jetbrains.idea-ultimate
    android-studio
    insomnia

    virt-manager
    minikube
    kubectl

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
