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
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 30;
          speedCurve = [
            {
              temp = 40;
              speed = 0;
            }
            {
              temp = 66;
              speed = 10;
            }
            {
              temp = 72;
              speed = 25;
            }
            {
              temp = 84;
              speed = 85;
            }
            {
              temp = 90;
              speed = 100;
            }
          ];
        };

        "slow" = {
          fanSpeedUpdateFrequency = 5;
          movingAverageInterval = 45;
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
              speed = 25;
            }
            {
              temp = 86;
              speed = 85;
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
