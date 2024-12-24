{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "firefox-ui-fix";
  version = "8.6.5";

  src = fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "v${version}";
    hash = "sha256-8sRUGrKcSBDzqIjACR7eRfn4VzFbL3zfRB8GDsNKO5A=";
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
