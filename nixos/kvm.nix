{
  config,
  pkgs,
  ...
}:
{
  ##  QEMU-KVM
  environment.systemPackages = with pkgs; [
    qemu
    # Optional
    virt-viewer
  ];

  # Virt-Manager GUI
  programs.virt-manager.enable = true;
  virtualisation = {
    # libvirtd daemon
    libvirtd = {
      enable = true;
      qemuOvmf.enable = true;
      qemu = {
        verity = true;
        # enables a TPM emulator
        swtpm.enable = true;
      };
    };
    # allow USB device to be forwarded
    spiceUSBRedirection.enable = true;
  };
  # Spice protocol improves VM display and input responsiveness
  services.spice-vdagentd.enable = true;
}
