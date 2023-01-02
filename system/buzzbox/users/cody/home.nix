{ config, ... }:

{
  imports = [
    ../../../../modules/home/base
  ];

  home.username = "cody";
  home.homeDirectory = "/home/cody";

  # In order to make it more clear what machine I'm using
  shell.prompt.prefix = " [buzzbox]";

  programs.git = {
    userName = "Cody";
    userEmail = "cody@codyq.dev";
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
