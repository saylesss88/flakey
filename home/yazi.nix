{
  config,
  lib,
  pkgs,
  # inputs,
  ...
}: {
  options.custom.yazi.enable = lib.mkEnableOption "Enable Yazi file manager module";

  config = lib.mkIf config.custom.yazi.enable {
    programs.yazi = {
      # package = inputs.yazi.packages.${pkgs.system}.yazi;
      enable = true;
      shellWrapperName = "y";
      settings = {
        mgr = {
          show_hidden = false;
          sort_dir_first = true;
          sort_by = "mtime";
          sort_reverse = true;
          linemode = "size";
          editor = "hx";
        };
        preview = {
          max_width = 1920;
          max_height = 1080;
        };
      };
      plugins = {
        inherit (pkgs.yaziPlugins) chmod;
        inherit (pkgs.yaziPlugins) full-border;
        inherit (pkgs.yaziPlugins) lazygit;
        inherit (pkgs.yaziPlugins) mediainfo;
        inherit (pkgs.yaziPlugins) no-status;
        inherit (pkgs.yaziPlugins) ouch;
        inherit (pkgs.yaziPlugins) restore;
        inherit (pkgs.yaziPlugins) smart-enter;
        inherit (pkgs.yaziPlugins) toggle-pane;
        inherit (pkgs.yaziPlugins) starship;
        inherit (pkgs.yaziPlugins) vcs-files;
      };

      initLua = ''
        require("full-border"):setup()
        require("starship"):setup()
      '';

      keymap.mgr.prepend_keymap = [
        {
          on = "t";
          run = "plugin toggle-pane min-preview";
          desc = "Switch the preview pane between hidden and shown";
        }
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = [
            "g"
            "c"
          ];
          run = "plugin vcs-files";
          desc = "Show Git file changes";
        }
        {
          on = [
            "g"
            "i"
          ];
          run = "plugin lazygit";
          desc = "run lazygit";
        }
      ];
    };
  };
}
