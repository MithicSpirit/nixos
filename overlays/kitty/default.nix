_final: prev: {
  kitty = prev.kitty.overrideAttrs (old: {
    patches = old.patches ++ [./shade-transparency.patch];
  });
}
