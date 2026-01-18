# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix
    ./impermanence.nix
    # ./sops.nix

  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      editor = false;
      configurationLimit = 25;
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  # avoid race conditions with systemd
  systemd.services.zfs-mount.enable = false;

  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-uuid/5b456090-e698-411a-b0cc-b83e12863453";
      allowDiscards = true;
      preLVM = true;
    };
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";
  services.zfs = {
    autoScrub.enable = true;
    # periodically runs `zpool trim`
    trim.enable = true;
    # autoSnapshot = true;
  };

  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "console=tty1" ];

  networking.hostId = "73c38cf1";

  boot.initrd.systemd.enable = false;

  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   zpool import -N -f rpool
  #   zfs rollback -r rpool/local/root@blank
  #   zpool export rpool
  # '';
  # boot.initrd.systemd.services.rollback = {
  #   description = "Rollback ZFS root";
  #   wantedBy = [ "initrd.target" ];
  #   # after = [ "zfs-import-rpool.service" ];
  #   after = [ "zfs-import-stack.target" ];
  #   before = [ "sysroot.mount" ];
  #   path = [ config.boot.zfs.package ];
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     zfs rollback -r rpool/local/root@blank
  #   '';
  # };

  environment.systemPackages = [
    pkgs.git
    pkgs.helix
    pkgs.nh
  ];
  programs.zsh.enable = true;

  custom = {
    magic.enable = true;
    greetd.enable = true;
    thunar.enable = true;
    magic.timezone = "America/New_York";
    magic.hostname = "magic";
    magic.locale = "en_US.UTF-8";
    utils.enable = true;
    nix.enable = true;
    zram.enable = true;
  };

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
