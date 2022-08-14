{ config, pkgs, ... }:

{
  home.username = "cody";
  home.homeDirectory = "/home/cody";

  home.packages = with pkgs; [
    # Desktop software
    (discord.override { nss = nss_latest; })
    qutebrowser
    firefox
    thunderbird
    alacritty
    pavucontrol
    flameshot
    krita
    bitwarden
    obs-studio
    notion-app-enhanced

    # Gamer time
    polymc

    # Development tools
    neovide
    vscode
    jetbrains.idea-ultimate
    jetbrains.rider
    jetbrains.datagrip
    android-studio

    gradle
    maven

    # Gnome software
    gnome.nautilus
    gnome.gnome-disk-utility
    baobab

    # Launchers
    rofi
    rofimoji

    # CLI tools
    pamixer
    brightnessctl
    playerctl
    youtube-dl
    mpv
    exa
  ];

  programs.git = {
    enable = true;
    userName  = "Cody";
    userEmail = "cody@codyq.dev";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      vim = "nvim";
      l = "exa";
      ls = "exa -l --icons --group-directories-first";
      la = "exa -la --icons --group-directories-first";
      lt = "exa -T -I \"node_modules|venv|Build\"";
      gs = "git status";
      ga = "git add .";
      gc = "git commit -S";
      gp = "git push";
    };
    history = {
      size = 1000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    localVariables = {
      PROMPT = " ▲ %c ";
    };
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  # Anything Nix doesn't have a module for managing the dotfiles
  # of yet we can do so with it's native configuration language
  xdg.configFile.alacritty = {
    source = ./config/alacritty;
    recursive = true;
  };

  xdg.configFile.awesome = {
    source = ./config/awesome;
    recursive = true;
  };

  xdg.configFile.flameshot = {
    source = ./config/flameshot;
    recursive = true;
  };

  xdg.configFile.nvim = {
    source = ./config/nvim;
    recursive = true;
  };

  xdg.configFile.rofi = {
    source = ./config/rofi;
    recursive = true;
  };

  # Additional files that dont fit the "xdg" format, such as 
  # qutebrowser config.py and greasemonkey scripts.
  home.file."./.config/qutebrowser/config.py".source = ./config/qutebrowser/config.py;

  home.file."./.config/qutebrowser/greasemonkey/return-youtube-dislike.user.js".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Anarios/return-youtube-dislike/4e0f633a1478191cb9e7fcce085ff7ffda19405e/Extensions/UserScript/Return%20Youtube%20Dislike.user.js";
    hash = "sha256-RTlB1BRZG2Lvr31LprLVKm6OAJlP2ZKSqiT/Fj2ItZw=";
  };

  # Themes
  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 24;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };

    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      package = pkgs.adwaita-qt;
      name = "Adwaita-dark";
    };
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
