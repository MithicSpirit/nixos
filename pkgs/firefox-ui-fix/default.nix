{ stdenv, lib, fetchFromGitHub, }:
stdenv.mkDerivation rec {
  pname = "firefox-ui-fix";
  version = "8.6.1";

  src = fetchFromGitHub {
    owner = "black7375";
    repo = "Firefox-UI-Fix";
    rev = "v${version}";
    hash = "sha256-OP+gD4sJWfGSjZu2yGkkWct7A0YqVcwE+EmNDixAVGs=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';

  enableParallelBuilding = true;

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
    maintainers = [{
      name = "MithicSpirit";
      email = "rpc01234@gmail.com";
      github = "MithicSpirit";
      githubId = 24192522;
    }];
  };
}
