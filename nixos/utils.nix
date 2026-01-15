{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.utils;
in
{
  options.custom.utils = {
    enable = lib.mkEnableOption "Enable custom utils Package Set";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # pkgs.vim
      pkgs.bat
      pkgs.emote
      pkgs.acl
      pkgs.sops
      pkgs.age
      # pkgs.commitizen
      pkgs.nmap
      pkgs.brave
      pkgs.fzf
      pkgs.fastfetch
      pkgs.mcfly
      # pkgs.direnv
      # pkgs.element-desktop
      pkgs.pinentry-gnome3
      # pkgs.starship
      # Security/Hardening
      # pkgs.burpsuite
      pkgs.whois
      # pkgs.metasploit
      # pkgs.safe-rm
      pkgs.file
      # pkgs.xz
      # pkgs.onionshare
      # pkgs.onionshare-gui
      # pkgs.sequoia-sq
      # pkgs.b2sum
      # pkgs.kdePackages.kleopatra
      # pkgs.kernel-hardening-checker
      pkgs.bitwarden-desktop
      # pkgs.bitwarden-cli
      # pkgs.keepassxc
      # pkgs.kpcli # KeePass CLI
      # pkgs.metadata-cleaner
      pkgs.mat2
      pkgs.clamav
      pkgs.lynis
      pkgs.aide
      pkgs.age
      pkgs.sops
      # pkgs.openvas-scanner
      # pkgs.ospd-openvas
      pkgs.libpwquality
      pkgs.usbutils
      pkgs.shh
      pkgs.rustup
      pkgs.htop
      pkgs.vivid
      # pkgs.parted
      # pkgs.nickel
      # pkgs.wasistlos
      # pkgs.obsidian
      # pkgs.nufmt
      # pkgs.evcxr
      pkgs.sbctl
      # pkgs.git-filter-repo
      pkgs.cheat # Display cheat sheets for commands
      pkgs.nssmdns
      pkgs.lsof
      pkgs.yamllint
      # pkgs.statix
      # pkgs.sqlite
      # pkgs.hugo
      # pkgs.nix-eval-jobs
      # pkgs.nix-info
      # pkgs.nix-tree
      pkgs.entr
      pkgs.findutils
      pkgs.inxi # show detailed system info
      pkgs.mkpasswd
      pkgs.wget
      pkgs.eza
      # pkgs.clinfo
      pkgs.efibootmgr # manage EFI boot entries
      pkgs.inotify-tools # utility for monitoring file system events
      pkgs.unrar # tool to extract RAR archives
      pkgs.duf # Disk usage/free utility
      pkgs.ncdu # Disk usage analyzer
      pkgs.pciutils # Inspect PCI devices
      pkgs.socat # multipurpose relay tool
      pkgs.ripgrep
      pkgs.lshw # display detailed hardware info
      # pkgs.nix-prefetch-git
      # pkgs.nix-prefetch-github
      # pkgs.github-markdown-toc-go
      pkgs.tree
      pkgs.cachix
      # pkgs.dconf2nix # util to generate Nix code from dconf settings
      pkgs.dmidecode # tool to retrieve system hardware info from BIOS
      pkgs._7zz # tool for 7z archives (this might need to be pkgs._7zz or pkgs.sevenzip, depending on the exact package name)
      pkgs.p7zip
      pkgs.alsa-utils # util for ALSA sound
      pkgs.nix-diff # tool to compare derivations
      pkgs.just
      pkgs.unzip
      pkgs.meson
      pkgs.ninja
      pkgs.gcc
      pkgs.binutils
      pkgs.libgcc
      pkgs.gnumake
      pkgs.cmake
      pkgs.openssl # toolkit for TLS/SSL
      pkgs.pkg-config
      # pkgs.rssguard
      # pkgs.linuxKernel.packages.linux_zen
    ];
  };
}
