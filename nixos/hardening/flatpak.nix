{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.flatpaks.nixosModules.default
  ];
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      # "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    packages = [
      "flathub:app/org.mozilla.firefox//stable"
      "flathub:app/com.bitwarden.desktop//stable"
      # "flathub-beta:app/org.kde.kdenlive/x86_64/stable"
      # ":${./foobar.flatpak}"
      "flathub:/root/testflatpak.flatpakref"
    ];
    overrides = {
      # note: "global" is a flatpak thing
      # if you ever ran "flatpak override" without specifying a ref you will know
      "global".Context = {
        filesystems = [
          "home"
        ];
        sockets = [
          "!wayland"
          "!fallback-x11"
        ];
      };
      "org.mozilla.Firefox" = {
        Environment = {
          "MOZ_ENABLE_WAYLAND" = 1;
        };
        Context.sockets = [
          "!wayland"
          "!fallback-x11"
          # "x11"
        ];
      };
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = ["gtk"];
    };
  };
}
