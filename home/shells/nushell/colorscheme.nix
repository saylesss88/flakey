{
  colorscheme,
  xargb ? false,
  alpha ? "ff",
  ...
}: let
  convert-color = col: let
    col' = builtins.substring 1 6 col; # Remove leading #
  in
    if xargb
    then "0x${alpha}${col'}"
    else if alpha != "ff"
    then "${col}#${alpha}"
    else col;
  default-set =
    if (colorscheme == "tokyonight_night")
    then {
      black = "#111726";
      white = "#a3aed2";
      grey = "#394260";
      dark_grey = "#212736";
      blue = "#769ff0";
      yellow = "#e0af68";
      warn = "#ff4b14";
      red = "#f7768e";
      green = "#9ece6a";
      purple = "#bb9af7";
      light_red = "#ff899d";
      light_yellow = "#faba4a";
      light_blue = "#a4daff";
      light_green = "#0dcf6f";
      cyan = "#7dcfff";
      magenta = "#c7a9ff";
    }
    else {};
in
  default-set
  |> builtins.attrNames
  |> builtins.map (key: {
    name = key;
    value = convert-color default-set.${key};
  })
  |> builtins.listToAttrs
