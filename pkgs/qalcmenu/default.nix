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
  version = "2023.11.27";

  src = fetchFromGitHub {
    owner = "MithicSpirit";
    repo = pname;
    rev = "8cef8a6348a9e88e3ff32529a5a4be3979729f2d";
    sha256 = "sha256-14/wB7x6VBVr6I4WxcwCBICCaIwL7FfNQBTUS490sqI=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  installPhase =
    let
      path = [
        util-linux
        libqalculate
        wl-clipboard
      ]
      ++ (if menu != null then [ menu ] else [ ]);
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
    maintainers = [ maintainers.mithicspirit ];
    mainProgram = "qalcmenu";
  };

}
