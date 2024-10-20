final: prev: {

  tlp = prev.tlp.overrideAttrs (old: {
    makeFlags = (old.makeFlags or [ ]) ++ [
      "TLP_ULIB=/lib/udev"
      "TLP_SYSD=/lib/systemd/system"
      "TLP_SDSL=/lib/systemd/systemd-sleep"
      "TLP_ELOD=/lib/elogind/systemd-sleep"
    ];
  });

}
