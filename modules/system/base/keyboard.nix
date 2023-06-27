{ config, pkgs, lib, ... }:

{
  # Adding extra modprobe config options, first one making
  # the function keys on apple layout keywords actually act as
  # function keys and not special ones.
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';
}
