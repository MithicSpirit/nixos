{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitLab,
  gradle_9,
  jdk25,
  libGL,
  xwininfo,
  xprop,
  wmctrl,
  makeWrapper,
  stripJavaArchivesHook,
}: let
  gradle = gradle_9;
  jdk = jdk25;
  unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "eve-rift";
    version = "5.16.1";

    src = fetchFromGitLab {
      owner = "rift-intel-fusion-tool";
      repo = "rift-intel-fusion-tool";
      rev = "af9ba98a5808221527bce058bc0bd8818336a9bb";
      hash = "sha256-BYvIdVJ9WhYbYQPxmvXFo9OqZQEPmvGmBmSBekJ7hcQ=";
    };

    patches = [./unlock-java.diff];

    nativeBuildInputs = [
      gradle
      jdk
      stripJavaArchivesHook
    ];

    mitmCache = gradle.fetchDeps {
      pkg = finalAttrs.finalPackage;
      data = ./deps.json;
    };
    gradleBuildTask = "createDistributable";
    gradleUpdateTask = "createDistributable";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"/
      cp -dprt "$out"/ build/compose/binaries/main/app/rift/*

      runHook postInstall
    '';

    meta = {
      description = "All your EVE Online intel in one place";
      homepage = "https://riftforeve.online/";
      maintainer = [lib.maintainers.mithicspirit];
      mainProgram = "rift";
    };
  });
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    inherit (finalAttrs.src) version meta;

    pname = "${finalAttrs.src.pname}-wrapped";

    src = unwrapped;

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"/bin
      makeWrapper "$src"/bin/rift "$out"/bin/rift \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libGL]}" \
        --prefix PATH : "${lib.makeBinPath [xwininfo xprop wmctrl]}"

      runHook postInstall
    '';
  })
