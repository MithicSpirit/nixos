{...}: {
  programs.man = {
    enable = true;
    generateCaches = true;
  };

  home.sessionVariables = {
    "MANPAGER" = "less";
    "MANROFFOPT" = "-c";
    "MANWIDTH" = "80";
  };
}
