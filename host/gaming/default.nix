{ pkgs, ... }:
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
      general = {
        renice = 10;
        ioprio = 0;
      };
      gpu = {
        apply_gpu_optimisations = "no";
        amd_performance_level = "high";
      };
    };
  };

}
