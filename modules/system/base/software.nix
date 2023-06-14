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
    exa
    neofetch
    gay
    yt-dlp
    graphviz
  ];

  environment.shells = [ pkgs.zsh pkgs.bash ];
  environment.pathsToLink = [ "/share/zsh" ];
}
