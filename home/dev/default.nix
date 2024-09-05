{ pkgs, lib, ... }:
{

  imports = [
    ./rust.nix
    ./python.nix
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

    # (La)TeX
    texliveFull
    tectonic

    # tooling
    gnumake
    just
    gdb
    gh
    scc
    rlwrap # idris2 repl improvement
  ];

}
