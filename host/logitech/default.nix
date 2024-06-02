{ pkgs, ... }:
let logiops = pkgs.logiops;
in {

  # TODO: wait for proper support to be merged (#287399, #167388)
  environment.systemPackages = [ logiops ];

  systemd.services.logid = {
    description = "Unofficial HID++ Logitech configuration daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${logiops}/bin/logid";
    };
  };

  environment.etc."logid.cfg".text = ''
    devices: ({
      name: "MX Master 3S";

      dpi: 850;

      smartshift: { on: true; threshold: 20; default_threshold: 20};
      hiresscroll: { hires: true; invert: false; target: false; };
      thumbwheel: { divert: false; invert: true; };


      buttons: ();
    });
  '';

}
