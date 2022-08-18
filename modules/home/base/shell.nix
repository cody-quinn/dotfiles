{ config, pkgs, lib, ... }:

{
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
}
