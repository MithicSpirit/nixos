{ config, lib, ... }:
{

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        amd_performance_level = "high";
      };
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  boot.kernelModules =
    let
      kver = config.boot.kernelPackages.kernel.version;
    in
    {
      "ntsync" = lib.versionAtLeast kver "6.14";
    };

}
