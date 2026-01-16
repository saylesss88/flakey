{
  lib,
  config,
  ...
}: let
  cfg = config.custom.security.security;
in {
  options.custom.security.security.enable = lib.mkEnableOption "Enable security module";
  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl = {
      # Prevents SUID binaries from creating core dumps
      "fs.suid_dumpable" = false;
      # prevent pointer leaks
      "kernel.kptr_restrict" = 2;
      # restrict kernel log to CAP_SYSLOG capability
      "kernel.dmesg_restrict" = 1;
      # Note: certian container runtimes or browser sandboxes might rely on the following
      # restrict eBPF to the CAP_BPF capability
      "kernel.unprivileged_bpf_disabled" = 1;
      # should be enabled along with bpf above
      # "net.core.bpf_jit_harden" = 2;
      # restrict loading TTY line disciplines to the CAP_SYS_MODULE
      "dev.tty.ldisk_autoload" = 0;
      # prevent exploit of use-after-free flaws
      "vm.unprivileged_userfaultfd" = 0;
      # kexec is used to boot another kernel during runtime and can be abused
      "kernel.kexec_load_disabled" = 1;
      # Kernel self-protection
      # The Magic SysRq key is a key combo that allows users connected to the
      # system console of a Linux kernel to perform some low-level commands.
      # Disable it, since we don't need it, and is a potential security concern.
      "kernel.sysrq" = 4;
      # disable unprivileged user namespaces, Note: Docker, and other apps may need this
      # "kernel.unprivileged_userns_clone" = 0;
      "kernel.unprivileged_userns_clone" = 1;
      # restrict all usage of performance events to the CAP_PERFMON capability
      "kernel.perf_event_paranoid" = 3;

      # Network
      # protect against SYN flood attacks (denial of service attack)
      "net.ipv4.tcp_syncookies" = 1;
      # protection against TIME-WAIT assassination
      "net.ipv4.tcp_rfc1337" = 1;
      # enable source validation of packets received (prevents IP spoofing)
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.rp_filter" = 1;

      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      # Protect against IP spoofing
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;

      # prevent man-in-the-middle attacks
      "net.ipv4.icmp_echo_ignore_all" = 1;

      # ignore ICMP request, helps avoid Smurf attacks
      "net.ipv4.conf.all.forwarding" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_source_route" = 0;
      # Reverse path filtering causes the kernel to do source validation of
      "net.ipv6.conf.all.forwarding" = 0;
      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.default.accept_ra" = 0;

      ## TCP hardening
      # Prevent bogus ICMP errors from filling up logs.
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

      # Disable TCP SACK
      # "net.ipv4.tcp_sack" = 0;
      # "net.ipv4.tcp_dsack" = 0;
      # "net.ipv4.tcp_fack" = 0;

      # Userspace
      # restrict usage of ptrace
      "kernel.yama.ptrace_scope" = 2;
      # "kernel.yama.ptrace_scope" = 1;

      # ASLR memory protection (64-bit systems)
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;

      # only permit symlinks to be followed when outside of a world-writable sticky directory
      "fs.protected_symlinks" = 1;
      "fs.protected_hardlinks" = 1;
      # Prevent creating files in potentially attacker-controlled environments
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;

      # Randomize memory
      "kernel.randomize_va_space" = 2;
      # Exec Shield (Stack protection)
      "kernel.exec-shield" = 1;

      ## TCP optimization
      # TCP Fast Open is a TCP extension that reduces network latency by packing
      # data in the sender’s initial TCP SYN. Setting 3 = enable TCP Fast Open for
      # both incoming and outgoing connections:
      "net.ipv4.tcp_fastopen" = 3;
      # Bufferbloat mitigations + slight improvement in throughput & latency
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "cake";
    };
    programs = {
      # My traceroute network diagnostics
      mtr.enable = true;
      # Gui App for Gnome keyring
      seahorse.enable = true;
    };
    services = {
      gnome.gnome-keyring.enable = true;
      gnome.gcr-ssh-agent.enable = false;
    };
    # services.usbguard.enable = true;
    security = {
      # pam.services.hyprlock.text = "auth include login";
      pam.loginLimits = [
        {
          domain = "*"; # Applies to all users/sessions
          type = "-"; # The resource type (core dump size)
          item = "core"; # The soft/hard limit item
          value = "0"; # Core dumps size is limited to 0
        }
      ];
      # pam.services.swaylock.text = "auth include login";
      pam.services.greetd.enableGnomeKeyring = true;

      # userland niceness (RealtimeKit)
      rtkit.enable = true;

      pam.services.swaylock = {
        text = ''
          auth include login
          account include login
          password include login
          session include login
        '';
      };

      polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.user == "jr") {
            /* Auto-approve nixos-rebuild */
            if (action.id.indexOf("org.nixos") == 0) {
              polkit.log("Auto-approve nixos-rebuild for jr");
              /* return polkit.Result.YES; */
              return polkit.Result.AUTH_ADMIN_KEEP;
            }

            /* Auto-approve nh (it uses systemd-run with nh binary) */
            # if (action.lookup("program")?.indexOf("nh") != -1) {
            #   polkit.log("Auto-approve nh for jr");
            #   return polkit.Result.YES;
            # }
          }
        });
      '';
    };

    environment.etc."issue".text = ''
      Access prohibited, this system is audited and actively monitored no privacy should be expected
    '';

    # Force at least one uppercase letter in passwds
    environment.etc."/security/pwquality.conf".text = ''
      ucredit=-1
    '';
    # Require long passwords
    environment.etc."login.defs".text = lib.mkForce ''
      PASS_MIN_LEN 12
      PASS_MAX_DAYS 90
      PASS_MIN_DAYS 7
      PASS_WARN_AGE 14
      ENCRYPT_METHOD SHA256
    '';
    users.groups.netdev = {};
    services = {
      # gnome.gnome-keyring.enable = true;
      userborn.enable = false;
      dbus.implementation = "broker";
      logrotate.enable = false;
      journald = {
        storage = "volatile"; # Store logs in memory
        upload.enable = false; # Disable remote log upload (the default)
        extraConfig = ''
          SystemMaxUse=500M
          SystemMaxFileSize=50M
        '';
      };
    };
  };
}
