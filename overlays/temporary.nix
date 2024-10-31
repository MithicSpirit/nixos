final: prev: {

  sway-unwrapped =
    (prev.sway-unwrapped.override { wlroots = final.wlroots_0_18; }).overrideAttrs
      (
        finalAttrs: prevAttrs: {
          version = "1.10";
          src = prevAttrs.src.override {
            hash = "sha256-PzeU/niUdqI6sf2TCG19G2vNgAZJE5JCyoTwtO9uFTk=";
          };
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
