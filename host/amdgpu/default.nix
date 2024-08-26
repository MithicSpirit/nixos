{ pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.lact # TODO: consider corectrl
    pkgs.radeontop
  ];

  systemd.packages = [ pkgs.lact ];
  systemd.services."lactd" = {
    name = "lactd.service";
    wantedBy = [ "multi-user.target" ];
  };

}
