{
  lib,
  python3Packages,
  fetchFromGitHub,
  fw-ectool,
}:
let
  checksum = "2a9828f91620c0e8746ecb6875887b34da7888e3";
  version = "2024-08-25a.g${checksum}";
  pname = "fw-fanctrl";
in
python3Packages.buildPythonPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "TamtamHero";
    repo = pname;
    rev = checksum;
    hash = "sha256-vltQwR2pdtyCsKlVmlLgZs/vZqza9YzQTr1/PZk44wA=";
  };

  patchPhase = ''
    cp '${./pyproject.toml}' './pyproject.toml'
  '';
  pyproject = true;

  build-system = [ python3Packages.setuptools ];
  dependencies = [ fw-ectool ];

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
