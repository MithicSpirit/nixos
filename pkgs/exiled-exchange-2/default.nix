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
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "Kvan7";
    repo = name;
    rev = "v${version}";
    hash = "sha256-h1g/V5iqzm4kL6elVMT13NwmnGGs1fmgxAH7xS+Vl0I=";
  };

  renderer = buildNpmPackage {
    inherit nodejs src version;
    pname = "${name}-renderer-data";
    npmDepsHash = "sha256-HNgJ8iagwaRcAoQ72YqJ76dinNZDNLy8WCcz4YdVzuo=";

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

  pname = name;

  npmDepsHash = "sha256-P7o4ICCb87Dtz19PQS5ZW5huQIZa1oVeRDxtLrclKC8=";

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
  };

  prePatch = "cd main";

  postInstall = ''
    ln -s ${renderer}/* $out/lib/node_modules/${name}/dist/
    makeWrapper ${electron}/bin/electron $out/bin/${name} \
      --add-flags $out/lib/node_modules/${name}/dist/main.js
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
