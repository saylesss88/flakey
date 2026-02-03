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
    hideMounts = true;  # Add this to avoid permission issues
    directories = [
      "/var/lib/sbctl"
      "/var/lib/nixos"
    ];
    files = [ ];
  };
}
