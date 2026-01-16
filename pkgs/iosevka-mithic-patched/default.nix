{
  stdenvNoCC,
  lib,
  iosevka-mithic-unpatched,
  fetchzip,
  unzip,
  python3,
  fontforge,
  moreutils,
  base-font ? iosevka-mithic-unpatched,
}: let
  patcher-version = "3.4.0";
in
  stdenvNoCC.mkDerivation {
    pname = "${base-font.pname}-patched";

    version = "${base-font.version}-${patcher-version}";

    src = fetchzip {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${patcher-version}/FontPatcher.zip";
      hash = "sha256-koZj0Tn1HtvvSbQGTc3RbXQdUU4qJwgClOVq1RXW6aM=";
    };

    nativeBuildInputs = [
      unzip
      python3
      fontforge
      moreutils
    ];

    patchPhase = ''
      runHook prePatch
      install -Dt base -m644 "${base-font}/share/fonts/truetype/"*.ttf #" #
      sed -i 's/\( *\)def setup_font_names(.*):/&\n\1    return/' font-patcher
      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild
      parallel -j $NIX_BUILD_CORES \
        python font-patcher --mono --complete --careful --no-progressbars -- \
        base/*.ttf
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
      maintainers = [maintainers.mithicspirit];
    };
  }
