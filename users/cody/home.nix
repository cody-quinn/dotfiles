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

    # Development tools
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
      l = "exa";
      ls = "exa -l --icons --group-directories-first";
      la = "exa -la --icons --group-directories-first";
      lt = "exa -T -I \"node_modules|venv|Build\"";
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

  xdg.configFile.qutebrowser = {
    source = ./config/qutebrowser;
    recursive = true;
  };

  xdg.configFile.rofi = {
    source = ./config/rofi;
    recursive = true;
  };

  # Themes
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
