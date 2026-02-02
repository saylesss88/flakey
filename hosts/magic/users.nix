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
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEUpPGBjTU900F2h8xqgpx8Tty8tdeqnz3n6QCaF3NQQ"
      ];
    };
    extraGroups = lib.mkForce [
      "libvirtd"
      "kvm"
    ];
    group = "jr";
    ignoreShellProgramCheck = true;
    packages = with pkgs; [
      zoxide
      #  thunderbird
    ];
    shell = pkgs.zsh;
    # shell = pkgs.nushell;
    # hashedPasswordFile = config.sops.secrets.password_hash.path;
    # hashedPasswordFile = "/persist/etc/nixos-secrets/passwords/jr";
    initialHashedPassword = "$y$j9T$QQejm3Ayf4ImE4DeFXfd9.$K82segAqRsmdgJXcCMOGWZg7vT8ZESbabR7ug6voqgC";

  };
  users.mutableUsers = false;

  users.groups.jr = {
    gid = lib.mkForce 1000;
  };
  users.users.admin = {
    isNormalUser = true;
    description = "admin account";
    extraGroups = ["wheel"];
    group = "admin";
    packages = with pkgs; [
      #  thunderbird
    ];
    # hashedPasswordFile = config.sops.secrets.password_hash.path;
    initialHashedPassword = "$y$j9T$QQejm3Ayf4ImE4DeFXfd9.$K82segAqRsmdgJXcCMOGWZg7vT8ZESbabR7ug6voqgC";

    # hashedPasswordFile = "/persist/etc/nixos-secrets/passwords/jr";
  };

  users.groups.admin = {};
}
