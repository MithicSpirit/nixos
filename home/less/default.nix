{ config, ... }:
{

  programs.less.enable = true;

  home.sessionVariables = {
    "LESS" = "--RAW-CONTROL-CHARS --use-color -i -Dd+m-\\$-Dk+r-\\$-Ds+y-\\$-Du+b-\\$";
    "LESSHISTFILE" = "${config.xdg.cacheHome}/less/history";
    "LESSUTFCHARDEF" = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p";
  };

}
