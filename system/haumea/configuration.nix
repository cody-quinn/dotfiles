{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/system/base
    ../../modules/system/desktop
    ../../modules/system/runtimes
    ../../modules/system/virtualisation
    ./hardware-configuration.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Manage the user accounts using home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.cody = import ./users/cody/home.nix;

  # Kernel Modules
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Networking
  networking.hostName = "haumea"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Timezone and internationalisation
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";

  # Disabling power management & sleep
  powerManagement.enable = false;
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Configure the X11 windowing system.
  services.xserver.displayManager.startx.enable = true;
  
  # Setup drawing tablet
  hardware.opentabletdriver.enable = true;

  # Enable printing support
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  # Enable hardware acceleration
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable the GNOME Desktop Environment.
  # sys.desktop.awesome.enable = true;
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar-hyprland;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
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
    extraGroups = [ "networkmanager" "wheel" "adbusers" "docker" "libvirtd" "kvm" ];
    packages = with pkgs; [ firefox ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    hyprpaper
    wl-clipboard
    grim
    slurp

    cloudflare-warp
  ];

  # Programs and configurating them
  programs.java = {
    enable = true;
    additionalRuntimes = { inherit (pkgs) jdk17 jdk11 jdk8; };
    package = pkgs.jdk17;
  };

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.slock.enable = true;
  programs.adb.enable = true;
  programs.steam.enable = true;
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
  system.stateVersion = "22.11";
}
