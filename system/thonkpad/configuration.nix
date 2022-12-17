{ config, pkgs, lib, home-manager, ... }:

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
  home-manager.users.cody = import ./users/cody/home.nix;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Networking
  networking.hostName = "thonkpad"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Timezone and internationalisation
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.utf8";

  # Configuring my display drivers & options
  services.xserver.videoDrivers = [ "nvidia" ];
  services.logind.lidSwitch = "ignore";

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.nvidia = {
    prime.offload.enable = false;
    prime.sync.enable = true;
    modesetting.enable = false;
    powerManagement.enable = true;
  };

  # Enabling AwesomeWM
  sys.desktop.awesome.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enabling mullvad VPN
  services.mullvad-vpn.enable = true;

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
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  # Packages relegated to the entire system
  environment.systemPackages = with pkgs; [
    unityhub
    mullvad
    cloudflare-warp
    autorandr
  ];

  fonts.fonts = with pkgs; [
    jetbrains-mono
    twemoji-color-font
    font-awesome
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

  # Setting default applications
  xdg.mime.defaultApplications = {
    "text/html" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
    "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
  };

  # Making a systemd service to automatically run autorandr when monitor layout changed
  # FIXME: This script is mega mega janky... Future cody please fix, current cody needs sleep
  systemd.user.services.nvidia-randrd = {
    enable = true;
    description = "autorandr daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 5;
      ExecStart = lib.concatMapStrings (x: x + "\\n") (lib.splitString "\n" "/bin/sh -c \"
          # Checking if the file \\\"/tmp/prev-monitors-connected\\\" exists, and if it doesnt creating it
          if [ ! -f /tmp/prev-monitors-connected ]; then
              echo \\\"1\\\" > /tmp/prev-monitors-connected
          fi

          # Setting the display variable
          export DISPLAY=:0

          # Checking the amount of monitors connnected and getting the results from our last check
          PREV_MONITORS_CONN=$(cat /tmp/prev-monitors-connected)
          CURR_MONITORS_CONN=$(/run/current-system/sw/bin/nvidia-settings -q dpys | grep \\\"connected\\\" | wc -l)

          # Storing the results from our check so next time the script is ran it can query the result.
          echo \\\"$CURR_MONITORS_CONN\\\" > /tmp/prev-monitors-connected

          # If the number of monitors from this check and last check dont match up, we run \\\"autorandr\\\"
          if [ $PREV_MONITORS_CONN != $CURR_MONITORS_CONN ]; then
              echo \\\"Change in monitor layout detected, running autorandr\\\"
              sleep 1

              if [ $USER = \\\"root\\\" ]; then
                  # If the user is root we run autorandr in batch mode to effect all users
                  ${pkgs.autorandr}/bin/autorandr -c --batch > /dev/null
              else
                  # Otherwise we just run autorandr the normal way
                  ${pkgs.autorandr}/bin/autorandr -c > /dev/null
              fi

              echo \\\"Monitor layout has been updated\\\"
          fi\"");
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}

