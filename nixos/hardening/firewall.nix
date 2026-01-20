{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.firewalld = {
    enable = true;
    # minimalConfig = false; # Enable zones/interfaces
  };
  networking = {
    nftables.enable = true;
    firewall.backend = "nftables";
  };
  services.firewalld.zones = {
    whonix-external = {
      target = "DROP";
      interfaces = [ "Whonix-External" ];
      services = [
        "dhcp"
        "tor-server"
      ];
    };
    whonix-internal.interfaces = [ "Whonix-Internal" ];
  };
  networking.firewall.allowedTCPPorts = [
    5900
    5901
  ]; # Spice/VNC
  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
