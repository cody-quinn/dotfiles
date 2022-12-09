{ config, pkgs, lib, ... }:

{
  programs.git.enable = true;
  programs.git.extraConfig = {
    core.editor = "nvim";
  };
}
