{
  pkgs,
  config,
  lib,
  # username,
  ...
}: let
  cfg = config.custom.greetd;
  username = "jr";
in {
  options.custom.greetd = {
    enable = lib.mkEnableOption "Enable greetd Module";
  };

  config = lib.mkIf cfg.enable {
    # Without this it will hang for a minute and a half
    systemd.network.wait-online.enable = false;
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam the screen
      TTYReset = true; # Without these bootlogs spam the screen
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = username;
          # command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-user-session --time --cmd --theme \"container=black;input=lightBlue;prompt=green;greet=magenta;border=blue\" Hyprland";
          command = "${pkgs.tuigreet}/bin/tuigreet --remember --remember-user-session --time --theme 'container=black;input=lightBlue;prompt=green;greet=magenta;border=blue' --cmd sway";
        };
      };
    };
  };
}
