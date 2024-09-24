{ pkgs, lib, ... }:
let
  autotrash = pkgs.python3Packages.autotrash;
in
{

  home.packages = [ autotrash ];

  systemd.user = {

    timers."autotrash" = {
      Unit.Description = "Delete old trash files daily";
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };

    services."autotrash" = {
      Unit.Description = "Delete trash files older than two weeks";
      Service = {
        Type = "oneshot";
        ExecStart = "'${lib.getExe autotrash}' --days=17 --trash-mounts --verbose";
      };
    };

  };
}
