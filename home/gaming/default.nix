{ pkgs, ... }: {

  programs.mangohud = {
    enable = true;
    settings = { };
  };
  xdg.configFile."MangoHud/MangoHud.conf" = {
    enable = true;
    executable = false;
    source = ./MangoHud.conf;
  };

  xdg.configFile."gamemode.ini" = {
    enable = true;
    text = let
      notify-send = "${pkgs.libnotify}/bin/notify-send";
      # ini
    in ''
      [general]
      desiredgov = performance
      softrealtime = auto
      inhibit_screensaver = 0
      disable_splitlock = 1

      [cpu]
      pin_cores = 1

      [custom]
      start = ${notify-send} -et 5000 -a "GameMode" "Started"
      end = ${notify-send} -et 5000 -a "GameMode" "Stopped"
      script_timeout = 2
    '';
  };

}
