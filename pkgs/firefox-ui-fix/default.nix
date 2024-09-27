{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "firefox-ui-fix";
  version = "8.6.3";

  src = fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "v${version}";
    hash = "sha256-Id3YphCYrnw1vWy/z2psAEM71Tvy0t5q8pVdxneKYRg=";
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
    maintainers = [
      {
        name = "MithicSpirit";
        email = "rpc01234@gmail.com";
        github = "MithicSpirit";
        githubId = 24192522;
      }
    ];
  };
}
