{ ... }: {
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      nixGrammars = true;
      nixvimInjections = true;
      ignoreInstall = [ ];
      disabledLanguages = [ "latex" ]; # highlighting
      folding = true;
      indent = true;
    };
  };
}
