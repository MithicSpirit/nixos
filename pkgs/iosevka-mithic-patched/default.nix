{
  lib,
  stdenvNoCC,
  emptyDirectory,
  moreutils,
  iosevka-mithic-unpatched,
  nerd-font-patcher,
  base-font ? iosevka-mithic-unpatched,
  patcher ?
    nerd-font-patcher.overrideAttrs (_finalAttrs: prevAttrs: {
      postPatch =
        (prevAttrs.postPatch or "")
        + # bash
        ''
          sed -i 's/\( *\)def setup_font_names(.*):/&\n\1    return/' font-patcher
        '';
    }),
}:
stdenvNoCC.mkDerivation {
  pname = "${base-font.pname}-patched";
  version = "${base-font.version}-${patcher.version}";

  strictDeps = true;
  __structuredAttrs = true;

  src = emptyDirectory;

  nativeBuildInputs = [
    patcher
    moreutils
  ];

  env.font = base-font;

  buildPhase = ''
    runHook preBuild
    parallel -j $NIX_BUILD_CORES \
      nerd-font-patcher --mono --complete --careful --no-progressbars -- \
      "$font/share/fonts/truetype/"*.ttf
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt "$out/share/fonts/truetype" -m644 *
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta =
    base-font.meta
    // {
      maintainers = with lib.maintainers; [
        mithicspirit
      ];
    };
}
