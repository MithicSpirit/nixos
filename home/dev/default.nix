{
  pkgs,
  lib,
  config,
  ...
}:
{

  imports = [
    ./rust.nix
    ./python.nix
    ./tex
  ];

  home.packages = with pkgs; [
    zig
    elan
    agda
    coq
    idris2
    smlnj
    typst

    # c/++
    gcc
    (lib.setPrio (gcc.meta.priority + 1) clang)
    clang-tools
    binutils

    # haskell
    ghc
    stack

    # tooling
    gnumake
    just
    gdb
    gh
    glab
    scc
    tokei # TODO: decide between scc and tokei
    rlwrap # idris2 repl improvement
  ];

  home.sessionVariables = {
    "ELAN_HOME" = "${config.xdg.dataHome}/elan";
    "STACK_XDG" = "1";
  };

}
