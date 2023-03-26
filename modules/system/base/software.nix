{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    htop
    killall
    tmux
    file
    gzip
    unzip
    zip
    exa
    neofetch
  ];

  environment.shells = [ pkgs.zsh pkgs.bash ];
}
