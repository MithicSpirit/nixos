{ config, lib, ... }:
{

  services.power-profiles-daemon.enable = true;
  services.tlp.enable = false; # incompatible

  programs.gamemode.settings.custom =
    let
      ppd = config.services.power-profiles-daemon.package;
      ppctl = lib.getExe' ppd "powerprofilesctl";
    in
    {
      start = [ "${ppctl} set performance" ];
      end = [ "${ppctl} set power-saver" ];
    };

}
