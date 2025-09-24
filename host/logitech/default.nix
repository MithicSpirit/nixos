{
  pkgs,
  lib,
  config,
  ...
}:
let
  logiops = pkgs.logiops;
in
{

  # TODO: fix scrolling with bolt
  # - hiresscroll.hires: true
  # - remove quirks and hwdb if possible
  # see https://gitlab.freedesktop.org/libinput/libinput/-/issues/1021

  # TODO: wait for proper support to be merged (#287399, #167388)

  environment.systemPackages = [ logiops ];

  systemd = {
    packages = [ logiops ];
    services.logid = {
      wantedBy = [ "multi-user.target" ];
      preStart = "${lib.getExe' pkgs.kmod "modprobe"} hid_logitech_hidpp";
      restartTriggers = [ config.environment.etc."logid.cfg".source ];
    };
  };

  environment.etc."logid.cfg".text = ''
    devices: ({
      name: "MX Master 3S";

      dpi: 500;

      smartshift: { on: true; threshold: 20; default_threshold: 20};
      hiresscroll: { hires: false; invert: false; target: false; };
      thumbwheel: { divert: false; invert: true; };


      buttons: ();
    });
  '';

  services.udev.extraHwdb = # hwdb
    ''
      mouse:usb:*:name:Logitech USB Receiver Mouse:*
      mouse:bluetooth:*:name:Logitech MX Master 3S:*
        MOUSE_DPI=1000@142
        MOUSE_WHEEL_CLICK_ANGLE=1
        MOUSE_WHEEL_CLICK_COUNT=360
        MOUSE_WHEEL_CLICK_ANGLE_HORIZONTAL=26
        MOUSE_WHEEL_CLICK_COUNT_HORIZONTAL=14
    '';

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech MX Master 3S]
    MatchVendor=0x046D
    MatchProduct=0xB034
    ModelInvertHorizontalScrolling=1
    ModelLogitechMXMaster3=1
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;

    [Logitech MX Master 3S USB Receiver]
    MatchVendor=0x046D
    MatchProduct=0xC548
    ModelInvertHorizontalScrolling=1
    ModelLogitechMXMaster3=1
    AttrEventCode=+REL_WHEEL_HI_RES;+REL_HWHEEL_HI_RES;
  '';

}
