{
  pkgs,
  lib,
  ...
}:
{

  # TODO: mangohud
  environment.systemPackages = with pkgs; [
    path-of-building
    protonup-qt
  ];

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
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

  programs.gamescope = {
    enable = true;
    capSysNice = true;
    env = {
      "DRI_PRIME" = "1";
    };
  };

}
