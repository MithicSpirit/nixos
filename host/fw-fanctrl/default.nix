{ pkgs, ... }:
let
  fw-fanctrl = pkgs.lib.getExe pkgs.fw-fanctrl;
  json = (pkgs.formats.json { }).generate;
  config = json "fw-fanctrl.json" {

    defaultStrategy = "medium";
    strategyOnDischarging = "slow";
    strategies = {

      "hyper" = {
        fanSpeedUpdateFrequency = 1;
        movingAverageInterval = 5;
        criticalTemp = 80;
        speedCurve = [
          {
            temp = 0;
            speed = 10;
          }
          {
            temp = 15;
            speed = 15;
          }
          {
            temp = 30;
            speed = 35;
          }
          {
            temp = 45;
            speed = 60;
          }
          {
            temp = 60;
            speed = 100;
          }
        ];
      };

      "fast" = {
        fanSpeedUpdateFrequency = 1;
        movingAverageInterval = 10;
        criticalTemp = 85;
        speedCurve = [
          {
            temp = 10;
            speed = 0;
          }
          {
            temp = 45;
            speed = 10;
          }
          {
            temp = 60;
            speed = 25;
          }
          {
            temp = 70;
            speed = 55;
          }
          {
            temp = 80;
            speed = 100;
          }
        ];
      };

      "medium" = {
        fanSpeedUpdateFrequency = 1;
        movingAverageInterval = 30;
        criticalTemp = 90;
        speedCurve = [
          {
            temp = 15;
            speed = 0;
          }
          {
            temp = 50;
            speed = 10;
          }
          {
            temp = 65;
            speed = 25;
          }
          {
            temp = 75;
            speed = 55;
          }
          {
            temp = 85;
            speed = 100;
          }
        ];
      };

      "slow" = {
        fanSpeedUpdateFrequency = 1;
        movingAverageInterval = 45;
        criticalTemp = 90;
        speedCurve = [
          {
            temp = 50;
            speed = 0;
          }
          {
            temp = 70;
            speed = 10;
          }
          {
            temp = 76;
            speed = 20;
          }
          {
            temp = 84;
            speed = 55;
          }
          {
            temp = 90;
            speed = 100;
          }
        ];
      };

      "sloth" = {
        fanSpeedUpdateFrequency = 1;
        movingAverageInterval = 60;
        criticalTemp = 90;
        speedCurve = [
          {
            temp = 70;
            speed = 0;
          }
          {
            temp = 80;
            speed = 10;
          }
          {
            temp = 85;
            speed = 35;
          }
          {
            temp = 90;
            speed = 100;
          }
        ];
      };

    };

  };
in
{

  environment.systemPackages = [ pkgs.fw-fanctrl ];

  systemd.services."fw-fanctrl" = {
    enable = true;
    description = "Framework Fan Controller";
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart = "${fw-fanctrl} run --config ${config}";
      ExecStopPost = "${pkgs.lib.getExe pkgs.fw-ectool} autofanctrl";
      SyslogLevel = "debug";
    };
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    restartTriggers = [ config ];
  };

  environment.etc."systemd/system-sleep/fw-fanctrl-suspend".source = pkgs.writeShellScript "fw-fanctrl-suspend" ''
    #!/bin/sh
    case "$1" in
      pre) '${fw-fanctrl}' pause ;;
      post) '${fw-fanctrl}' resume ;;
    esac
  '';

  programs.gamemode.settings.custom = {
    start = "'${fw-fanctrl}' use fast";
    end = "'${fw-fanctrl}' reset";
  };
}
