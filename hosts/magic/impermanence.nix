{
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  # boot.initrd.postMountCommands = lib.mkAfter ''
  #   zfs rollback -r rpool/local/root@blank
  # '';

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/sbctl"
      "/var/lib/nixos"
      # "/var/lib/libvirt/images"
      # "/var/lib/libvirt/networks"
      # "/var/log/libvirt"
      # "/var/lib/dnscrypt-proxy"
    ];
    files = [
      # "/var/lib/libvirt/libvirt.conf"
      # "/var/lib/dnscrypt-proxy/blocklist.txt"
    ];
  };
  fileSystems."/persist" = {
    device = "rpool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };
}
