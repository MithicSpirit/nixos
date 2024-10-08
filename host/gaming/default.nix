{
  pkgs,
  lib,
  config,
  ...
}:
let
  settingsFormat = pkgs.formats.ini { listsAsDuplicateKeys = true; };
in
{

  options = {
    programs.gamemode.settings' = lib.mkOption {
      type = settingsFormat.type;
      default = { };
    };
  };

  config = {
    # TODO: mangohud
    environment.systemPackages = with pkgs; [
      path-of-building
      protonup-qt
    ];

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings' = {
        gpu = {
          apply_gpu_optimisations = "no";
          amd_performance_level = "high";
        };
        filter = {
          blacklist = [
            "/usr/bin/env"
            "${lib.getExe pkgs.bash}"
            "${lib.getExe' pkgs.bash "sh"}"
            "/usr/bin/bash"
            "/usr/bin/sh"
            "/bin/bash"
            "/bin/sh"
          ];
        };
      };
    };

    environment.etc."gamemode.ini".source = lib.mkForce (
      settingsFormat.generate "gamemode.ini" config.programs.gamemode.settings'
    );

    programs.gamescope = {
      enable = true;
      capSysNice = true;
      env = {
        "DRI_PRIME" = "1";
      };
    };
  };

}
