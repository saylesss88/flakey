# dnscrypt-proxy.nix
{
  pkgs,
  lib,
  inputs,
  ...
}: let
  blocklist_base = builtins.readFile inputs.oisd;
  extraBlocklist = builtins.readFile inputs.hagezi;
  blocklist_txt = pkgs.writeText "blocklist.txt" ''
    ${extraBlocklist}
    ${blocklist_base}
  '';
  hasIPv6Internet = true;
  StateDirName = "dnscrypt-proxy"; # Used for systemd StateDirectory
  StatePath = "/var/lib/${StateDirName}";
in {
  networking = {
    nameservers = ["127.0.0.1" "::1"];
    networkmanager.dns = "none";
  };

  services.resolved.enable = lib.mkForce false;

  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        cache_file = "${StatePath}/public-resolvers.md";
      };

      sources.relays = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md"
          "https://download.dnscrypt.info/resolvers-list/v3/relays.md"
        ];
        cache_file = "${StatePath}/relays.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      sources.odoh-servers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-servers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/odoh-servers.md"
        ];
        cache_file = "${StatePath}/odoh-servers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      sources.odoh-relays = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-relays.md"
          "https://download.dnscrypt.info/resolvers-list/v3/odoh-relays.md"
        ];
        cache_file = "${StatePath}/odoh-relays.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      server_names = ["odoh-cloudflare" "odoh-snowstorm"];

      # This creates the [anonymized_dns] section in dnscrypt-proxy.toml
      anonymized_dns = {
        skip_incompatible = true;
        routes = [
          {
            server_name = "odoh-snowstorm";
            via = ["odohrelay-crypto-sx"];
          }
          {
            server_name = "odoh-cloudflare";
            via = ["odohrelay-crypto-sx"];
          }
        ];
      };

      ipv6_servers = hasIPv6Internet;
      block_ipv6 = !hasIPv6Internet;
      blocked_names.blocked_names_file = "${blocklist_txt}";
      require_dnssec = true;
      require_nolog = false;
      require_nofilter = false;
      odoh_servers = true;
      dnscrypt_servers = true;
    };
  };

  # This creates /var/lib/dnscrypt-proxy with correct permissions
  systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = StateDirName;
}
