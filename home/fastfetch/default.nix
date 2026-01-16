{...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        "title"
        "separator"
        {
          type = "os";
          format = "{name} {build-id} ({codename}) {arch}";
        }
        "kernel"
        "uptime"
        "packages"
        "de"
        "wm"
        "wmtheme"
        "theme"
        "icons"
        "cursor"
        "font"
        "shell"
        "terminal"
        "terminalfont"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "display"
        "break"
        "colors"
      ];
    };
  };
}
