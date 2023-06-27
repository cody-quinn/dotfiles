{ config, pkgs, lib, ... }:

{
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [
    fcitx5-chinese-addons
    fcitx5-rime
  ];

  services.xserver.displayManager.sessionCommands = ''
    export XMODIFIERS=@im=fcitx
    export QT_IM_MODULE=fcitx
    export GTK_IM_MODULE=fcitx   

    fcitx5 -dr
  '';
}
