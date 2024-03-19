{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/system/base
    ../../modules/system/desktop
    ../../modules/system/runtimes
    ../../modules/system/virtualisation
    ./hardware-configuration.nix
    ./vm.nix
  ];

  # Allow unfree packages & permit certain packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Manage the user accounts using home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.cody = import ./users/cody/home.nix;

  # Kernel
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];
  boot.kernelParams = [ "video=HDMI-A-1:2560x1080@60" ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Virtualization
  sys.vm.windows.enable = true;

  # Networking
  networking.hostName = "haumea"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.networkmanager.enable = true;

  # Wireguard VPN
  networking.firewall = {
    allowedTCPPorts = [ 3000 ];
    allowedUDPPorts = [ 51820 ];
  };

  networking.wg-quick.interfaces = {
    # wg0 = {
    #   address = [ 
    #     "172.30.0.2/32" 
    #     "2a01:4ff:f0:c8c1:ac1e::2/128" 
    #   ];
    #
    #   dns = [ 
    #     "1.1.1.1" "1.0.0.1" 
    #     "2606:4700:4700::1111" "2606:4700:4700::1001" 
    #   ];
    #
    #   listenPort = 51820;
    #   mtu = 1300;
    #
    #   privateKeyFile = "/etc/wireguard/wg0-key.priv";
    #
    #   peers = [
    #     {
    #       publicKey = "x/+Y8FskYpnm7pI/g61QS3VJWOeHXEbR+ogbNeKTdDE=";
    #       presharedKeyFile = "/etc/wireguard/wg0-presharedkey.priv";
    #
    #       allowedIPs = [ 
    #         "172.30.0.1" 
    #         "0.0.0.0/0"
    #       ];
    #
    #       endpoint = "wireguard.codyq.dev:51820";
    #       persistentKeepalive = 15;
    #     }
    #   ];
    # };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Timezone and internationalisation
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";

  # Disabling power management & sleep
  powerManagement.enable = false;
  systemd.targets.sleep.enable = true;
  systemd.targets.suspend.enable = true;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Configure the X11 windowing system.
  services.xserver.displayManager.startx.enable = true;
  
  # Setup drawing tablet
  hardware.opentabletdriver.enable = true;

  # Enable printing support
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  # Enable hardware acceleration
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cody = {
    isNormalUser = true;
    description = "Cody";
    extraGroups = [ "networkmanager" "wheel" "adbusers" "docker" "libvirtd" "kvm" "i2c" ];
    packages = with pkgs; [ firefox ];
    shell = pkgs.zsh;
  };

  # Enable RGB
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.motherboard = "amd";

  # Setting up Plex
  services.plex.enable = true;
  services.plex.openFirewall = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # For Hyprland
    hyprpaper
    wl-clipboard
    grim
    slurp

    # Unrelated
    cloudflare-warp
    i2c-tools
  ];

  services.flatpak.enable = true;

  # Programs and configurating them
  programs.java = {
    enable = true;
    additionalRuntimes = { inherit (pkgs) jdk21 jdk17 jdk11 jdk8; };
    package = pkgs.jdk21;
  };

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.slock.enable = true;
  programs.adb.enable = true;
  programs.steam.enable = true;
  programs.noisetorch.enable = true;

  # Setup nix ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  # Setting up docker
  sys.virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11";
}
