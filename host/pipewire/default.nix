{ pkgs, ... }:
{

  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;

    pulse.enable = true;
    jack.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    libpulseaudio
    pavucontrol
    pulsemixer
    helvum
  ];

}
