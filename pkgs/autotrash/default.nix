{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  pandoc,
}:
let
  pname = "autotrash";
  version = "0.4.7";
in
python3Packages.buildPythonPackage {
  inherit pname version;

  pyproject = true;
  src = fetchFromGitHub {
    owner = "bneijt";
    repo = pname;
    rev = "0.4.7";
    hash = "sha256-qMU3jjBL5+fd9vKX5BIqES5AM8D/54aBOmdHFiBtfEo=";
  };

  build-system = [ python3Packages.poetry-core ];

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  postBuild = ''
    make -C doc '${pname}.1'
  '';

  postInstall = ''
    installManPage 'doc/${pname}.1'
  '';

  meta = with lib; {
    homepage = "https://github.com/bneijt/${pname}";
    description = "Tool to automatically purge old trashed files";
    longDescription = ''
      Autotrash is a small python script to automatically remove (permanently
      delete) trashed files. It relies on the FreeDesktop.org Trash files for
      it's deletion information. It should work for most modern desktops,
      including KDE and GNOME.

      It scans the `~/.local/share/Trash/info` directory and reads the
      `.trashinfo` files to determine their deletion date. Files older then 30
      days or files matching a particular regular expression are then purged,
      including their trash information file.
    '';
    mainProgram = "autotrash";
    license = licenses.gpl3Only;
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
