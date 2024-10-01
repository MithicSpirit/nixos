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
      };
    };

    environment.etc."gamemode.ini".source = lib.mkForce (
      settingsFormat.generate "gamemode.ini" config.programs.gamemode.settings'
    );
  };

}
