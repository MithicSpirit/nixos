{
  lib,
  vimUtils,
  fennel,
  python3,
}:
vimUtils.buildVimPlugin {

  pname = "mithic-nvim"; # mithic.nvim
  version = "";

  src = ./mithic.nvim;

  buildPhase = ''
    python3 build.py
    cd out
  '';

  nativeBuildInputs = [
    fennel
    python3
  ];

  meta = with lib; {
    description = "MithicSpirit's Neovim configuration";
    platforms = platforms.all;
    maintainers = [ maintainers.mithicspirit ];
  };
}
