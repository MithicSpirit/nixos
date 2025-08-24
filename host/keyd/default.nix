{ ... }:
{

  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "esc";
        esc = "capslock";

        # undo default config
        leftalt = "leftalt";
        leftcontrol = "leftcontrol";
        leftmeta = "leftmeta";
        leftshift = "leftshift";
        rightalt = "rightalt";
        rightcontrol = "rightcontrol";
        rightmeta = "rightmeta";
        rightshift = "rightshift";
      };
    };
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [keyd Keyboard]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';

}
