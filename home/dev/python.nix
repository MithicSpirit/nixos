{
  pkgs,
  lib,
  ...
}: let
  py = pkgs.python3.withPackages (p:
    with p; [
      numpy
      scipy
      sympy
      pandas
      matplotlib
      seaborn
      ipython
      jupyter
    ]);
in {
  home.packages = [
    (lib.hiPrio py)
    pkgs.basedpyright
    pkgs.mypy
  ];

  programs.ruff = {
    enable = true;
    settings = {
      line-length = 79;
      preview = true;
      lint = {
        select = ["ALL"];
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
  };

  programs.uv = {
    enable = true;
    settings = {
      python-downloads = "manual";
    };
    python.prune = true;
    tool.prune = true;
  };

  programs.ty.enable = true;

  home.sessionVariables = {
    UV_PYTHON_INSTALL_BIN = "0";
  };
}
