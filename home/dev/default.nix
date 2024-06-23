{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # c/++
    gcc
    (lib.setPrio (gcc.meta.priority + 1) clang)

    # python
    python3
    ruff
    uv
    mypy

    # rust
    rustc
    cargo
    rustfmt

    # haskell
    ghc
    # cabal

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
  ];
}
