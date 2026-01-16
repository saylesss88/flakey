{
  config,
  lib,
  ...
}: let
  cfg = config.custom.security.modprobe;
in {
  options.custom.security.modprobe.enable = lib.mkEnableOption "Enable Kernel Hardening";
  config = lib.mkIf cfg.enable {
    boot = {
      extraModprobeConfig = ''
        install firewire-core /bin/false
        install firewire-ohci /bin/false
        install firewire_ohci /bin/false
        install firewire_sbp2 /bin/false
        install firewire-sbp2 /bin/false
        install firewire-net /bin/false
        install thunderbolt /bin/false
        install ohci1394 /bin/false
        install sbp2 /bin/false
        install dv1394 /bin/false
        install raw1394 /bin/false
        install video1394 /bin/false
      '';

      blacklistedKernelModules = [
        # Obscure networking protocols
        "dccp"
        "sctp"
        "rds"
        "tipc"
        "n-hdlc"
        "ax25"
        "netrom"
        "x25"
        "rose"
        "decnet"
        "econet"
        "af_802154"
        "ipx"
        "appletalk"
        "psnap"
        "p8023"
        "p8022"
        "can"
        "atm"
        # Various rare filesystems
        "cramfs"
        "freevxfs"
        "jffs2"
        "hfs"
        "hfsplus"
        "udf"

        # "squashfs"
        "cifs"
        "nfs"
        "nfsv3"
        "nfsv4"
        "ksmbd"
        "gfs2"
        # vivid driver is only useful for testing purposes and has been the
        # cause of privilege escalation vulnerabilities
        "vivid"
      ];

      kernelParams = [
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
        "resume_offset=269568"
        "boot.shell_on_fail"
        "quiet"
        "splash"
        "plymouth.use-simpledrm"
        "rd.systemd.show_status=false"
        # make it harder to influence slab cache layout
        "slab_nomerge"
        # enables zeroing of memory during allocation and free time
        # helps mitigate use-after-free vulnerabilaties
        "init_on_alloc=1"
        "init_on_free=1"
        # randomizes page allocator freelist, improving security by
        # making page allocations less predictable
        "page_alloc.shuffel=1"
        # enables Kernel Page Table Isolation, which mitigates Meltdown and
        # prevents some KASLR bypasses
        "pti=on"
        # randomizes the kernel stack offset on each syscall
        # making attacks that rely on a deterministic stack layout difficult
        "randomize_kstack_offset=on"
        # disables vsyscalls, they've been replaced with vDSO
        "vsyscall=none"
        # disables debugfs, which exposes sensitive info about the kernel
        "debugfs=off"
        # certain exploits cause an "oops", this makes the kernel panic if an "oops" occurs
        "oops=panic"
        # only alows kernel modules that have been signed with a valid key to be loaded
        # making it harder to load malicious kernel modules
        # can make VirtualBox or Nvidia drivers unusable
        "module.sig_enforce=1"
        # prevents user space code excalation
        "lockdown=confidentiality"
        # "rd.udev.log_level=3"
        # "udev.log_priority=3"
        "kernel.unprivileged_userns_clone=1"
        "user.max_user_namespaces=28633" # Default + margin
      ];
    };
  };
}
