{...}: {
  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = ["*"];
      settings = {
        global = {
          disable_modifier_guard = 1; # prevent ctrl event on alt+click
        };
        main = {
          capslock = "esc";
          esc = "capslock";

          # undo default config
          rightcontrol = "rightcontrol";
          rightmeta = "rightmeta";
          rightshift = "rightshift";
          # lalt,lctrl,lmeta,lshift,ralt cannot be reset
        };
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
