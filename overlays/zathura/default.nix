_final: prev: {
  zathuraPkgs = prev.zathuraPkgs.overrideScope (
    _finalScope: prevScope: {
      zathura_cb = prevScope.zathura_cb.overrideAttrs (
        _finalAttrs: prevAttrs: {
          postPatch =
            (prevAttrs.postPatch or "")
            + ''
              substituteInPlace ./data/org.pwmt.zathura-cb.desktop \
                --replace-fail "application/x-rar;" "" \
                --replace-fail "application/zip;" "" \
                --replace-fail "application/x-7z-compressed;" "" \
                --replace-fail "application/x-tar;" "" \
                --replace-fail "inode/directory;" ""
            '';
        }
      );
    }
  );
}
