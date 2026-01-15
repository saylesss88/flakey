_: {
  services.timesyncd.enable = false;
  services.chrony = {
    enable = true;
    enableNTS = true;
    servers = [
      "time.cloudflare.com iburst nts"
      "ntppool1.time.nl iburst nts"
      "nts.netnod.se iburst nts"
      "ptbtime1.ptb.de iburst nts"
      "time.dfm.dk iburst nts"
      "time.cifelli.xyz iburst nts"
    ];
    # extraConfig = ''
    #     minsources 3
    #     authselectmode require
    #   dscp 46

    #   driftfile /var/lib/chrony/drift
    #   dumpdir /var/lib/chrony
    #   ntsdumpdir /var/lib/chrony

    #   leapsectz /usr/share/zoneinfo/leap-seconds.list
    # makestep 1.0 3

    #   rtconutc
    #   cmdport 0
    #   noclientlog
    # '';
  };
  # Ensure chrony starts AFTER the network is up AND a socket is available (DNS/NTS-KE)
}
