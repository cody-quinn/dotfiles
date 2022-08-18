{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    firefox
    thunderbird
    alacritty
    neovide

    gnome.nautilus
    gnome.gnome-disk-utility

    # Launchers
    rofi
    rofimoji

    # Utilities
    flameshot
    pavucontrol
    xclip
    feh

    # CLI Tools
    pamixer
    brightnessctl
    playerctl
  ];
}
