_: {
  networking.nftables = {
    enable = true;

    ruleset = ''
      table inet filter {
        chain input {
          type filter hook input priority 0; policy drop;

          # Allow traffic from established connections (replies to things you sent)
          ct state established,related accept

          # Allow localhost traffic
          iifname "lo" accept

          # Allow SSH (Port 2222)
          # tcp dport 2222 accept
          # Allow ICMP (Ping) good for debugging
          ip protocol icmp accept
          ip6 nexthdr icmpv6 accept
          }
          # FORWARDING (Router stuff - Drop by default)
          chain forward {
            type filter hook forward priority 0; policy drop;
          }
        chain output {
          type filter hook output priority 0; policy accept;

          # Allow localhost DNS for dnscrypt-proxy2
          ip daddr 127.0.0.1 udp dport 53 accept
          ip6 daddr ::1 udp dport 53 accept
          ip daddr 127.0.0.1 tcp dport 53 accept
          ip6 daddr ::1 tcp dport 53 accept

          # Allow dnscrypt-proxy2 to talk to upstream servers
          # Replace <DNSCRYPT-UID> with:
          # ps -o uid,user,pid,cmd -C dnscrypt-proxy
          meta skuid 62582 udp dport { 443, 853 } accept
          meta skuid 62582 tcp dport { 443, 853 } accept
          ip daddr { 1.1.1.1, 1.0.0.1 } udp dport 53 accept

          # Block all other outbound DNS
          udp dport { 53, 853 } drop
          tcp dport { 53, 853 } drop
        }
      }
    '';
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # 2222
      # Ports open for inbound connections.
      # Limit these to reduce the attack surface.

      # 22
      # SSH – Keep open only if you need remote access.
      # To change the SSH port in NixOS:
      # services.openssh.ports = [ 2222 ];
      # Update this list to match the new port.

      # 53  # DNS – Only if running a public DNS server.
      # 80  # HTTP – Only if hosting a website.
      # 443 # HTTPS – Only if hosting a secure website.
    ];
    allowedUDPPorts = [
      # Ports open for inbound UDP traffic.
      # Most NixOS workstations won't need any here.

      # 53 # DNS – Only if running a public DNS server.
    ];
  };
}
