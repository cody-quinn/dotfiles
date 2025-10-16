{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

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
    # Communication
    (discord.override { nss = nss_latest; })
    (discord-canary.override { nss = nss_latest; })
    element-desktop
    slack
    obsidian

    # Misc
    krita
    obs-studio
    libresprite
    aseprite
    filebot
    ffmpeg
    keymapp
    mcstatus

    inputs.discordfetch.packages.${pkgs.system}.default

    # Gaming
    prismlauncher
    osu-lazer-bin

    # Development
    gnumake
    cmake
    clang

    jetbrains.idea-ultimate
    jetbrains.rider
    jetbrains.goland
    jetbrains.clion

    godot_4
    tiled
    renderdoc
    bytecode-viewer

    dive
    minikube
    docker-machine-kvm2
    kubectl
    kubernetes-helm

    # Calculator
    python310
  ];

  programs.git = {
    userName = "Cody";
    userEmail = "cody@codyq.dev";
    signing.key = "14FA18936C13E1E4";
  };

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentry.package = pkgs.pinentry-qt;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
