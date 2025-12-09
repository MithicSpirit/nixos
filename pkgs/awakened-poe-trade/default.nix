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
  libxcb,
}:
let
  name = "awakened-poe-trade";
  version = "3.27.106";

  src = fetchFromGitHub {
    owner = "SnosMe";
    repo = name;
    rev = "v${version}";
    hash = "sha256-sP/IpTWkmjKmG+fCuRe0fr8xHPqEFpFpC9RLHZaUde4=";
  };

  renderer = buildNpmPackage {
    inherit nodejs src version;
    pname = "${name}-renderer";
    npmDepsHash = "sha256-n0QerkXGKzRPy28qfCDiY7uWEtVnT5walNB5AFi85ck=";

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
  inherit
    nodejs
    src
    version
    renderer
    ;

  pname = name;

  npmDepsHash = "sha256-RUQMmoj+r5eUvS2vXE4ZR5PHJkVk4Nw2ezDEX2O8pEI=";
  makeCacheWritable = true;

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
    libxcb
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_OVERRIDE_DIST_PATH = electron.dist;
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  prePatch = "cd main";

  postInstall = /* bash */ ''
    ln -s $renderer/* $out/lib/node_modules/'${name}'/dist/
    makeWrapper '${lib.getExe electron}' $out/bin/'${name}' \
      --add-flags $out/lib/node_modules/'${name}'/ \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  meta = with lib; {
    homepage = "https://snosme.github.io/awakened-poe-trade/";
    downloadPage = "https://github.com/SnosMe/awakened-poe-trade/releases";
    description = "Path of Exile app for price checking";
    mainProgram = name;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.mithicspirit ];
  };
}
