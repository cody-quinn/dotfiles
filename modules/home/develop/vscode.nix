{ config, pkgs, lib, ... }:

let
  vscode-hyper-term-theme = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "hyper-term-theme";
    publisher = "hsnazar";
    version = "0.3.0";
    sha256 = "EIRsvvjns3FX4fTom3hHtQALEnaWf+jxakza2HTyPcw=";
  };
  vscode-todo-highlight = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-todo-highlight";
    publisher = "wayou";
    version = "1.0.5";
    sha256 = "CQVtMdt/fZcNIbH/KybJixnLqCsz5iF1U0k+GfL65Ok=";
  };
in
{
  programs.vscode.enable = true;

  programs.vscode.mutableExtensionsDir = false;
  programs.vscode.extensions = with pkgs.vscode-extensions; [
    vscode-hyper-term-theme
    vscode-todo-highlight

    esbenp.prettier-vscode
    ms-vscode-remote.remote-ssh
    eamodio.gitlens
    pkief.material-icon-theme
    arrterian.nix-env-selector
    jnoortheen.nix-ide
    bungcip.better-toml
    matklad.rust-analyzer
    ms-python.python
  ];

  programs.vscode.userSettings = {
    # Theme stuff
    "window.menuBarVisibility" = "toggle";
    "workbench.activityBar.visible" = false;
    "workbench.colorTheme" = "Hyper Term Black";
    "workbench.iconTheme" = "material-icon-theme";
    "editor.fontLigatures" = true;
    "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
    "editor.fontSize" = 13.5;

    # Formatting
    "editor.formatOnSave" = true;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.tabSize" = 2;

    # Integrated terminal
    "terminal.integrated.defaultProfile.linux" = "zsh";

    # Rust analyzer
    "rust-analyzer.inlayHints.chainingHints.enable" = false;
    "rust-analyzer.inlayHints.parameterHints.enable" = false;

    # Nix environment
    "nixEnvSelector.suggestion" = false;
    "nixEnvSelector.nixFile" = "$\{workspaceRoot\}/shell.nix";
    "nix.enableLanguageServer" = true;

    # Language specific
    "[nix]" = { "editor.defaultFormatter" = "jnoortheen.nix-ide"; };
    "[kotlin]" = { "editor.tabSize" = 4; };
    "[java]" = { "editor.tabSize" = 4; };

    "[python]" = {
      "editor.defaultFormatter" = "ms-python.python";
      "editor.tabSize" = 4;
    };

    "[rust]" = {
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
      "editor.tabSize" = 4;
    };
  };
}
