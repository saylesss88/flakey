{
  lib,
  config,
  pkgs,
  # userVars ? {},
  #
  #
  #
  ...
}: let
  cfg = config.custom.jj;
in {
  options.custom.jj = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Jujutsu (jj) module";
    };

    userName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "saylesss88";
      description = "Jujutsu user name";
    };

    userEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "saylesss87@proton.me";
      description = "Jujutsu user email";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [meld]; # lazyjj
      description = "Additional Jujutsu-related packages to install";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {
        ui = {
          # default-command = "log-recent";
          default-command = [
            "status"
            "--no-pager"
          ];
          diff-editor = "gitpatch";
          # diff-editor = ["nvim" "-c" "DiffEditor" "$left" "$right" "$output"];
          # diff-formatter = ["meld" "$left" "$right"];
          merge-editor = ":builtin";
          conflict-marker-style = "diff";
        };
        revset-aliases = {
          "closest_bookmark(to)" = "heads(::to & bookmarks())";
          "immutable_heads()" = "builtin_immutable_heads() | remote_bookmarks()";
          # TODO fix the following alias
          # "default()" = "coalesce(trunk(),root())::present(@) | ancestors(visible_heads() & recent(), 2)";
          "recent()" = "committer_date(after:'1 month ago')";
          trunk = "main@origin";
        };
        template-aliases = {
          "format_short_change_id(id)" = "id.shortest()";
        };
        merge-tools.gitpatch = {
          program = "sh";
          edit-args = [
            "-c"
            ''
              set -eu
              rm -f "$right/JJ-INSTRUCTIONS"
              git -C "$left" init -q
              git -C "$left" add -A
              git -C "$left" commit -q -m baseline --allow-empty
              mv "$left/.git" "$right"
              git -C "$right" add --intent-to-add -A
              git -C "$right" add -p
              git -C "$right" diff-index --quiet --cached HEAD && { echo "No changes done, aborting split."; exit 1; }
              git -C "$right" commit -q -m split
              git -C "$right" restore . # undo changes in modified files
              git -C "$right" reset .   # undo --intent-to-add
              git -C "$right" clean -q -df # remove untracked files
            ''
          ];
        };
        aliases = {
          c = ["commit"];
          ci = [
            "commit"
            "--interactive"
          ];
          e = ["edit"];
          i = [
            "git"
            "init"
            "--colocate"
          ];
          tug = [
            "bookmark"
            "move"
            "--from"
            "closest_bookmark(@-)"
            "--to"
            "@-"
          ];
          mb = [
            "bookmark"
            "set"
            "-r"
            "@"
          ];
          log-recent = [
            "log"
            "-r"
            "default() & recent()"
          ];
          nb = [
            "bookmark"
            "create"
            "-r"
            "@-"
          ]; # new bookmark
          upmain = [
            "bookmark"
            "set"
            "main"
          ];
          squash-desc = [
            "squash"
            "::@"
            "-d"
            "@"
          ];
          rebase-main = [
            "rebase"
            "-d"
            "main"
          ];
          amend = [
            "describe"
            "-m"
          ];
          pushall = [
            "git"
            "push"
            "--all"
          ];
          push = [
            "git"
            "push"
            "--allow-new"
          ];
          pull = [
            "git"
            "fetch"
          ];
          dmain = [
            "diff"
            "-r"
            "main"
          ];
          l = [
            "log"
            "-T"
            "builtin_log_compact"
          ];
          lf = [
            "log"
            "-r"
            "all()"
          ];
          r = ["rebase"];
          s = ["squash"];
          si = [
            "squash"
            "--interactive"
          ];
          squash-push = [
            "squash"
            "::@"
            "-d"
            "@"
            "&&"
            "describe"
            "-m"
            "\"Update after squash\""
            "&&"
            "bookmark"
            "set"
            "main"
            "&&"
            "git"
            "push"
          ];
        };
        revsets = {
          # log = "main@origin";
          # log = "master@origin";
        };
      };
      description = "Jujutsu configuration settings";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = cfg.packages;

    programs.jujutsu = {
      enable = true;
      settings = lib.mergeAttrs cfg.settings {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
      };
    };
  };
}
