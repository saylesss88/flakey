{
  lib,
  homeManagerModules,
  ...
}:
{
  home.username = "jr";
  home.homeDirectory = lib.mkDefault "/home/jr";
  home.stateVersion = "25.05";

  imports = [
    ../../home/sway
    homeManagerModules
  ];
  # programs.git.enable = true;
  custom = {
    magic.hm.enable = true;
    git.enable = false;
    gpg.enable = true;
    yazi.enable = true;
    helix.enable = true;
    jj.enable = true;
    # nh.enable = true;
  };
  programs.home-manager.enable = true;

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #   config.common.default = [ "gtk" ];
  # };
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
}
