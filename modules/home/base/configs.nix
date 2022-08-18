{ config, pkgs, lib, ... }:

{
  xdg.configFile.nvim = {
    source = ./config/nvim;
    recursive = true;
  };
}
