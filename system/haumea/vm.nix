{ config, pkgs, lib, inputs, ... }:

# Running on AMD system with 2 AMD GPUs.

with lib;
let
  cfg = config.sys.vm.windows;
in
{
  options.sys.vm.windows = {
    enable = mkEnableOption "Enable Windows VM";
  };

  config = (mkIf cfg.enable {
    # Kernel Parameters
    boot.initrd.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "amdgpu" ];
    boot.kernelParams = [ "amd_iommu=on" "iommu=pt" "kvm.ignore_msrs=1" ];
    boot.kernelModules = [ "kvm-amd" ];

    boot.extraModprobeConfig = ''
      options vfio-pci ids=1002:73ff,1002:ab28
    '';

    # Loading vfio-pci before graphics drivers steal my GPU
    environment.etc."modprobe.d/vfio.conf".text = ''
      softdep drm pre: vfio-pci
    '';

    # Enabling libvirtd
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "start";
      onShutdown = "shutdown";

      qemu = {
        package = pkgs.qemu_kvm;

        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

    # Installing virt-manager
    programs.virt-manager.enable = true;

    # Setting up hooks & installing VM XML file
    systemd.tmpfiles.rules =
      let 
        qemuHook = pkgs.writeShellApplication {
          name = "qemu-hook";
          runtimeInputs = with pkgs; [
            libvirt
            systemd
            kmod
          ];

          text = ''
            # GUEST_NAME="$1"
            # OPERATION="$2"

            # if [ "$GUEST_NAME" != "win10" ]; then
            #   exit 0
            # fi

            # if [ "$OPERATION" == "prepare" ]; then
            # fi

            # if [ "$OPERATION" == "release" ]; then
            # fi
          '';
        };
      in
      [
        # TODO
        # "L+ /var/lib/libvirt/hooks/qemu - - - - ${getExe qemuHook}"
        # "L+ /var/lib/libvirt/qemu/win10.xml - - - - ${./win10.xml}"

        # Setting up looking-glass and installing the client
        "f /dev/shm/looking-glass 0660 cody kvm -"
      ];

    # Installing the looking glass client
    environment.systemPackages = with pkgs; [
      looking-glass-client
    ];
  });
}
