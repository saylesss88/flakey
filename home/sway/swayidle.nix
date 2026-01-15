{pkgs, ...}: {
  services.swayidle = {
    enable = true;
    events = {
      "before-sleep" = "${pkgs.swaylock-effects}/bin/swaylock";
      "lock" = "${pkgs.swaylock-effects}/bin/swaylock";
    };
    timeouts = [
      {
        timeout = 500;
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
    ];
  };
}
