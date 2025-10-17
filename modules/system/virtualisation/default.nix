{
  config,
  pkgs,
  lib,
  ...
}:

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

    virtualisation.docker.enable = (mkIf cfg.docker.enable true);
    virtualisation.libvirtd = (
      mkIf cfg.kvm.enable {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      }
    );

    boot.kernelModules = [
      "kvm-amd"
      "kvm-intel"
    ];
  };
}
