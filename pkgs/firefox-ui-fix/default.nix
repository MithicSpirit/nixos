{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "firefox-ui-fix";
  version = "8.7.2_r1_g5e49ab0";

  src = fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "5e49ab0a9a8cb18504c5ec7305ec64f1430a3b4b";
    hash = "sha256-III8hMMe7WAQ2AEve1ztmBb+aCh+k7tnf8V3IYbGVYo=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r ./ "$out/chrome"
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/black7375/Firefox-UI-Fix";
    downloadPage = "https://github.com/black7375/Firefox-UI-Fix/releases";
    description = "An improvement to Firefox's Proton UI.";
    longDescription = ''
      Custom userChrome.css and user.js for Firefox that improves on the Proton
      UI.
    '';
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = [ maintainers.mithicspirit ];
  };
}
