{
  pkgs,
  lib,
  config,
  ...
}: let
  ini = (pkgs.formats.ini {listsAsDuplicateKeys = true;}).generate;

  add-cli-flags = pkg: flags:
    pkgs.runCommandLocal "${pkg.name}-wrapped"
    {
      inherit (pkg) meta;
      nativeBuildInputs = [pkgs.makeWrapper];
      propagatedBuildInputs = [pkg];
    }
    ''
      mkdir -p "$out/bin/"
      makeWrapper '${lib.getExe pkg}' $out/bin/'${pkg.meta.mainProgram}' \
        --add-flags '${flags}' \
        --inherit-argv0
    '';
in {
  home.packages = with pkgs; [
    # compatibility tool version management
    protonup-qt
    protonplus

    # path of exile
    rusty-path-of-building
    (add-cli-flags awakened-poe-trade "--no-overlay")
    (add-cli-flags exiled-exchange-2 "--no-overlay")

    # eve online
    pyfa
  ];

  programs.mangohud = {
    enable = true;
    settings = {};
  };
  xdg.configFile."MangoHud/MangoHud.conf" = {
    enable = true;
    executable = false;
    source = ./MangoHud.conf;
  };

  xdg.configFile."gamemode.ini".source = ini "gamemode.ini" {
    general = {
      desiredgov = "performance";
      igpu_desiredgov = "performance";
      igpu_power_threshold = 100000;
      desiredprof = "performance";
      inhibit_screensaver = 0;
      disable_splitlock = 1;
    };
    cpu.pin_cores = 1;
    custom = let
      notify-send = lib.getExe pkgs.libnotify;
    in {
      start = "${notify-send} -et 5000 -a 'GameMode' 'Started'";
      end = "${notify-send} -et 5000 -a 'GameMode' 'Stopped'";
      script_timeout = 2;
    };
  };
  systemd.user.services."gamemoded".Unit = {
    X-SwitchMethod = "restart";
    X-RestartTriggers = [
      config.xdg.configFile."gamemode.ini".source
    ];
  };

  home.sessionVariables."GAMEMODERUNEXEC" = "DRI_PRIME=1";
}
