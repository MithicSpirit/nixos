{ pkgs, lib, ... }:
let
  fw-fanctrl = lib.getExe pkgs.fw-fanctrl;
  json = (pkgs.formats.json { }).generate;
  conf = json "fw-fanctrl.json" {

    defaultStrategy = "medium";
    strategyOnDischarging = "lazy";
    strategies = {

      "lazy" = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
        criticalTemp = 100;
        speedCurve = [
          {
            temp = 50;
            speed = 15;
          }
          {
            temp = 65;
            speed = 25;
          }
          {
            temp = 70;
            speed = 35;
          }
          {
            temp = 75;
            speed = 50;
          }
          {
            temp = 85;
            speed = 100;
          }
        ];
      };

      "medium" = {
        fanSpeedUpdateFrequency = 5;
        movingAverageInterval = 30;
        criticalTemp = 95;
        speedCurve = [
          {
            temp = 40;
            speed = 15;
          }
          {
            temp = 60;
            speed = 30;
          }
          {
            temp = 70;
            speed = 40;
          }
          {
            temp = 75;
            speed = 80;
          }
          {
            temp = 85;
            speed = 100;
          }
        ];
      };

      "agile" = {
        fanSpeedUpdateFrequency = 3;
        movingAverageInterval = 15;
        criticalTemp = 90;
        speedCurve = [
          {
            temp = 40;
            speed = 15;
          }
          {
            temp = 60;
            speed = 30;
          }
          {
            temp = 70;
            speed = 40;
          }
          {
            temp = 75;
            speed = 80;
          }
          {
            temp = 85;
            speed = 100;
          }
        ];
      };

      "max" = {
        fanSpeedUpdateFrequency = 1;
        movingAverageInterval = 1;
        speedCurve = [
          {
            temp = 0;
            speed = 100;
          }
        ];
      };

    };

  };
in
{

  environment.systemPackages = [
    pkgs.fw-ectool
    pkgs.fw-fanctrl
  ];

  systemd.services."fw-fanctrl" = {
    enable = true;
    description = "Framework Fan Controller";
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart = "${fw-fanctrl} run --config ${conf} --silent";
      ExecStopPost = "${lib.getExe pkgs.fw-ectool} autofanctrl";
      SyslogLevel = "debug";
    };
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    restartTriggers = [ conf ];
  };

  environment.etc."systemd/system-sleep/fw-fanctrl-suspend".source =
    pkgs.writeShellScript "fw-fanctrl-suspend" ''
      case "$1" in
        pre) '${fw-fanctrl}' pause ;;
        post) '${fw-fanctrl}' resume ;;
      esac
    '';

  programs.gamemode.settings.custom = {
    start = [ "'${fw-fanctrl}' use agile" ];
    end = [ "'${fw-fanctrl}' reset" ];
  };
}
