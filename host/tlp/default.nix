{
  pkgs,
  lib,
  config,
  ...
}:
{

  services.tlp.enable = true;
  # NOTE: low perf settings on AC are intended to be combined with gamemode when
  # better perf is needed.
  services.tlp.settings = {
    SOUND_POWER_SAVE_ON_AC = 0;
    SOUND_POWER_SAVE_ON_BAT = 1;

    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
    START_CHARGE_THRESH_BAT1 = 75;
    STOP_CHARGE_THRESH_BAT1 = 80;

    RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
    RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
    RADEON_DPM_STATE_ON_AC = "performance";
    RADEON_DPM_STATE_ON_BAT = "battery";

    PLATFORM_PROFILE_ON_AC = "balanced";
    PLATFORM_PROFILE_ON_BAT = "low-power";

    CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_AC = "power";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;
    CPU_HWP_DYN_BOOST_ON_AC = 1;
    CPU_HWP_DYN_BOOST_ON_BAT = 0;

    PCIE_ASPM_ON_AC = "default";
    PCIE_ASPM_ON_BAT = "powersupersave";
  };

  services.power-profiles-daemon.enable = false; # incompatible

  security.wrappers =
    let
      name = "tlp-start";
      systemctl = lib.getExe' config.systemd.package "systemctl";
      cmd-pkg =
        pkgs.writeCBin name # C
          ''
            #include <unistd.h>
            static char *argv[] = {"${systemctl}", "restart", "tlp.service"};
            int main() { execv(argv[0], argv); }
          '';
    in
    {
      ${name} = {
        source = lib.getExe cmd-pkg;
        owner = "root";
        group = "root";
        setuid = true;
        program = name;
      };
    };

  programs.gamemode.settings.custom = {
    end = [ "/run/wrappers/bin/tlp-start" ];
  };

}
