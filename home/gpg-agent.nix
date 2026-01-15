{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    custom.gpg = {
      enable = lib.mkEnableOption {
        description = "Enable gpg-agent";
        default = false;
      };
    };
  };

  config = lib.mkIf config.custom.gpg.enable {
    services = {
      ## Enable gpg-agent with ssh support
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableZshIntegration = true;
        pinentry.package = pkgs.pinentry-gnome3;
      };

      ## We will put our keygrip here
      gpg-agent.sshKeys = ["EAF4B201D866E6B0155FBE4DBC5C1CCB3555980E"];
    };
    home.packages = [pkgs.gnupg];
    programs = {
      gpg = {
        ## Enable GnuPG
        enable = true;
        # homedir = "/home/userName/.config/gnupg";
        settings = {
          # Default/trusted key ID (helpful with throw-keyids)
          # Example, you will put your own keyid here
          default-key = "25A11516EBB4F979";
          trusted-key = "25A11516EBB4F979";
          # https://github.com/drduh/config/blob/master/gpg.conf
          # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
          # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
          # Some Best Practices, stronger algos etc
          # Use AES256, 192, or 128 as cipher
          personal-cipher-preferences = "AES256 AES192 AES";
          # # Use SHA512, 384, or 256 as digest
          personal-digest-preferences = "SHA512 SHA384 SHA256";
          # # Use ZLIB, BZIP2, ZIP, or no compression
          personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
          # # Default preferences for new keys
          default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
          # # SHA512 as digest to sign keys
          cert-digest-algo = "SHA512";
          # # SHA512 as digest for symmetric ops
          s2k-digest-algo = "SHA512";
          # # AES256 as cipher for symmetric ops
          s2k-cipher-algo = "AES256";
          # # UTF-8 support for compatibility
          charset = "utf-8";
          # # Show Unix timestamps
          fixed-list-mode = "";
          # # No comments in signature
          no-comments = "";
          # # No version in signature
          no-emit-version = "";
          # # Disable banner
          no-greeting = "";
          # # Long hexidecimal key format
          keyid-format = "0xlong";
          # # Display UID validity
          list-options = "show-uid-validity";
          verify-options = "show-uid-validity";
          # # Display all keys and their fingerprints
          with-fingerprint = "";
          # # Cross-certify subkeys are present and valid
          require-cross-certification = "";
          # # Disable caching of passphrase for symmetrical ops
          no-symkey-cache = "";
          # # Enable smartcard
          # use-agent = "";
        };
      };
    };
  };
}
