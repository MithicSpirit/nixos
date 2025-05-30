_final: prev: {
  zathuraPkgs = prev.zathuraPkgs.overrideScope (
    _finalScope: prevScope: {

      zathura_core = prevScope.zathura_core.overrideAttrs (prevAttrs: {
        patches = (prevAttrs.patches or [ ]) ++ [ ./recolor_alpha.diff ];
      });

    }
  );
}
