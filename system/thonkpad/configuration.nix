{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ../../modules/system/base
    ../../modules/system/desktop
    ../../modules/system/runtimes
    ../../modules/system/virtualisation
    ./hardware-configuration.nix
  ];

  # Allow the installation of non-FOSS packages
  nixpkgs.config.allowUnfree = true;

  # Manage the user accounts using home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.cody = import ./users/cody/home.nix;

   virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "cody" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Networking
  networking.hostName = "thonkpad"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  networking.firewall = {
    allowedUDPPorts = [ ];
    allowedTCPPorts = [ 8000 ];
  };

  services.mullvad-vpn.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Timezone and internationalisation
  time.timeZone = "America/Phoenix";
  i18n.defaultLocale = "en_US.utf8";

  # Configuring my display drivers & options
  services.xserver.videoDrivers = [ "nvidia" ];
  services.logind.lidSwitch = "ignore";

  hardware.graphics.enable = true;
  hardware.nvidia = {
    prime.offload.enable = false;
    prime.sync.enable = true;
    modesetting.enable = true;
    powerManagement.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Setup OpenSSH
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cody = {
    isNormalUser = true;
    description = "Cody";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "docker"
      "libvirtd"
      "kvm"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINEVUY3XYjzUdW6Nm7psFrlIEA0OmRP5CEIWLl9D8dOy cody@codyq.dev"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINRKLEellJCKQZ80YXAnMmIegA5WQLGN/P38TO1lxBRJ codyquinn1122@gmail.com"
    ];
  };

  # Packages relegated to the entire system
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    cloudflare-warp

    wine64
    winetricks
    bottles

    unityhub

    # Mounting iOS devices
    libimobiledevice
    ifuse
  ];

  services.flatpak.enable = true;

  # Programs and configurating them
  programs.java = {
    enable = true;
    additionalRuntimes = {
      inherit (pkgs)
        jdk23
        jdk21
        jdk17
        jdk11
        jdk8
        ;
    };
    package = pkgs.jdk21;
  };

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.slock.enable = true;
  programs.adb.enable = true;
  programs.noisetorch.enable = true;

  # Setting up docker
  sys.virtualisation.kvm.enable = true;
  sys.virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
