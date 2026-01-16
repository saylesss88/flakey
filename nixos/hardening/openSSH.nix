{
  config,
  lib,
  ...
}: let
  cfg = config.custom.security.openssh;
in {
  # ──────────────────────────────────────────────────────────────
  # Public option
  # ──────────────────────────────────────────────────────────────
  options.custom.security.openssh.enable = lib.mkEnableOption "hardened OpenSSH + Fail2Ban";

  # ──────────────────────────────────────────────────────────────
  # Implementation (only active when the option is true)
  # ──────────────────────────────────────────────────────────────
  config = lib.mkIf cfg.enable {
    services = {
      fail2ban = {
        enable = true;
        maxretry = 5;
        bantime = "1h";

        # ignoreIP = [
        #   "172.16.0.0/12"
        #   "192.168.0.0/16"
        #   "2601:881:8100:8de0:31e6:ac52:b5be:462a"
        #   "matrix.org"
        #   "app.element.io"   # don't ratelimit matrix users
        # ];

        bantime-increment = {
          enable = true; # Increment bantime after each violation
          multipliers = "1 2 4 8 16 32 64 128 256";
          maxtime = "168h"; # Never ban longer than 1 week
          overalljails = true; # Count violations across all jails
        };
      };

      openssh = {
        enable = true;
        ports = [2222];

        settings = {
          PasswordAuthentication = false;
          PermitEmptyPasswords = false;
          PermitTunnel = false;
          UseDns = false;
          KbdInteractiveAuthentication = false;
          X11Forwarding = config.services.xserver.enable;
          MaxAuthTries = 3;
          MaxSessions = 2;
          ClientAliveInterval = 300;
          ClientAliveCountMax = 0;
          AllowUsers = ["jr"];
          TCPKeepAlive = false;
          AllowTcpForwarding = false;
          AllowAgentForwarding = false;
          LogLevel = "VERBOSE";
          PermitRootLogin = "no";

          KexAlgorithms = [
            "mlkem768x25519-sha256"
            "sntrup761x25519-sha512"
            "curve25519-sha256@libssh.org"
            "ecdh-sha2-nistp521"
            "ecdh-sha2-nistp384"
            "ecdh-sha2-nistp256"
            "diffie-hellman-group-exchange-sha256"
          ];

          Ciphers = [
            "aes256-gcm@openssh.com"
            "aes128-gcm@openssh.com"
            "chacha20-poly1305@openssh.com"
            "aes256-ctr"
            "aes192-ctr"
            "aes128-ctr"
          ];

          Macs = [
            "hmac-sha2-512-etm@openssh.com"
            "hmac-sha2-256-etm@openssh.com"
            "umac-128-etm@openssh.com"
            "hmac-sha2-512"
            "hmac-sha2-256"
            "umac-128@openssh.com"
          ];
        };

        hostKeys = [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
          {
            path = "/etc/ssh/nix-book-deploy-key";
            type = "ed25519";
          }
        ];
      };
    };
  };
}
