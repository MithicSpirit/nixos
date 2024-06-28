{ pkgs, lib, ... }: {

  imports = [ ./rust.nix ];

  home.packages = with pkgs; [
    # c/++
    gcc
    (lib.setPrio (gcc.meta.priority + 1) clang)

    # python
    python3
    python3Packages.ipython
    ruff
    uv
    mypy
    basedpyright

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
