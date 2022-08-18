{ config, pkgs, lib, ... }:

with lib;
with pkgs;
let 
  cfg = config.sys.virtualisation;
in
{
  options.sys.virtualisation = {
    kvm = {
      enable = mkEnableOption "Enable KVM virtualisation";
    };

    docker = {
      enable = mkEnableOption "Enable Docker containerization";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      (mkIf cfg.kvm.enable quickemu)
    ];

    virtualisation.libvirtd.enable = cfg.kvm.enable;
    virtualisation.docker.enable = cfg.docker.enable;

    boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  };
}
