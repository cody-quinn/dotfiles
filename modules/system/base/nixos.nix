{ config, pkgs, lib, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}

