{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    # Optional: Use a custom package with extra features (e.g., experimental)
    # package = pkgs.waybar.override { pulseSupport = true; };

    systemd.enable = true; # Enables systemd integration (recommended)

    style = ''
      * {
        font-family: JetBrainsMono Nerd Font, sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: #1e1e2e;
        color: #cdd6f4;
        border-bottom: 2px solid #89b4fa;
      }

      #workspaces button {
        padding: 0 8px;
        color: #cdd6f4;
      }

      #workspaces button.focused {
        background: #89b4fa;
        color: #1e1e2e;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 10px;
        margin: 4px 2px;
      }

      #battery.warning {
        color: #f38ba8;
      }

      #battery.critical {
        color: #f38ba8;
        animation: blink 1s infinite;
      }

      @keyframes blink {
        to { background-color: #f38ba8; color: #1e1e2e; }
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["sway/workspaces" "sway/mode"];
        modules-center = ["sway/window"];
        modules-right = ["pulseaudio" "network" "cpu" "memory" "battery" "clock" "tray"];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
            urgent = "";
            focused = "";
            default = "";
          };
        };

        "sway/mode" = {
          format = ''<span style="italic">{}</span>'';
        };

        "sway/window" = {
          format = "{}";
          max-length = 50;
        };

        clock = {
          format = "{:%H:%M}";
          tooltip-format = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };

        memory = {
          format = "{}% ";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
        };

        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "Muted ";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        tray = {
          spacing = 8;
        };
      };
    };
  };

  # Optional: Start Waybar automatically with Sway
  # wayland.windowManager.sway.config.startup = [
  #   {command = "${config.programs.waybar.package}/bin/waybar";}
  # ];
}
