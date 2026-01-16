{...}: {
  programs.bat = {
    enable = true;
    config = {
      tabs = "8";
      style = "numbers,changes";
      theme = "ansi";
      pager = "less --quiet --RAW-CONTROL-CHARS --mouse";
    };
  };
}
