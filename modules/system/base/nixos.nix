{
  config,
  pkgs,
  lib,
  ...
}:

{
  nix = {
    package = pkgs.nixVersions.stable;
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
