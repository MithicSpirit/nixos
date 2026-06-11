{
  pkgs,
  lib,
  ...
}: {
  # TODO: fix scrolling with bolt
  # - hiresscroll.hires: true
  # - remove quirks and hwdb if possible
  # see https://gitlab.freedesktop.org/libinput/libinput/-/issues/1021

  environment.systemPackages = [pkgs.piper];

  services.ratbagd.enable = true;

  services.logiops = {
    enable = true;
    config.devices = [
      {
        name = "MX Master 3S";
        dpi = 500;
        smartshift = {
          on = true;
          threshold = 20;
          default_threshold = 20;
        };
        hiresscroll = {
          hires = false;
          invert = false;
          target = false;
        };
        thumbwheel = {
          divert = false;
          invert = true;
        };
        buttons = [
          {
            cid = "0xc3";
            action = {
              type = "Keypress";
              keys = ["KEY_MICMUTE"];
            };
          }
        ];
      }
    ];
  };

  systemd.services.logid = {
    wantedBy = ["multi-user.target"];
    preStart = "${lib.getExe' pkgs.kmod "modprobe"} hid_logitech_hidpp";
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech MX Master 3S]
    MatchVendor=0x046D
    MatchProduct=0xB034
    ModelInvertHorizontalScrolling=1
    ModelScrollOnMiddleClick=1
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;

    [Logitech MX Master 3S USB Receiver]
    MatchVendor=0x046D
    MatchProduct=0xC548
    ModelInvertHorizontalScrolling=1
    ModelScrollOnMiddleClick=1
    AttrEventCode=+REL_WHEEL_HI_RES;+REL_HWHEEL_HI_RES;
  '';
}
