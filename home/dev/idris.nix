{
  pkgs,
  lib,
  ...
}: let
  toml = (pkgs.formats.toml {}).generate;
in {
  home.packages = with pkgs; [
    idris2
    idris2Packages.pack
    rlwrap # repl improvement
  ];

  xdg.configFile."pack/pack.toml".source = toml "pack.toml" {
    install = {
      with-src = true;
      with-docs = true;
      safety-prompt = true;
      gc-prompt = true;
      gc-purge = true;
      warn-depends = true;
      libs = ["toml" "elab-util"];
      apps = ["idris2-lsp"];
    };
    idris2 = {
      bootstrap = false;
      bootstrap-stage3 = true;
      codegen = "chez";
      scheme = "${lib.getExe pkgs.chez}";
      repl.rlwrap = true;
      git = true;
    };
  };
}
