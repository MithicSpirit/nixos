{ pkgs, config, ... }:
let
  texmf = "${config.xdg.dataHome}/texmf";
in
{

  home.packages = with pkgs; [
    (texliveFull.__overrideTeXConfig { withDocs = true; })
    tectonic
    python3Packages.pygments # minted
  ];

  # don't set the variable directly to ./texmf since that prevents updating
  home.file.${texmf}.source = ./texmf;
  home.sessionVariables."TEXMFHOME" = texmf;

  xdg.configFile.".chktexrc" = {
    source = ./chktexrc;
    executable = false;
  };
  home.sessionVariables."CHKTEXRC" = config.xdg.configHome;

  xdg.configFile."latexmk/latexmkrc" = {
    source = ./latexmkrc;
    executable = false;
  };

}
