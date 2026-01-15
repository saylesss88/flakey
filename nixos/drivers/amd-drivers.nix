{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.custom.drivers.amdgpu;
in {
  options.custom.drivers.amdgpu = {
    enable = mkEnableOption "Enable AMD GPU and CPU Drivers";
  };

  config = mkIf cfg.enable {
    # Systemd tmpfiles rules for ROCm HIP
    systemd.tmpfiles.rules = ["L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"];

    # Video drivers configuration for X server
    services.xserver.videoDrivers = ["amdgpu"];

    # Hardware configuration for AMD GPU and CPU
    hardware = {
      # amdgpu.amdvlk.enable = true;
      graphics = {
        enable = true;
        # Enable 32-bit support. This should correctly pull in 32-bit Mesa.
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa # This includes the 64-bit Mesa and should trigger 32-bit Mesa when enable32Bit is true
          rocmPackages.clr.icd # OpenCL
          vulkan-loader # Vulkan runtime
          vulkan-validation-layers # Vulkan debugging (optional)
          vulkan-tools # Vulkan utilities (optional)
          gpu-viewer
        ];
        extraPackages32 = with pkgs; [
        ];
      };

      # CPU microcode updates
      cpu.amd.updateMicrocode =
        lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    # Boot configuration for AMD GPU and CPU support
    boot = {
      kernelModules = [
        "kvm-amd"
        "amdgpu"
        "v4l2loopback"
      ];
      kernelParams = [
        "amd_pstate=active"
        "tsc=unstable"
        "radeon.si_support=0"
        "radeon.cik_support=0"
        "amdgpu.si_support=1"
        "amdgpu.cik_support=1"
      ];
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
      blacklistedKernelModules = ["radeon"];
    };
  };
}
