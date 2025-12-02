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
    # Communication
    (discord.override { nss = nss_latest; })
    element-desktop

    # Misc
    krita
    gimp
    obs-studio

    # Gaming
    prismlauncher

    # Development
    jetbrains.idea-ultimate
    jetbrains.rider

    # Calculator
    python310
  ];

  programs.git = {
    settings = {
      user.name = "Cody";
      user.email = "cody@codyq.dev";
    };
    signing.key = "14FA18936C13E1E4";
  };

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;

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
