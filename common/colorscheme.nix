let
  nord = {
    nord00 = "2e3440";
    nord00' = "2e3440"; # TODO
    nord01 = "3b4252";
    nord02 = "434c5e";
    nord03 = "4c566a";
    nord04 = "d8dee9";
    nord05 = "e5e9f0";
    nord06 = "eceff4";
    nord07 = "8fbcbb";
    nord08 = "88c0d0";
    nord09 = "81a1c1";
    nord10 = "5e81ac";
    nord11 = "bf616a";
    nord11' = "bf616a"; # TODO
    nord12 = "d08770";
    nord13 = "ebcb8b";
    nord14 = "a3be8c";
    nord14' = "a3be8c"; # TODO
    nord15 = "b48ead";
    nord15' = "b48ead"; # TODO
  };
  palette = with nord; {
    # base16 colors
    base00 = nord00';
    base00' = nord00;
    base01 = nord11;
    base02 = nord14;
    base03 = nord13;
    base04 = nord09;
    base05 = nord15;
    base06 = nord08;
    base07 = nord06;
    base07' = nord05;
    base08 = nord02; # TODO: 1-3
    base09 = nord11';
    base10 = nord14';
    base11 = nord12;
    base12 = nord10;
    base13 = nord15';
    base14 = nord07;
    base15 = nord04;

    # named colors
    floor = nord00;
    bg = nord01;
    shadow = nord02;
    fake = nord03;
    lower = nord04;
    middle = nord05;
    fg = nord06;
    highlight = nord07;
    accent = nord08;
    colored = nord09;
    extra = nord10;
    bad = nord11;
    advanced = nord12;
    warning = nord13;
    good = nord14;
    strange = nord15;
  };
in {
  raw = palette;
  hash = builtins.mapAttrs (_: raw: "#${raw}") palette;
}
