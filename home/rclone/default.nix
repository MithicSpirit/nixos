{
  pkgs,
  config,
  lib,
  ...
}:
{

  home.packages = [ pkgs.rclone ];
  systemd.user =
    let
      execPath = "${config.xdg.userDirs.documents}/school/rclone-sync";
    in
    {
      timers."rclone-school" = {
        Unit = {
          Description = "Resynchronize school directory with rsync often";
          ConditionPathExists = execPath;
        };
        Timer = {
          OnUnitActiveSec = "15m";
          OnCalendar = "*-*-* *:00/15:00";
          AccuracySec = "1m";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };

      services."rclone-school" = {
        Unit = {
          Description = "Resynchronize school directory with rsync using standard script";
          ConditionPathExists = execPath;
          Wants = "network-online.target";
          After = "network-online.target";
        };
        Service = {
          Type = "oneshot";
          ExecStartPre =
            let
              ping = lib.getExe' pkgs.iputils "ping";
              sleep = lib.getExe' pkgs.coreutils "sleep";
              waitping = pkgs.writeShellScript "waitping" ''
                while ! ${ping} -q4c1 -W1 example.com
                do ${sleep} 1
                done
              '';
            in
            "${waitping}";
          TimeoutStartSec = 60;
          ExecStart = "'${config.xdg.userDirs.documents}/school/rclone-sync'";
        };
      };
    };

}
