{
  pkgs,
  lib,
  config,
  ...
}: {
  services.tlp.enable = false; # incompatible

  services.tuned = {
    enable = true;
    settings = {
      dynamic_tuning = true;
      sleep_interval = 5;
      update_interval = 30;
    };

    ppdSupport = true;
  };
  environment.etc."tuned/ppd.conf".source =
    lib.mkForce
    ((pkgs.formats.ini {}).generate "ppd.conf" {
      profiles = {
        balanced = "balanced";
        performance = "throughput-performance";
        power-saver = "laptop-ac-powersave";
      };
      battery = {
        balanced = "balanced-battery";
        performance = "balanced";
        power-saver = "laptop-battery-powersave";
      };
      main = {
        default = "balanced";
        battery_detection = true;
        sysfs_acpi_monitor = true;
      };
    });

  environment.systemPackages =
    lib.optional (config.services.tuned.ppdSupport)
    pkgs.power-profiles-daemon;

  systemd.services."auto-ppd" = {
    enable = config.services.tuned.enable && config.services.tuned.ppdSupport;
    description = "Automatically set PPD profile based on battery level";
    script = "${pkgs.auto-ppd.start-service}";
    serviceConfig = {
      Type = "simple";
      Restart = "always";
    };
    after = ["tuned-ppd.service"];
    wants = ["tuned-ppd.service"];
    wantedBy = ["multi-user.target"];
    restartTriggers = [config.services.tuned.package];
  };

  programs.gamemode.settings.custom = {
    start = ["'${pkgs.auto-ppd.set-profile}' performance"];
    end = ["'${pkgs.auto-ppd.set-profile}' auto"];
  };
}
