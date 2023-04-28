{ config, pkgs, lib, ... }:

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
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      dirHashes = {
        p = "$HOME/Projects";
        doc = "$HOME/Documents";
        dwn = "$HOME/Downloads";
      };
      shellAliases = {
        l = "exa";
        ls = "exa -l --icons --group-directories-first";
        la = "exa -la --icons --group-directories-first";
        lt = "exa -T -I \"node_modules|venv|Build\"";
        gs = "git status";
        ga = "git add .";
        gc = "git commit -S";
        gp = "git push";
        bat = "cat /sys/class/power_supply/BAT*/energy_now";
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
