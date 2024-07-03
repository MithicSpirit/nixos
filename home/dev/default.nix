{ pkgs, lib, ... }: {

  imports = [ ./rust.nix ./python.nix ];

  home.packages = with pkgs; [
    # c/++
    gcc
    (lib.setPrio (gcc.meta.priority + 1) clang)

    # haskell
    ghc
    cabal-install

    # proof assistants
    lean4
    agda
    coq
    idris
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
