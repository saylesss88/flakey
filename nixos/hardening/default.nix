{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./security.nix
    ./systemd.nix
    ./modprobe.nix
    ./openSSH.nix
    ./auditd.nix
    ./dnscrypt-proxy.nix
    ./firewall.nix
    # ./flatpak.nix
  ];
  environment.systemPackages = [
    pkgs.vlock
  ];

  # For ssh-agent (not needed when using gpg-agent)
  # programs.ssh = {
  #   enable = true;
  #   forwardAgent = true;
  #   addKeysToAgent = "yes";
  # };

  environment.memoryAllocator.provider = "graphene-hardened-light";
  networking.firewall.enable = true;
  # sudo.enable = false;
  security = {
    polkit.enable = true;
  };
  xdg.portal.wlr.enable = false;

  # Ensure software hasn't been tampered with
  nix.settings.require-sigs = true;

  services.displayManager.autoLogin.enable = false;

  security = {
    wrappers = {
      # Remove unnecessary SUID binaries
      # fusermount.setuid = lib.mkForce false;
      # fusermount3.setuid = lib.mkForce false;
      # mount.setuid = lib.mkForce false;
      # umount.setuid = lib.mkForce false;
      pkexec.setuid = lib.mkForce false;
      su.setuid = lib.mkForce false;
      sudo.setuid = lib.mkForce false;
      sudoedit.setuid = lib.mkForce false;
      sg.setuid = lib.mkForce false;
      newgrp.setuid = lib.mkForce false;
      bwrap = {
        source = "${pkgs.bubblewrap}/bin/bwrap";
        owner = "root";
        group = "root";
        setuid = true;
      };
      newuidmap = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.shadow}/bin/newuidmap";
      };

      newgidmap = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.shadow}/bin/newgidmap";
      };
      # newgidmap.setuid = lib.mkForce false;
      # newuidmap.setuid = lib.mkForce false;
    };
    pam.services.swaylock = {
      text = ''
        auth include login
        account include login
        password include login
        session include login
      '';
    };
  };
}
