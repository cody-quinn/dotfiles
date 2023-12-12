{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    direnv
    ranger
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
    eza
    neofetch
    gay
    yt-dlp
    graphviz
    lm_sensors
  ];

  environment.shells = [ pkgs.zsh pkgs.bash ];
  environment.pathsToLink = [ "/share/zsh" ];
}
