final: prev: {

  tlp = prev.tlp.overrideAttrs (old: {
    postPatch = ''
      substituteInPlace Makefile --replace-fail ' ?= /usr/' ' ?= /'
    '';
    makeFlags = [
      "TLP_NO_INIT=1"
      "TLP_WITH_ELOGIND=0"
      "TLP_WITH_SYSTEMD=1"

      "DESTDIR=${placeholder "out"}"
    ];
  });

  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "1.10-rc4";
      src = prevAttrs.src.override {
        hash = "sha256-O8zpOZ7ttPQv8xoH3ytwj2x/evw3+ghHsELEzVh19Q8=";
      };

      buildInputs =
        with final;
        [
          libGL
          wayland
          libxkbcommon
          pcre2
          json_c
          libevdev
          pango
          cairo
          libinput
          gdk-pixbuf
          librsvg
          wayland-protocols
          libdrm
          (final.wlroots_0_18.override { inherit (finalAttrs) enableXWayland; })
        ]
        ++ lib.optionals finalAttrs.enableXWayland [
          xorg.xcbutilwm
        ];

      mesonFlags =
        let
          inherit (final.lib.strings) mesonEnable mesonOption;
          sd-bus-provider = if finalAttrs.systemdSupport then "libsystemd" else "basu";
        in
        [
          (mesonOption "sd-bus-provider" sd-bus-provider)
          (mesonEnable "tray" finalAttrs.trayEnabled)
        ];
    }
  );

}
