{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    firefox
    thunderbird
    alacritty
    neovide
    nemo
    peazip
    bitwarden
    qbittorrent
    libreoffice

    # Launchers
    rofi
    rofimoji

    wofi
    wofi-emoji

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
