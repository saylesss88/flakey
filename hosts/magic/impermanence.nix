{ config, lib, ... }:
{

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zpool import -N -f rpool
    zfs rollback -r rpool/local/root@blank
    zpool export rpool
  '';

  # environment.persistence."/persist" = {
  #   files = [
  # "/etc/ssh/ssh_host_ed25519_key"
  # "/etc/ssh/ssh_host_ed25519_key.pub"
  # ];
}
