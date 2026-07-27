{
  pkgs,
  lib,
  config,
  ...
}: let
  set-ppd = pkgs.writeCBin "set-ppd" (builtins.readFile ./set-ppd.c);
in {
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
    script = let
      auto-ppd = pkgs.writeShellScript "auto-ppd" ''
        unset bat current
        bat=(/sys/class/power_supply/BAT*/capacity)
        bat="''${bat[0]}"
        while :; do
          current="$(powerprofilesctl get)"
          case "$current" in
            'unknown'|'performance') ;;  # skip
            *) set-ppd "$bat" "$current" ;;
          esac
          inotifywait -qe modify -t 20 "$bat" || :
        done
      '';
    in "${auto-ppd}";
    path = with pkgs; [
      power-profiles-daemon
      inotify-tools
      set-ppd
    ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
    };
    after = ["tuned-ppd.service"];
    wants = ["tuned-ppd.service"];
    wantedBy = ["multi-user.target"];
  };

  programs.gamemode.settings.custom = let
    powerprofilesctl = lib.getExe pkgs.power-profiles-daemon;
  in {
    start = ["${powerprofilesctl} set performance"];
    end = let
      reset-ppd = pkgs.writeShellScript "reset-ppd" ''
        set -euo pipefail
        export PATH='${lib.makeBinPath [set-ppd pkgs.power-profiles-daemon]}'
        unset bat
        bat=(/sys/class/power_supply/BAT*/capacity)
        set-ppd "''${bat[0]}" || :
      '';
    in ["${reset-ppd}"];
  };
}
