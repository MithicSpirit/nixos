{ ... }: {

  services.tlp.enable = true;
  services.tlp.settings = {
    SOUND_POWER_SAVE_ON_AC = 0;
    SOUND_POWER_SAVE_ON_BAT = 1;

    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
    START_CHARGE_THRESH_BAT1 = 75;
    STOP_CHARGE_THRESH_BAT1 = 80;

    RADEOM_DPM_PERF_LEVEL_ON_AC = "high";
    RADEOM_DPM_PERF_LEVEL_ON_BAT = "low";
    RADEOM_DPM_STATE_ON_AC = "performance";
    RADEOM_DPM_STATE_ON_BAT = "battery";

    PLATFORM_PROFILE_ON_AC = "performance";
    PLATFORM_PROFILE_ON_BAT = "low-power";

    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_BOOST_ON_AC = 1;
    CPU_BOOST_ON_BAT = 0;
  };

  services.power-profiles-daemon.enable = false; # incompatible

}
