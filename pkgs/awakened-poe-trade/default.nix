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
  musl,
}:
buildNpmPackage (finalAttrs: {
  inherit nodejs;

  pname = "awakened-poe-trade";
  version = "3.29.102";

  src = fetchFromGitHub {
    owner = "SnosMe";
    repo = "awakened-poe-trade";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MT4yDUWOD/BRhwa0BdDqaCq0G3FLF7tCbv9EqLAzDyc=";
  };

  renderer = buildNpmPackage {
    inherit (finalAttrs) nodejs src version;
    name = "${finalAttrs.pname}-${finalAttrs.version}-renderer";
    npmDepsHash = "sha256-rjEIYSAjv0ItQIYq6iNYfI41EA9pKn5FSE+9GQGDE/w=";

    prePatch = "cd renderer";
    preBuild = "npm run make-index-files";
    installPhase = ''
      mkdir -p "$out"
      cp -rf public/* "$out"
      cp -rf dist/* "$out"
    '';
  };

  npmDepsHash = "sha256-mHAF7gsa/1/MPPJQWT+4uLj26qWqmzPm3KuqJg++Nqs=";
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
    musl
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_OVERRIDE_DIST_PATH = electron.dist;
  };

  prePatch = "cd main";

  postInstall = ''
    ln -s "$renderer"/* "$out"/lib/node_modules/awakened-poe-trade/dist/
    makeWrapper '${lib.getExe electron}' "$out"/bin/awakened-poe-trade \
      --add-flags $out/lib/node_modules/awakened-poe-trade/ \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0
  '';

  meta = with lib; {
    homepage = "https://snosme.github.io/awakened-poe-trade/";
    downloadPage = "https://github.com/SnosMe/awakened-poe-trade/releases";
    description = "Path of Exile app for price checking";
    mainProgram = "awakened-poe-trade";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [maintainers.mithicspirit];
  };
})
