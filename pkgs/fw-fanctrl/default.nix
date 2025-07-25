{
  lib,
  python3Packages,
  fetchFromGitHub,
  fw-ectool,
}:
let
  pname = "fw-fanctrl";
  version = "1.0.3_criticalTemp";
in
python3Packages.buildPythonApplication {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "TamtamHero";
    repo = pname;
    rev = "b35c9280a3b4a3cf5b0cd551efa3adca6aa6a7d1";
    hash = "sha256-TDVULNb/oH66/UX20mC89NSx8YPe8mPwNCB9+phavP4=";
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
