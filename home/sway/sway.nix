{
  pkgs,
  inputs,
  ...
}: let
  mod = "Mod4";
in {
  imports = [./keybinds.nix ./fuzzel.nix];

  # jr.opt.services.kanshi.enable = true; # Enables the kanshi service

  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    config = rec {
      modifier = mod;
      terminal = "${pkgs.ghostty}/bin/ghostty";
      # startup = [{command = "firefox";}];
      floating.border = 1;
      window.border = 1;
      gaps = {
        inner = 5;
        smartGaps = true;
      };
    };
    extraConfig = ''
      xwayland disable
      seat * xcursor_theme bibata_modern_ice 26
      set $mod Mod4

      # bindsym ${mod}+Shift+minus move scratchpad
      # bindsym ${mod}+minus scratchpad show

      # exec waybar &
      exec nm-applet --indicator
      exec wl-paste --type text --watch cliphist store
      exec wl-paste --type image --watch cliphist store

      output * {
        # bg /home/jr/Pictures/Wallpapers/Wall.png fill
        mode 1920x1080@100Hz
        scale 1
        pos 0 0
      }

      # output HDMI-A-1 {
      #   mode 1920x1080@100Hz
      #   scale 1
      #   pos 2560 0
      # }

      input * {
        repeat_delay 300
        repeat_rate 50
        xkb_options caps:escape
      }
      # SwayFx settings
      # shadows enable
      # blur_radius 7
      # blur_passes 4
      exec ${pkgs.wpaperd}/bin/wpaperd -d
    '';
  };

  services = {
    network-manager-applet.enable = true;
    cliphist.enable = true;
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  home.packages = with pkgs; [
    grim
    mako
    wl-clipboard
    rofi
    slurp
    grim
    wpaperd
    pavucontrol
    swappy
    swaylock-effects
    yad
    findutils
    wtype
  ];
  # Place Files Inside Home Directory
  home.file = {
    "Pictures/Wallpapers" = {
      source = inputs.wallpapers;
      recursive = true;
    };
    ".face.icon".source = ./face.png;
    ".config/face.png".source = ./face.png;
    ".config/swappy/config".text = ''
      [Default]
      save_dir=/home/jr/Pictures/Screenshots
      save_filename_format=swappy-%Y%m%d-%H%M%S.png
      show_panel=false
      line_size=5
      text_size=20
      text_font=Ubuntu
      paint_mode=brush
      early_exit=true
      fill_shape=false
    '';
    ".config/wpaperd/config.toml".text = ''
      [default]
       path = "/home/jr/Pictures/Wallpapers/"
       duration = "30m"
       transition-time = 600
    '';
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [pkgs.xdg-desktop-portal-gtk]; # "Installs" GTK portal (replaces wlr for most uses)
  #   config.common.default = ["gtk"];
  # };
}
