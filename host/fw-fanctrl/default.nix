{ inputs, ... }:
{

  imports = [ inputs.fw-fanctrl.nixosModules.default ];
  programs.fw-fanctrl = {

    enable = true;
    config = {

      defaultStrategy = "medium";
      strategyOnDischarging = "slow";
      strategies = {

        "hyper" = {
          fanSpeedUpdateFrequency = 1;
          movingAverageInterval = 4;
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
          movingAverageInterval = 16;
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

        "medium" = {
          fanSpeedUpdateFrequency = 1;
          movingAverageInterval = 24;
          criticalTemp = 90;
          speedCurve = [
            {
              temp = 25;
              speed = 0;
            }
            {
              temp = 55;
              speed = 10;
            }
            {
              temp = 65;
              speed = 20;
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

        "slow" = {
          fanSpeedUpdateFrequency = 1;
          movingAverageInterval = 40;
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

  };

}
