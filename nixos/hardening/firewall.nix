{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.firewalld = {
    enable = true;
    minimalConfig = false; # Enable zones/interfaces
  };
  networking.firewall.backend = "firewalld";
  virtualisation.libvirtd.firewallBackend = "firewalld"; # Auto-zone virbr0/vnetX
  services.firewalld.zones = {
    "whonix-external" = {
      interfaces = [ "Whonix-External" ]; # Host-facing
      defaultService = "tor-server"; # Allow Tor onion services
      trustedInterfaces = [ ]; # Strict inbound
    };
    "whonix-internal" = {
      interfaces = [ "Whonix-Internal" ];
      defaultService = "dhcp"; # VM-to-Gateway only
      masquerade = false; # No NAT leaks
    };
  };

}
