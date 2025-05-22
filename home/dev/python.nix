{ pkgs, ... }:
let
  toml = (pkgs.formats.toml { }).generate;
in
{

  home.packages = (
    with pkgs;
    [
      (python3.withPackages (
        p: with p; [
          numpy
          scipy
          sympy
          matplotlib
        ]
      ))
      python3Packages.ipython
      ruff
      ty
      uv
      mypy
      basedpyright
    ]
  );

  home.sessionVariables = {
    UV_PYTHON_PREFERENCE = "only-system";
    UV_PYTHON = "${pkgs.python3}";
  };

  xdg.configFile."ruff/ruff.toml".source = toml "ruff.toml" {
    line-length = 79;
    preview = true;
    lint = {
      select = [ "ALL" ];
      ignore = [
        "E203"
        "E266"
        "E741"
        "D10"
        "D203"
        "D213"
        "T20"
        "S603"
        "CPY001"
        "ERA001"
        "EXE003"
        "EXE005"
        "FA"
        "PLW1514"
        "TD"
        "ANN204"
      ];
    };
  };

}
