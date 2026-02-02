# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

   boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      editor = false;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";       # Critical for VMs
  # Not needed with LUKS
  boot.zfs.requestEncryptionCredentials = false;
  # systemd handles mounting
  systemd.services.zfs-mount.enable = false;

  services.zfs = {
    autoScrub.enable = true;
    # periodically runs `zpool trim`
    trim.enable = true;
    # autoSnapshot = true;
  };

   boot.initrd.luks.devices = {
     cryptroot = {
    # replace uuid# with output of UUID # from `sudo blkid /dev/vda2`
       device = "/dev/disk/by-uuid/b0333bca-48d1-4f2f-a775-a74af50edd46";
       allowDiscards = true;
       preLVM = true;
     };
   };

  networking.hostName = "magic"; # Define your hostname.

  networking.hostId = "ce02bb0b";

  users.users.root.initialPassword = "changeme";

  boot.kernelParams = [ "console=tty1" ];

  # ------------------------------------------------------------------
  #  Users
  # ------------------------------------------------------------------

  users.mutableUsers = false;

  # Change `your-user`
  users.users.jr = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    group = "jr";
    # :r /tmp/pass.txt:
  initialHashedPassword = "$y$j9T$3mGOsuMNLfzJmt/H24mlS.$4.Moomit/bqNaAhHjT7OOK3ozlNAcvFHAWFVSV0MX8B";
  };

  # This enables `chown -R your-user:your-user`
  users.groups.jr = { };

  # ------------------------------------------------------------------
  #  (Optional) Helpful for recovery situations
  # ------------------------------------------------------------------
  users.users.admin = {
   isNormalUser = true;
   description = "admin account";
   extraGroups = [ "wheel" ];
   group = "admin";
  initialHashedPassword = "$y$j9T$3mGOsuMNLfzJmt/H24mlS.$4.Moomit/bqNaAhHjT7OOK3ozlNAcvFHAWFVSV0MX8B";

 };

 users.groups.admin = { };


  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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
  fileSystems."/persist".neededForBoot = true;

}


