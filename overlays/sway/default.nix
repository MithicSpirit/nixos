_final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (prevAttrs: {
    patches = prevAttrs.patches ++ [./exec_output.patch];
  });
}
