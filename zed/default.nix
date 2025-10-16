{
  config,
  pkgs,
  lib,
  username,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    zed-editor
  ];

  home-manager.users.${username} = {
    home.file.".config/zed/keymap.json".source = ./keymap.json;
    home.file.".config/zed/settings.json".source = ./settings.json;
  };
}
