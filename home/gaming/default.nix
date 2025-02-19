{
  pkgs,
  lib,
  config,
  ...
}:
let
  ini = (pkgs.formats.ini { listsAsDuplicateKeys = true; }).generate;
in
{

  home.packages = with pkgs; [
    path-of-building
    exiled-exchange-2
    protonup-qt
  ];

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
      igpu_desiredgov = "performance";
      igpu_power_threshold = 100000;
      desiredprof = "performance";
      inhibit_screensaver = 0;
      disable_splitlock = 1;
    };
    cpu.pin_cores = 1;
    custom =
      let
        notify-send = lib.getExe pkgs.libnotify;
      in
      {
        start = "${notify-send} -et 5000 -a 'GameMode' 'Started'";
        end = "${notify-send} -et 5000 -a 'GameMode' 'Stopped'";
        script_timeout = 2;
      };
  };
  systemd.user.services."gamemoded".Unit = {
    X-SwitchMethod = "restart";
    X-RestartTriggers = [
      config.xdg.configFile."gamemode.ini".source
    ];
  };

  home.sessionVariables."GAMEMODERUNEXEC" = "DRI_PRIME=1";

}
