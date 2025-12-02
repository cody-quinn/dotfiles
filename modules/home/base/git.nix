{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.git.enable = true;
  programs.git.settings = {
    core.editor = "nvim";
    commit.gpgsign = true;
  };
}
