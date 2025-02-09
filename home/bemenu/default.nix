{ config, ... }:
{

  programs.bemenu = {
    enable = true;
    settings = {
      ignorecase = true;
      wrap = true;
      fixed-height = true;
      scrollbar = "autohide";
      counter = true;
      no-cursor = true;

      grab = true;
      line-height = 28;
      ch = 20;
      cw = 2;
      monitor = "all";
      hp = 5;
      fn = " ${builtins.head config.fonts.fontconfig.defaultFonts.monospace} 12";

      tb = "#3b4252";
      tf = "#88c0d0";
      fb = "#2e3440";
      ff = "#eceff4";
      cb = "#2e3440";
      cf = "#d8dee9";
      nb = "#2e3440";
      nf = "#eceff4";
      hb = "#434c5e";
      hf = "#88c0d0";
      fbb = "#ff0000";
      fbf = "#00ff00";
      sb = "#3b4252";
      sf = "#eceff4";
      ab = "#2e3440";
      af = "#eceff4";
      scb = "#2e3440";
      scf = "#e5e9f0";
    };
  };
}
