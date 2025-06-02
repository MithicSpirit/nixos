{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchzip,
  darwin,
  unzip,
  ttfautohint-nox,
  python3,
  fontforge,
  moreutils,
}:
let
  version = "33.2.4";
  patcher-version = "3.4.0";

  iosevka = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    rev = "v${version}";
    hash = "sha256-1QxM9PWZirAKIdd/kzHLDStXbkxTGr0q8GQSER2NEXc=";
    name = "iosevka";
  };
  npmDepsHash = "sha256-1XRbwd1x7ofQGnEth7U8QAHX92QDHMm4OmQAQgZZLTw=";

  patcher = fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${patcher-version}/FontPatcher.zip";
    hash = "sha256-JR4sxV2yOXtrnIjFBh4as304BjNIcKkBzxOKLxrjo2I=";
    stripRoot = false;
    name = "patcher";
  };

  build-plans = ./build-plans.toml;
in
buildNpmPackage {
  inherit version npmDepsHash;

  pname = "iosevka-mithic";

  srcs = [
    iosevka
    patcher
  ];

  sourceRoot = "./${iosevka.name}";

  nativeBuildInputs =
    [
      unzip
      ttfautohint-nox
      python3
      fontforge
      moreutils
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.cctools # libtool
    ];

  patchPhase = ''
    runHook prePatch
    cp -r "../${patcher.name}" patcher #" # (fix syntax highlighting)
    chmod -R u+w patcher
    sed -i 's/\( *\)def setup_font_names(.*):/&\n\1    return/' \
      patcher/font-patcher
    runHook postPatch
  '';

  configurePhase = ''
    runHook preConfigure
    cp "${build-plans}" "./private-build-plans.toml" #" #
    runHook postConfigure
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild
    npm run build --no-update-notifier --targets ttf::IosevkaMithic \
      -- --jCmd=$NIX_BUILD_CORES --verbose=9 \
      | cat  # clean up output
    parallel -j $NIX_BUILD_CORES \
      python patcher/font-patcher --mono --complete --careful -- \
      dist/IosevkaMithic/TTF/*.ttf
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt "$out/share/fonts/truetype" -m644 *.ttf
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
}
