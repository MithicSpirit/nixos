{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  darwin,
  ttfautohint-nox,
}:
buildNpmPackage (finalAttrs: {
  pname = "iosevka-mithic";

  version = "33.2.8";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rHkIvfS20A0cvFBcLfFLAvcVVF5BgbtMdDxMvwH0B+I=";
  };

  npmDepsHash = "sha256-PYzNg5gduwtwc99GyatXnmHCh9mpAulz43Ehdle0rAM=";

  nativeBuildInputs = [
    ttfautohint-nox
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.cctools # libtool
  ];

  configurePhase = ''
    runHook preConfigure
    cp "${./build-plans.toml}" "./private-build-plans.toml" #" #
    runHook postConfigure
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild
    npm run build --no-update-notifier --targets ttf::IosevkaMithic \
      -- --jCmd=$NIX_BUILD_CORES --verbose=9 \
      | cat  # clean up output
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt "$out/share/fonts/truetype" -m644 dist/IosevkaMithic/TTF/*.ttf
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://typeof.net/Iosevka/";
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = "A custom configuration of the Iosevka monospace font";
    longDescription = ''
      This font is a mostly sans-serif and monospace build of Iosevka, patched
      for nerd symbols. It includes many ligatures.

      Iosevka is an open-source, sans-serif + slab-serif, monospace +
      quasi‑proportional typeface family, designed for writing code, using in
      terminals, and preparing technical documents.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.mithicspirit ];
  };
})
