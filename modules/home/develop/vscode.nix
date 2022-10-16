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
  vscode-kotlin-lang-support = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "kotlin";
    publisher = "fwcd";
    version = "0.2.26";
    sha256 = "djo1m0myIpEqz/jGyaUS2OROGnafY7YOI5T1sEneIK8=";
  };
  vscode-java-decompiler = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "java-decompiler";
    publisher = "dgileadi";
    version = "0.0.3";
    sha256 = "VpfOHluImVGDwaZxIj7jjZf1nlVByp8xDYFQvGxRklc=";
  };
  vscode-monkeypatch = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "monkey-patch";
    publisher = "iocave";
    version = "0.1.19";
    sha256 = "+DqRMy8un62OXOi2GK0IQ4z+B73Wq/htx3o2hAniP5A=";
  };
  vscode-customize-ui = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "customize-ui";
    publisher = "iocave";
    version = "0.1.64";
    sha256 = "FDymc/ueYQ1G4i8pPGFxVYLeFo6y2paaqVApCvt+IIA=";
  };
  vscode-fsharp-highlight-templates = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-template-fsharp-highlight";
    publisher = "alfonsogarciacaro";
    version = "1.7.0";
    sha256 = "yht+l6PcGK1w+xShv6psrQ4WP1pV7B5ALSyTqn9oE6g=";
  };
  vscode-wasm = pkgs.vscode-utils.extensionFromVscodeMarketplace {
    name = "vscode-wasm";
    publisher = "dtsvet";
    version = "1.3.1";
    sha256 = "0Zn1lerqwDhxPbcVGN0yYL2IFRwK+ATioGkq9Ve8S3s=";
  };
in
{
  programs.vscode.enable = true;

  programs.vscode.mutableExtensionsDir = false;
  programs.vscode.extensions = with pkgs.vscode-extensions; [
    vscode-hyper-term-theme
    vscode-todo-highlight
    vscode-kotlin-lang-support
    vscode-java-decompiler
    vscode-monkeypatch
    vscode-customize-ui
    vscode-fsharp-highlight-templates
    vscode-wasm

    WakaTime.vscode-wakatime
    esbenp.prettier-vscode
    ms-vscode-remote.remote-ssh
    ms-vsliveshare.vsliveshare
    eamodio.gitlens
    pkief.material-icon-theme
    usernamehw.errorlens
    vadimcn.vscode-lldb
    arrterian.nix-env-selector
    jnoortheen.nix-ide
    bungcip.better-toml
    matklad.rust-analyzer
    ms-dotnettools.csharp
    ionide.ionide-fsharp
    ms-python.python
    redhat.java
  ];

  programs.vscode.userSettings = {
    # Theme stuff
    "window.menuBarVisibility" = "hidden";
    "workbench.activityBar.visible" = false;
    "workbench.colorTheme" = "Hyper Term Black";
    "workbench.iconTheme" = "material-icon-theme";
    "editor.fontLigatures" = true;
    "editor.fontFamily" = "'JetBrains Mono', 'Font Awesome 6 Free', 'monospace', monospace";
    "editor.fontSize" = 13.5;
    "explorer.decorations.badges" = false;
    "explorer.compactFolders" = false;
    "breadcrumbs.enabled" = false;
    "gitlens.codeLens.enabled" = false;

    "workbench.colorCustomizations" = {
      "[Hyper Term Black]" = {
        "sideBarSectionHeader.background" = "#000000";
      };
    };

    # Formatting
    "editor.formatOnSave" = true;
    "editor.tabSize" = 4;

    # Integrated terminal
    "terminal.integrated.shellIntegration.enabled" = false;
    "terminal.integrated.defaultProfile.linux" = "zsh";
    "terminal.integrated.fontSize" = 11;

    # Debugging
    "debug.allowBreakpointsEverywhere" = true;

    # Rust analyzer
    "rust-analyzer.inlayHints.chainingHints.enable" = false;
    "rust-analyzer.inlayHints.parameterHints.enable" = false;
    "rust-analyzer.checkOnSave.command" = "clippy";

    # F# Ionide
    "FSharp.inlayHints.enabled" = false;
    "FSharp.inlayHints.typeAnnotations" = false;
    "FSharp.inlayHints.parameterNames" = false;

    # Java & Kotlin
    "java.saveActions.organizeImports" = true;

    # Nix environment
    "nixEnvSelector.suggestion" = false;
    "nixEnvSelector.nixFile" = "$\{workspaceRoot\}/shell.nix";
    "nix.enableLanguageServer" = true;

    # Language specific
    "[rust]" = { "editor.defaultFormatter" = "rust-lang.rust-analyzer"; };
    "[fsharp]" = { "editor.defaultFormatter" = "Ionide.Ionide-fsharp"; };
    "[csharp]" = { "editor.defaultFormatter" = "ms-dotnettools.csharp"; };
    "[kotlin]" = { "editor.defaultFormatter" = "fwcd.kotlin"; };
    "[java]" = { "editor.defaultFormatter" = "redhat.java"; };
    "[python]" = { "editor.defaultFormatter" = "ms-python.python"; };

    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.tabSize" = 2;
    };

    "[json]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.tabSize" = 2;
    };

    "[jsonc]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.tabSize" = 2;
    };

    "[javascript]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.tabSize" = 2;
    };

    "[javascriptreact]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.tabSize" = 2;
    };

    "[typescript]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.tabSize" = 2;
    };

    "[typescriptreact]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.tabSize" = 2;
    };
  };

  programs.vscode.keybindings = [
    {
      "key" = "ctrl+shift+s";
      "command" = "workbench.view.extension.liveshare";
    }
    {
      "command" = "workbench.view.extension.ionide-fsharp";
      "key" = "ctrl+shift+r";
    }
  ];
}
