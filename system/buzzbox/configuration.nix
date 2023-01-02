{ config, pkgs, lib, home-manager, ... }:

{
  imports = [
    ../../modules/system/base
    ../../modules/system/virtualisation
    ./hardware-configuration.nix
  ];

  # Allow the installation of non-FOSS packages
  nixpkgs.config.allowUnfree = true;

  # Manage the user accounts using home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.cody = import ./users/cody/home.nix;

  # Boot
  boot.cleanTmpDir = true;
  zramSwap.enable = true;

  # Networking
  networking.hostName = "buzzbox";
  networking.domain = "";

  # Enabling OpenSSH
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.kbdInteractiveAuthentication = false;

  # Timezone and internationalisation
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.utf8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cody = {
    isNormalUser = true;
    description = "Cody";
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
    initialPassword = "password123";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRKLEellJCKQZ80YXAnMmIegA5WQLGN/P38TO1lxBRJ codyquinn1122@gmail.com"
    ];
  };

  # Programs and configurating them
  programs.zsh.enable = true;

  # Setting up docker
  sys.virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
