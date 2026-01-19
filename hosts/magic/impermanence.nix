{ lib, ... }: {
  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   zpool import -N -f rpool
  #   zfs rollback -r rpool/local/root@blank
  #   zpool export rpool
  # '';
  boot.initrd.postMountCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  environment.persistence."/persist" = { directories = [ "/var/lib/sbctl" "/var/lib/nixos" ]; };
  fileSystems."/persist" = {
    device = "rpool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };
}
