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
      version = "1.10";
      src = prevAttrs.src.override {
        hash = "sha256-PzeU/niUdqI6sf2TCG19G2vNgAZJE5JCyoTwtO9uFTk=";
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
