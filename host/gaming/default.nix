{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    programs.gamemode = {
      scripts = {
        start = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Custom script executed when gamemode starts. Corresponds to
            `programs.gamemode.settings.custom.start`.
          '';
        };
        end = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            Custom script executed when gamemode ends. Corresponds to
            `programs.gamemode.settings.custom.end`.
          '';
        };
      };
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
      settings = {
        gpu = {
          apply_gpu_optimisations = "no";
          amd_performance_level = "high";
        };
        custom =
          let
            scripts = config.programs.gamemode.scripts;
            mkScript = name: contents: lib.getExe (pkgs.writers.writeBashBin name contents);
          in
          {
            start = mkScript "gamemode-start.sh" scripts.start;
            end = mkScript "gamemode-end.sh" scripts.end;
          };
      };
    };
  };

}
