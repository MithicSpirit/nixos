{ pkgs, ... }:
let toml = (pkgs.formats.toml { }).generate;
in {

  home.packages = with pkgs; [
    python3
    python3Packages.ipython
    ruff
    mypy
    basedpyright
  ];

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
        "CPY001"
        "ERA001"
        "TD"
        "FA"
        "PLW1514"
      ];
    };
  };

}
