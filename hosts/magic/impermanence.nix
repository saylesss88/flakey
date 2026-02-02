{
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];
  
  boot.initrd.postMountCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  # Add these filesystem entries
  fileSystems."/" = {
    device = "rpool/local/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/local/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/safe/home";
    fsType = "zfs";
    neededForBoot = true;  # Important!
  };

  fileSystems."/persist" = {
    device = "rpool/safe/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  environment.persistence."/persist" = {
    hideMounts = true;  # Add this to avoid permission issues
    directories = [
      "/var/lib/sbctl"
      "/var/lib/nixos"
    ];
    files = [ ];
  };
}
