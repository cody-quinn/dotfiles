{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  wireplumber_0_4 = pkgs.wireplumber.overrideAttrs (attrs: rec {
    version = "0.4.17";
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "wireplumber";
      rev = version;
      hash = "sha256-vhpQT67+849WV1SFthQdUeFnYe/okudTQJoL3y+wXwI=";
    };
  });
in
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
  boot.kernelModules = [
    "i2c-dev"
    "i2c-piix4"
  ];
  boot.kernelParams = [ "video=HDMI-A-1:2560x1080@60" ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Configuring secondary drives
  fileSystems."/mnt/drive-a" = {
    device = "/dev/disk/by-uuid/aa675732-bebd-4d03-8cfc-680dc9cbd3f9";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
      "x-gvfs-show"
      "x-gvfs-name=Drive%20A"
    ];
  };

  fileSystems."/mnt/drive-b" = {
    device = "/dev/disk/by-uuid/b868a06a-679d-4c39-bdca-a840ad54caa0";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
      "x-gvfs-show"
      "x-gvfs-name=Drive%20B"
    ];
  };

  # Virtualization
  sys.vm.windows.enable = false;

  # Networking
  networking.hostName = "haumea"; # Define your hostname.
  networking.networkmanager.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    dnsovertls = "true";
  };

  services.mullvad-vpn.enable = true;

  # networking.networkmanager.dns = "none";
  # networking.resolvconf.enable = pkgs.lib.mkForce false;
  # networking.dhcpcd.extraConfig = "nohook resolv.conf";

  # Wireguard VPN
  networking.firewall = {
    allowedUDPPorts = [
      34197 # 51820 30502
    ];
    # allowedTCPPorts = [ 30502 ];
    allowedTCPPorts = [ 5173 ];
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
    #       publicKey = "JmVsavRATCvUECBdZuTUyZAIA+k/3xfCQPCGgnoD+lU=";
    #       presharedKeyFile = "/etc/wireguard/wg0-presharedkey.priv";
    #
    #       allowedIPs = [
    #         "0.0.0.0/0"
    #       ];
    #
    #       endpoint = "5.161.241.87:51820";
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

  # Enable hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (prev: {
      buildInputs = prev.buildInputs ++ [ wireplumber_0_4 ];
    });
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  security.polkit.enable = true;

  # Enabling AwesomeWM
  # sys.desktop.awesome.enable = false;

  # Enable sound with pipewire.
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
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "docker"
      "libvirtd"
      "kvm"
      "i2c"
    ];
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
    hyprlock
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
    additionalRuntimes = {
      inherit (pkgs)
        jdk23
        jdk21
        jdk17
        jdk11
        jdk8
        temurin-jre-bin-8
        ;
    };
    package = pkgs.jdk21;
  };

  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.slock.enable = true;
  programs.adb.enable = true;
  programs.noisetorch.enable = true;

  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Setup discordfetch
  systemd.user.services.discordfetch = {
    enable = true;
    description = "discordfetch";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${inputs.discordfetch.packages.${pkgs.system}.default}/bin/discordfetch \
          --button "GitHub" "https://github.com/cody-quinn" \
          --button "I use NixOS btw" "https://nixos.org"
      '';
    };
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
  };

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
