{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    firefox
    thunderbird
    alacritty
    neovide
    cinnamon.nemo

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
