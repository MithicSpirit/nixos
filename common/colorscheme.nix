let
  palette = {
    floor = "2e3440";
    bg = "3b4252";
    shadow = "43c5e";
    fake = "4c566a";
    lower = "d8dee9";
    middle = "e5e9f0";
    fg = "eceff4";
    highlight = "8fbcbb";
    accent = "88c0d0";
    colored = "81a1c1";
    extra = "5e81ac";
    bad = "bf616a";
    advanced = "d08770";
    warning = "ebcb8b";
    good = "a3be8c";
    strange = "b48ead";
  };
in {
  numbers = palette;
  hash = builtins.mapAttrs (_: raw: "#${raw}") palette;
}
