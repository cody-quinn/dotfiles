{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    chromium
    firefox
    thunderbird
    alacritty
    neovide
    cinnamon.nemo
    bitwarden
    qbittorrent

    # Launchers
    rofi
    rofimoji

    # Utilities
    flameshot
    pavucontrol
    arandr
    baobab
    xclip
    feh
    mpv
    zathura

    # CLI Tools
    pamixer
    brightnessctl
    playerctl
  ];
}
