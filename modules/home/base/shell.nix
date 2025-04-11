{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.shell.prompt;
in
{
  options.shell.prompt = {
    prefix = mkOption {
      type = types.str;
      default = "";
    };

    suffix = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      dirHashes = {
        p = "$HOME/Projects";
        doc = "$HOME/Documents";
        dwn = "$HOME/Downloads";
      };
      shellAliases = {
        o = "xdg-open";
        l = "eza";
        ls = "eza -l --icons --group-directories-first";
        la = "eza -la --icons --group-directories-first";
        lt = "eza -T -I \"node_modules|venv|Build\"";
        gs = "git status";
        ga = "git add .";
        gc = "git commit -S";
        gp = "git push";
        bat = "cat /sys/class/power_supply/BAT*/energy_now";
        k = "kubectl";
        kg = "kubectl get";
        mk = "minikube";
      };
      history = {
        size = 1000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      localVariables = {
        PROMPT = cfg.prefix + " ▲ %c " + cfg.suffix;
      };
      initExtra = ''
        eval "$(direnv hook zsh)"
      '';
    };
  };
}
