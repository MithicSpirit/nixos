{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  autoPatchelfHook,
  nodejs,
  electron,
  libX11,
  libXrandr,
  libXtst,
  libXt,
}:
let
  name = "exiled-exchange-2";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "Kvan7";
    repo = name;
    rev = "v${version}";
    hash = "sha256-ZtyUhsqRE8qw0BFxSMEQDdtEmK4Vj2gYgkU2mBQb3Ls=";
  };

  renderer = buildNpmPackage {
    inherit nodejs src version;
    pname = "exiled-exchange2-renderer";
    npmDepsHash = "sha256-pUhRTb9iUuqCrB40Pb2eV3dOzESVnH6vc135VFFEelk=";

    prePatch = "cd renderer";
    preBuild = "npm run make-index-files";
    installPhase = ''
      mkdir -p $out
      cp -rf public/* $out
      cp -rf dist/* $out
    '';
  };
in
buildNpmPackage {
  inherit nodejs src version;

  pname = "exiled-exchange2";

  npmDepsHash = "sha256-q2jbXyyJ4NPieK7m3baUYnDgNbKVcEHFLhTGd5ueRsk=";

  nativeBuildInputs = [
    autoPatchelfHook
    nodejs.python.pkgs.distutils
  ];

  buildInputs = [
    electron
    stdenv.cc.cc.lib
    libX11
    libXrandr
    libXtst
    libXt
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_OVERRIDE_DIST_PATH = electron.dist;
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  prePatch = "cd main";

  postInstall = ''
    ln -s ${renderer}/* $out/lib/node_modules/${name}/dist/
    makeWrapper ${lib.getExe electron} $out/bin/${name} \
      --add-flags $out/lib/node_modules/${name}/dist/main.js \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  meta = with lib; {
    homepage = "https://kvan7.github.io/Exiled-Exchange-2/";
    downloadPage = "https://github.com/Kvan7/Exiled-Exchange-2/releases";
    description = "Path of Exile 2 trading app for price checking";
    mainProgram = name;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.mithicspirit ];
  };
}
