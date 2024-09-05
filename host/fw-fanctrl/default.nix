{ inputs, ... }:
{

  imports = [ inputs.fw-fanctrl.nixosModules.default ];
  programs.fw-fanctrl = {

    enable = true;
    config = {

      defaultStrategy = "medium";
      strategyOnDischarging = "slow";
      strategies = {

        "fast" = {
          fanSpeedUpdateFrequency = 60;
          movingAverageInterval = 1;
          speedCurve = [
            {
              temp = 0;
              speed = 100;
            }
          ];
        };

        "medium" = {
          fanSpeedUpdateFrequency = 4;
          movingAverageInterval = 20;
          speedCurve = [
            {
              temp = 35;
              speed = 0;
            }
            {
              temp = 40;
              speed = 10;
            }
            {
              temp = 60;
              speed = 10;
            }
            {
              temp = 80;
              speed = 50;
            }
            {
              temp = 90;
              speed = 100;
            }
          ];
        };

        "slow" = {
          fanSpeedUpdateFrequency = 6;
          movingAverageInterval = 40;
          speedCurve = [
            {
              temp = 50;
              speed = 0;
            }
            {
              temp = 60;
              speed = 10;
            }
            {
              temp = 70;
              speed = 10;
            }
            {
              temp = 80;
              speed = 40;
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
