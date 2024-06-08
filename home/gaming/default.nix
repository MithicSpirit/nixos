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
    text = let notify-send = "${pkgs.libnotify}/bin/notify-send";
    in ''
      [general]
      desiredgov = performance
      softrealtime = auto
      inhibit_screensaver = no
      disable_splitlock = yes

      [cpu]
      pin_cores = yes

      [custom]
      start = ${notify-send} -et 5000 -a "GameMode" "Started"
      end = ${notify-send} -et 5000 -a "GameMode" "Stopped"
      script_timeout = 2
    '';
  };

}
