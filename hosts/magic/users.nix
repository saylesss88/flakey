{
  pkgs,
  lib,
  ...
}: {
  users.users.jr = {
    isNormalUser = true;
    description = "jr";
    uid = 1000;
    openssh = {
      authorizedKeys.keys = [
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDp1GILFjayKi/mKBMg36nDV8TyG+rZDXmNheYdOzA4N (none)"
      ];
    };
    extraGroups = lib.mkForce [
      "networkmanager"
      "podman"
    ];
    group = "jr";
    ignoreShellProgramCheck = true;
    packages = with pkgs; [
      zoxide
      #  thunderbird
    ];
    shell = pkgs.zsh;
    hashedPasswordFile = "/persist/etc/nixos-secrets/passwords/jr";
  };
  users.mutableUsers = false;

  users.groups.jr = {
    # gid = lib.mkForce 1000;
  };
  users.users.admin = {
    isNormalUser = true;
    description = "admin account";
    extraGroups = ["wheel"];
    group = "admin";
    packages = with pkgs; [
      #  thunderbird
    ];
    hashedPasswordFile = "/persist/etc/nixos-secrets/passwords/jr";
  };

  users.groups.admin = {};
}
