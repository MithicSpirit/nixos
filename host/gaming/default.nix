{ ... }:
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
    env = {
      "DRI_PRIME" = "1";
    };
  };

}
