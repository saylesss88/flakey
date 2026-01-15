{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.thunar;
in {
  options.custom.thunar = {
    enable = lib.mkEnableOption "Enable thunar module";
  };
  config = lib.mkIf cfg.enable {
    programs = {
      thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
    };
    services.gvfs.enable = true;
    services.tumbler.enable = true;
  };
}
