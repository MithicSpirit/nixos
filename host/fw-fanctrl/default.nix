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
          fanSpeedUpdateFrequency = 60;
          movingAverageInterval = 1;
          speedCurve = [
            {
              temp = 0;
              speed = 100;
            }
          ];
        };

        "fast" = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 15;
          speedCurve = [
            {
              temp = 20;
              speed = 0;
            }
            {
              temp = 40;
              speed = 10;
            }
            {
              temp = 45;
              speed = 20;
            }
            {
              temp = 75;
              speed = 80;
            }
            {
              temp = 90;
              speed = 100;
            }
          ];
        };

        "medium" = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 20;
          speedCurve = [
            {
              temp = 40;
              speed = 0;
            }
            {
              temp = 62;
              speed = 10;
            }
            {
              temp = 69;
              speed = 20;
            }
            {
              temp = 83;
              speed = 80;
            }
            {
              temp = 90;
              speed = 100;
            }
          ];
        };

        "slow" = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 30;
          speedCurve = [
            {
              temp = 60;
              speed = 0;
            }
            {
              temp = 74;
              speed = 10;
            }
            {
              temp = 78;
              speed = 20;
            }
            {
              temp = 86;
              speed = 80;
            }
            {
              temp = 90;
              speed = 100;
            }
          ];
        };

        "sloth" = {
          fanSpeedUpdateFrequency = 1;
          movingAverageInterval = 10;
          speedCurve = [
            {
              temp = 80;
              speed = 0;
            }
            {
              temp = 85;
              speed = 10;
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
