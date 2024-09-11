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

    # c/++
    gcc
    (lib.setPrio (gcc.meta.priority + 1) clang)

    # haskell
    ghc
    stack

    # proof assistants
    elan
    agda
    coq
    idris2

    # tooling
    gnumake
    just
    gdb
    gh
    scc
    rlwrap # idris2 repl improvement
  ];

  home.sessionVariables = {
    "ELAN_HOME" = "${config.xdg.dataHome}/elan";
    "STACK_XDG" = "1";
  };

}
