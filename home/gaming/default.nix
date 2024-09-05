{ pkgs, ... }:
let
  ini = (pkgs.formats.ini { }).generate;
in
{

  programs.mangohud = {
    enable = true;
    settings = { };
  };
  xdg.configFile."MangoHud/MangoHud.conf" = {
    enable = true;
    executable = false;
    source = ./MangoHud.conf;
  };

  xdg.configFile."gamemode.ini".source = ini "gamemode.ini" {
    general = {
      desiredgov = "performance";
      igpu_desiredgov = "powersave";
      igpu_power_threshold = 0;
      softrealtime = "off";
      renice = 20;
      ioprio = 0;
      inhibit_screensaver = 0;
      disable_splitlock = 1;
    };
    cpu.pin_cores = 1;
    custom =
      let
        notify-send = "${pkgs.libnotify}/bin/notify-send";
      in
      {
        start = "${notify-send} -et 5000 -a 'GameMode' 'Started'";
        end = "${notify-send} -et 5000 -a 'GameMode' 'Stopped'";
        script_timeout = 2;
      };
  };

  home.sessionVariables."GAMEMODERUNEXEC" = "mangohud";

}
