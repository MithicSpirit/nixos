{
  lib,
  python3Packages,
  fetchFromGitHub,
  fw-ectool,
}:
let
  pname = "fw-fanctrl";
  version = "1.0.2-criticalTemp";
in
python3Packages.buildPythonApplication {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "TamtamHero";
    repo = pname;
    rev = "80ecc5d273b46f715d924c49234b6867fe3daf33";
    hash = "sha256-ZWUopNfIxSr5y3M+PwGPM17R4Y2ygRNlmt/81+4ZoHs=";
  };

  patches = [ ./criticalTemp.patch ];

  pyproject = true;

  build-system = [ python3Packages.setuptools ];
  dependencies = [ python3Packages.jsonschema ];

  propagatedBuildInputs = [ fw-ectool ];

  meta = with lib; {
    homepage = "https://github.com/TamtamHero/fw-fanctrl";
    description = "A simple service to better control Framework Laptop's fan(s)";
    longDescription = ''
      Fw-fanctrl is a simple Python CLI service that controls Framework Laptop's
      fan(s) speed according to a configurable speed/temperature curve.
    '';
    mainProgram = "fw-fanctrl";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.mithicspirit ];
  };
}
