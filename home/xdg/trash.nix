{
  pkgs,
  lib,
  ...
}: {
  systemd.user = {
    timers."autotrash" = {
      Unit.Description = "Delete old trash files daily";
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install.WantedBy = ["timers.target"];
    };

    services."autotrash" = {
      Unit.Description = "Delete trash files older than two and a half weeks";
      Service = {
        Type = "oneshot";
        ExecStart = "'${lib.getExe pkgs.autotrash}' --days=17 --trash-mounts --verbose";
      };
    };
  };
}
