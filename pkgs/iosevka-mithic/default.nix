# TODO: investigate italic /slashes/ being slanted
{ stdenv, lib, buildNpmPackage, fetchFromGitHub, fetchzip, darwin, unzip
, ttfautohint-nox, python3, fontforge, }:
buildNpmPackage rec {
  pname = "iosevka-mithic";
  version = "30.3.0";
  patcher-version = "3.2.1";

  iosevka = fetchFromGitHub {
    owner = "be5invis";
    repo = "iosevka";
    rev = "v${version}";
    hash = "sha256-WWumGi6+jaQUGi1eArS9l3G8sOQL4ZetixVB5RWDPQ4=";
    name = "iosevka";
  };

  patcher = fetchzip {
    url =
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v${patcher-version}/FontPatcher.zip";
    hash = "sha256-3s0vcRiNA/pQrViYMwU2nnkLUNUcqXja/jTWO49x3BU=";
    stripRoot = false;
    name = "patcher";
  };

  srcs = [ iosevka patcher ];
  sourceRoot = "./${iosevka.name}";

  npmDepsHash = "sha256-Gm3R8lWmYbLOfyGW+f8CYXlodp11vMCMAhagILxLKFA=";

  nativeBuildInputs = [ unzip ttfautohint-nox python3 fontforge ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.cctools # libtool
    ];

  patchPhase = ''
    runHook prePatch
    cp -r ../${patcher.name} patcher
    chmod -R u+w patcher
    sed -i 's/\( *\)def setup_font_names(.*):/&\n\1    return/' \
      patcher/font-patcher
    runHook postPatch
  '';

  configurePhase = ''
    runHook preConfigure
    cp ${./build-plans.toml} "private-build-plans.toml"
    runHook postConfigure
  '';

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild
    npm run build --no-update-notifier --targets super-ttc::IosevkaMithic \
      -- --jCmd=$NIX_BUILD_CORES --verbose=9 \
      | cat  # clean up output
    python patcher/font-patcher --mono --complete --careful \
      "dist/.super-ttc/IosevkaMithic.ttc"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    fontdir="$out/share/fonts/truetype"
    install -dm755 "$fontdir"
    install "Iosevka Mithic.ttc" "$fontdir/$pname.ttc"
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
    maintainers = [{
      name = "MithicSpirit";
      email = "rpc01234@gmail.com";
      github = "MithicSpirit";
      githubId = 24192522;
    }];
  };
}
