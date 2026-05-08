{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  util-linux,
  libqalculate,
  wl-clipboard,
  menu ? null,
}:
stdenvNoCC.mkDerivation rec {
  pname = "qalcmenu";
  version = "v1.4.2";

  src = fetchFromGitHub {
    owner = "MithicSpirit";
    repo = pname;
    rev = "8d778983d7938941b52327fa230c67e1b50e19fd";
    sha256 = "sha256-77mhGKUHMtf/1rO/ibBezyG+XR0wxRXJ733tF3bD5uk=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  installPhase = let
    path =
      [
        util-linux
        libqalculate
        wl-clipboard
      ]
      ++ (
        if menu != null
        then [menu]
        else []
      );
  in
    # bash
    ''
      runHook preInstall

      installManPage ./qalcmenu.1 ./=.1

      install -Dm755 -t "$out/bin" ./qalcmenu
      wrapProgram "$out/bin/qalcmenu" --prefix PATH : "${lib.makeBinPath path}"
      ln -sT qalcmenu "$out/bin/="

      runHook postInstall
    '';

  meta = with lib; {
    homepage = "https://github.com/MithicSpirit/qalcmenu";
    description = "A qalc frontend for menus like rofi, bemenu, and dmenu";
    longDescription = ''
      A qalc frontend for menus like rofi, bemenu and dmenu. Qalcmenu is a fork
      of menu-qalc, but supporting primarily Wayland instead of X, and with more
      robust command line arguments.
    '';
    license = licenses.agpl3Plus;
    platforms = platforms.all;
    maintainers = [maintainers.mithicspirit];
    mainProgram = "qalcmenu";
  };
}
