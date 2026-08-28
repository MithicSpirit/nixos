{
  lib,
  stdenvNoCC,
  zig,
  writeShellScript,
  power-profiles-daemon,
  netcat,
  auto-ppd, # self
  socket ? "/run/auto-ppd.socket",
}:
stdenvNoCC.mkDerivation {
  name = "auto-ppd";

  src = ./auto-ppd.zig;

  nativeBuildInputs = [zig];

  dontUnpack = true;
  dontUseZigBuild = true;
  dontUseZigTest = true;
  dontUseZigInstall = true;

  buildPhase = ''
    runHook preBuild
    TERM=dumb zig build-exe -j1 -O ReleaseSafe -femit-bin="$out" "$src"
    runHook postBuild
  '';

  passthru = {
    start-service = writeShellScript "auto-ppd-start" ''
      unset bat
      bat=(/sys/class/power_supply/BAT*/capacity)
      bat="''${bat[0]}"
      exec '${auto-ppd}' '${lib.getExe' power-profiles-daemon "powerprofilesctl"}' "$bat" '${socket}'
    '';
    set-profile = writeShellScript "auto-ppd-override" ''
      printf '%s\n' "$1" | '${lib.getExe netcat}' -NU '${socket}'
    '';
  };

  meta = with lib; {
    description = "Simple zig program to automate power-profiles-daemon";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [mithicspirit];
  };
}
