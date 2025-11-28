{ pkgs, lib, config, ... }:
{

  # set default but allow imperative modification
  time.timeZone = lib.mkForce "US/Eastern";
  systemd.services.systemd-timedated.environment."NIXOS_STATIC_TIMEZONE" =
    lib.mkForce null;

  # requires imperative modification
  services.tzupdate = {
    enable = true;
    timer.enable = true;
  };
  systemd.services."tzupdate" = {
    preStart = "${pkgs.wait-for-internet}";
    script = ''
      timezone="$('${lib.getExe config.services.tzupdate.package}' --consensus --print-only)"
      if [[ -n "$timezone" ]]; then
        echo "Setting timezone to '$timezone'"
        timedatectl set-timezone "$timezone"
      fi
    '';
  };

}
