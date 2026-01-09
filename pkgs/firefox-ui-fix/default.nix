{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "firefox-ui-fix";
  version = "8.7.5";

  src = fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "aa9fc543b391f8982141446da15c98221438e227";
    hash = "sha256-YG8C1FgXZHdG4K7xs44paOWuOr256S8Z2dCPA1MhxUo=";
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
