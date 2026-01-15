{ pkgs, inputs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix
    inputs.mdbook-nix-repl.nixosModules.default
    ./sops.nix
    # ./nix-repl-server.nix
  ];

  custom.nix-repl-server = {
    enable = true;
    port = 8080; # Optional, defaults to 8080
    tokenFile = "/etc/nix-repl-server.env";
  };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = false;
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };

  # Setup keyfile
  # boot.initrd.secrets = {
  #   "/boot/crypto_keyfile.bin" = null;
  # };

  nix.settings.http-connections = 100;
  systemd.services.nix-daemon.serviceConfig.MemoryMax = "8G";

  # boot.loader.grub.enableCryptodisk = true;

  # boot.initrd.luks.devices."luks-457e04f3-7eb9-4223-a07b-b7b384b20575".keyFile = "/boot/crypto_keyfile.bin";
  networking.hostName = "magic"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    git
    helix
    yazi
  ];

  # environment.memoryAllocator.provider = "graphene-hardened-light";
  boot.kernelModules = [ "kvm-amd" ];

  custom = {
    magic.enable = true;
    greetd.enable = true;
    thunar.enable = true;
    magic.timezone = "America/New_York";
    magic.hostname = "magic";
    magic.locale = "en_US.UTF-8";
    # drivers.amdgpu.enable = true;
    utils.enable = true;
    nix.enable = true;
    zram.enable = true;
    security = {
      auditd.enable = true;
      openssh.enable = true;
      systemd.enable = true;
      security.enable = true;
      modprobe.enable = true;
    };
  };
  # Explicitly disable wireless adapters
  # networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  #=====Disable Unnecessary Services for a VM======#
  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = false;
      alsa.support32Bit = false;
      pulse.enable = true;
    };
    avahi.enable = false;
    geoclue2.enable = false;

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  networking.modemmanager.enable = false;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
  hardware.graphics.enable = true;
  # hardware.graphics.driSupport32Bit = true;
  # nix.settings.experimental-features = [
  #   "nix-command"
  #   "flakes"
  #   "pipe-operators"
  # ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
