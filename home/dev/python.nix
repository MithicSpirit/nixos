{ pkgs, lib, ... }:
let
  toml = (pkgs.formats.toml { }).generate;
  py = pkgs.python3.withPackages (
    p: with p; [
      numpy
      scipy
      sympy
      matplotlib
      ipython
      ruff
      uv
      mypy
    ]
  );
in
{

  home.packages = (
    with pkgs;
    [
      (lib.hiPrio py)
      ty
      basedpyright
    ]
  );

  home.sessionVariables = {
    UV_PYTHON_PREFERENCE = "only-system";
    UV_PYTHON = "${py}";
    UV_PYTHON_INSTALL_BIN = "0";
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
