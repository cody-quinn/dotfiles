{ config, pkgs, ... }:

{
  imports = [
    ../../../../modules/home/base
    ../../../../modules/home/desktop
    ../../../../modules/home/develop
  ];

  home.username = "cody";
  home.homeDirectory = "/home/cody";

  home.packages = with pkgs; [
    # Desktop software
    (discord.override { nss = nss_latest; })
    element-desktop
    qutebrowser
    krita
    bitwarden
    obs-studio
    aseprite-unfree

    # Gamer time
    prismlauncher

    # Development tools
    jetbrains.idea-ultimate
    android-studio
    insomnia

    virt-manager
    minikube
    kubectl

    # Gnome software
    baobab

    # CLI tools
    zathura
    youtube-dl
    mpv

    # Calculator
    python310
  ];

  programs.git = {
    userName = "Cody";
    userEmail = "cody@codyq.dev";
  };

  programs.autorandr = {
    enable = true;
    profiles = {
      "laptop" = {
        fingerprint = {
          "DP-4" = "00ffffffffffff0030e44f0500000000001a010495221378eaa1c59459578f27205054000000010101010101010101010101010101012e3680a070381f403020350058c21000001ab62c80f4703816403020350058c21000001a000000fe004c4720446973706c61790a2020000000fe004c503135365746362d53504b330086";
        };
        config = {
          "DP-4" = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
          };
        };
      };
      "docked" = {
        fingerprint = {
          "DP-1" = "00ffffffffffff001e6d1477fe540400091e010380502278eaca95a6554ea1260f5054256b807140818081c0a9c0b300d1c08100d1cfcd4600a0a0381f4030203a001e4e3100001a023a801871382d40582c45001e4e3100001e000000fd00384b1e5a19000a202020202020000000fc004c472048445220574648440a2001b3020337f1230907074c100403011f1359da125d5e5f830100006d030c001000b83c20006001020367d85dc4013c8000e305c000e3060501295900a0a038274030203a001e4e3100001a565e00a0a0a02950302035001e4e3100001a000000ff00303039494e554238423930320a00000000000000000000000000000000000096";
          "DP-3" = "00ffffffffffff001e6df25934c70900061e0104a55022789eca95a6554ea1260f5054a54b80714f818081c0a9c0b3000101010101017e4800e0a0381f4040403a001e4e31000018023a801871382d40582c45001e4e3100001a000000fc004c4720554c545241574944450a000000fd00384b1e5a18000a202020202020012502031c71499004030012001f0113230907078301000065030c001000023a801871382d40582c450056512100001e011d8018711c1620582c2500a5222100009e011d007251d01e206e285500a5222100001e8c0ad08a20e02d10103e9600a52221000018000000000000000000000000000000000000000000000000000000d5";
          "DP-4" = "00ffffffffffff0030e44f0500000000001a010495221378eaa1c59459578f27205054000000010101010101010101010101010101012e3680a070381f403020350058c21000001ab62c80f4703816403020350058c21000001a000000fe004c4720446973706c61790a2020000000fe004c503135365746362d53504b330086";
        };
        config = {
          "DP-3" = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "2560x1080";
          };
          "DP-1" = {
            enable = true;
            primary = true;
            position = "0x1080";
            mode = "2560x1080";
          };
          "DP-4" = {
            enable = true;
            primary = false;
            position = "2560x1080";
            mode = "1920x1080";
          };
        };
      };
    };
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  # Additional files that dont fit the "xdg" format, such as 
  # qutebrowser config.py and greasemonkey scripts.
  home.file."./.config/qutebrowser/config.py".source = ./config/qutebrowser/config.py;
  home.file."./.config/qutebrowser/greasemonkey/return-youtube-dislike.user.js".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Anarios/return-youtube-dislike/de1831f2c74032f8ccfe42a8eb174088363e011f/Extensions/UserScript/Return%20Youtube%20Dislike.user.js";
    hash = "sha256-aJwGbsZ3XoO/Xf7wGqjWR21XCqbELMBP2SUKE7kwtyw=";
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
